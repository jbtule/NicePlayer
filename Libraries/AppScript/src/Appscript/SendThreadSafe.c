/*
    File:       AESendThreadSafe.c

    Contains:   Code to send Apple events in a thread-safe manner.

    Written by: DTS

    Copyright:  Copyright (c) 2007 Apple Inc. All Rights Reserved.

    Disclaimer: IMPORTANT: This Apple software is supplied to you by Apple Inc.
                ("Apple") in consideration of your agreement to the following
                terms, and your use, installation, modification or
                redistribution of this Apple software constitutes acceptance of
                these terms.  If you do not agree with these terms, please do
                not use, install, modify or redistribute this Apple software.

                In consideration of your agreement to abide by the following
                terms, and subject to these terms, Apple grants you a personal,
                non-exclusive license, under Apple's copyrights in this
                original Apple software (the "Apple Software"), to use,
                reproduce, modify and redistribute the Apple Software, with or
                without modifications, in source and/or binary forms; provided
                that if you redistribute the Apple Software in its entirety and
                without modifications, you must retain this notice and the
                following text and disclaimers in all such redistributions of
                the Apple Software. Neither the name, trademarks, service marks
                or logos of Apple Inc. may be used to endorse or promote
                products derived from the Apple Software without specific prior
                written permission from Apple.  Except as expressly stated in
                this notice, no other rights or licenses, express or implied,
                are granted by Apple herein, including but not limited to any
                patent rights that may be infringed by your derivative works or
                by other works in which the Apple Software may be incorporated.

                The Apple Software is provided by Apple on an "AS IS" basis. 
                APPLE MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING
                WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT,
                MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING
                THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
                COMBINATION WITH YOUR PRODUCTS.

                IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT,
                INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
                TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
                DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY
                OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION
                OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY
                OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR
                OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF
                SUCH DAMAGE.

    Change History (most recent first):

$Log: AESendThreadSafe.c,v $
Revision 1.3  2007/02/27 10:45:15         
In the destructor, add an assert that the thread-local storage has been set to NULL. Also fixed a comment typo.

Revision 1.2  2007/02/12 11:59:09         
Added a type cast for the malloc result.

Revision 1.1  2007/02/09 10:55:24         
First checked in.


*/

/*

2007/06/24 -- Modified by HAS to make AESendMessageThreadSafeSynchronous API-compatible with AESendMessage; renamed SendMessageThreadSafe.

*/

/////////////////////////////////////////////////////////////////

#include "SendThreadSafe.h"

#include <pthread.h>
#include <mach/mach.h>

/////////////////////////////////////////////////////////////////

/*
    How It Works
    ------------
    The basic idea behind this module is that it uses per-thread storage to keep 
    track of an Apple event reply for any given thread.  The first time that the 
    thread calls AESendMessageThreadSafeSynchronous, the per-thread storage will 
    not be initialised and the code will grab an Apple event reply port and 
    assign it to the per-thread storage.  Subsequent calls to AESendMessageThreadSafeSynchronous 
    will continue to use that port.  When the thread dies, pthreads will automatically 
    call the destructor for the per-thread storage, and that will clean up the port.
    
    Because we can't dispose of the reply port (without triggering the Apple 
    Event Manager bug that's the reason we wrote this code in the first place), 
    the destructor doesn't actually dispose of the port.  Rather, it adds the 
    port to a pool of ports that are available for reuse.  The next time a thread 
    needs to allocate a port, it will grab it from the pool rather than allocating 
    it from scratch.

    This technique means that the code still 'leaks' Apple event reply ports, but 
    the size of the leak is limited to the maximum number of threads that you run 
    simultaneously.  This isn't a problem in practice.
*/

/////////////////////////////////////////////////////////////////

// The PerThreadStorage structure is a trivial wrapper around the Mach port.  
// I added this because I need to attach this structure a thread using 
// per-thread storage.  The API for that (<x-man-page://3/pthread_setspecific>) 
// is pointer based.  I could've just cast the Mach port to a (void *), but 
// that's ugly because of a) pointer size issues (are pointers always bigger than 
// ints?), and b) because it implies an equivalent between NULL and MACH_PORT_NULL.
// Given this, I simply decided to create a structure to wrap the Mach port.

enum {
    kPerThreadStorageMagic = 'PTSm'
};

struct PerThreadStorage {
    OSType          magic;          // must be kPerThreadStorageMagic
    mach_port_t     port;
};
typedef struct PerThreadStorage PerThreadStorage;

// The following static variables manage the per-thread storage key 
// (sPerThreadStorageKey) and the pool of Mach ports (wrapped in 
// PerThreadStorage structures) that are not currently attached to a thread.

static pthread_once_t       sInited = PTHREAD_ONCE_INIT;    // covers initialisation of all of the 
                                                            // following static variables

static OSStatus             sPerThreadStorageKeyInitErrNum; // latches result of initialisation

static pthread_key_t        sPerThreadStorageKey = 0;       // key for our per-thread storage

static pthread_mutex_t      sPoolMutex;                     // protects sPool
static CFMutableArrayRef    sPool;                          // array of (PerThreadStorage *), holds 
                                                            // the ports that aren't currently bound to 
                                                            // a thread

static void PerThreadStorageDestructor(void *keyValue);     // forward declaration

static void InitRoutine(void)
    // Call once (via pthread_once) to initialise various static variables.
{
    OSStatus    err;
    
    // Create the per-thread storage key.  Note that we assign a destructor to this key; 
    // pthreads call the destructor to clean up that item of per-thread storage whenever 
    // a thread terminates.
    
    err = (OSStatus) pthread_key_create(&sPerThreadStorageKey, PerThreadStorageDestructor);
    
    // Create the pool of Mach ports that aren't bound to any thread, and its associated 
    // lock.  The pool starts out empty.
    
    if (err == noErr) {
        err = (OSStatus) pthread_mutex_init(&sPoolMutex, NULL);
    }
    if (err == noErr) {
        sPool = CFArrayCreateMutable(NULL, 0, NULL);
        if (sPool == NULL) {
            err = coreFoundationUnknownErr;
        }
    }
    assert(err == 0);
    
    sPerThreadStorageKeyInitErrNum = err;
}

static OSStatus AllocatePortFromPool(PerThreadStorage **storagePtr)
    // Grab a Mach port from sPool; if sPool is empty, create one.
{
    OSStatus            err;
    OSStatus            junk;
    PerThreadStorage *  storage;
    
    assert( storagePtr != NULL);
    assert(*storagePtr == NULL);
    
    storage = NULL;
    
    // First try to get an entry from pool.  We try to grab the last one because 
    // that minimises the amount of copying that CFArrayRemoveValueAtIndex has to 
    // do.
    
    err = (OSStatus) pthread_mutex_lock(&sPoolMutex);
    if (err == noErr) {
        CFIndex             poolCount;
        
        poolCount = CFArrayGetCount(sPool);
        if (poolCount > 0) {
            storage = (PerThreadStorage *) CFArrayGetValueAtIndex(sPool, poolCount - 1);
            CFArrayRemoveValueAtIndex(sPool, poolCount - 1);
        }
        
        junk = (OSStatus) pthread_mutex_unlock(&sPoolMutex);
        assert(junk == noErr);
    }

    // If we failed to find an entry in the pool, create a new one.

    if ( (err == noErr) && (storage == NULL) ) {
        storage = (PerThreadStorage *) malloc(sizeof(*storage));
        if (storage == NULL) {
            err = memFullErr;
        } else {
            storage->magic = kPerThreadStorageMagic;
            storage->port  = MACH_PORT_NULL;

            err = (OSStatus) mach_port_allocate(mach_task_self(), MACH_PORT_RIGHT_RECEIVE, &storage->port);
            if (err != noErr) {
                assert(storage->port == MACH_PORT_NULL);
                free(storage);
                storage = NULL;
            }
        }
    }
    if (err == noErr) {
        *storagePtr = storage;
    }
    
    assert( (err == noErr) == (*storagePtr != NULL) );
    assert( (*storagePtr == NULL) || ((*storagePtr)->magic == kPerThreadStorageMagic) );
    assert( (*storagePtr == NULL) || ((*storagePtr)->port  != MACH_PORT_NULL) );
    
    return err;
}

static void ReturnPortToPool(PerThreadStorage * storage)
    // Returns a port to sPool.
{
    OSStatus err;

    assert(storage != NULL);
    assert(storage->magic == kPerThreadStorageMagic);
    assert(storage->port  != MACH_PORT_NULL);

    err = (OSStatus) pthread_mutex_lock(&sPoolMutex);
    if (err == noErr) {
        CFArrayAppendValue(sPool, storage);
        
        err = (OSStatus) pthread_mutex_unlock(&sPoolMutex);
    }
    assert(err == noErr);
}

// Main Thread Notes
// -----------------
// There are two reasons why we don't assign a reply port to the main thread. 
// First, the main thread already has a reply port created for it by Apple 
// Event Manager.  Thus, we don't need a specific reply port.  Also, the 
// destructor for per-thread storage isn't called for the main thread, so 
// we wouldn't get a chance to clean up (although that's not really a problem 
// in practice).

static OSStatus BindReplyMachPortToThread(mach_port_t *replyPortPtr)
    // Get a reply port for this thread, remembering that we've done this 
    // in per-thread storage.
    // 
    // On success, *replyPortPtr is the port to use for this thread's reply 
    // port.  It will be MACH_PORT_NULL if you call it from the main thread.
{
    OSStatus    err;
    
    assert( replyPortPtr != NULL);
    assert(*replyPortPtr == MACH_PORT_NULL);

    // Initialise ourselves the first time that we're called.
    
    err = (OSStatus) pthread_once(&sInited, InitRoutine);
    
    // If something went wrong, return the latched error.
    
    if ( (err == noErr) && (sPerThreadStorageKeyInitErrNum != noErr) ) {
        err = sPerThreadStorageKeyInitErrNum;
    }
    
    // Now do the real work.
    
    if (err == noErr) {
        if ( pthread_main_np() ) {
            // This is the main thread, so do nothing; leave *replyPortPtr set 
            // to MACH_PORT_NULL.
            assert(*replyPortPtr == MACH_PORT_NULL);
        } else {
            PerThreadStorage *  storage;

            // Get the per-thread storage for this thread.
            
            storage = (PerThreadStorage *) pthread_getspecific(sPerThreadStorageKey);
            if (storage == NULL) {

                // The per-thread storage hasn't been allocated yet for this specific 
                // thread.  Let's go allocate it and attach it to this thread.
                
                err = AllocatePortFromPool(&storage);
                if (err == noErr) {
                    err = (OSStatus) pthread_setspecific(sPerThreadStorageKey, (void *) storage);
                    if (err != noErr) {
                        ReturnPortToPool(storage);
                        storage = NULL;
                    }
                }
            }
            assert( (err == noErr) == (storage != NULL) );
            
            // If all went well, copy the port out to our client.
            
            if (err == noErr) {
                assert(storage->magic == kPerThreadStorageMagic);
                assert(storage->port  != MACH_PORT_NULL);
                *replyPortPtr = storage->port;
            }
        }
    }

    // no error + MACH_PORT_NULL is a valid response if we're on the main 
    // thread.
    //
    // assert( (err == noErr) == (*replyPortPtr != MACH_PORT_NULL) );
    assert( (*replyPortPtr == MACH_PORT_NULL) || (err == noErr) );
    
    return err;
}

static void PerThreadStorageDestructor(void *keyValue)
    // Called by pthreads when a thread dies and it has a non-null value for our 
    // per-thread storage key.  We use this callback to return the thread's 
    // Apple event reply port to the pool.
{
    PerThreadStorage *  storage;

    storage = (PerThreadStorage *) keyValue;
    assert(storage != NULL);                    // pthread won't call us if it's NULL
    assert(storage->magic == kPerThreadStorageMagic);
    assert(storage->port  != MACH_PORT_NULL);
    
    // Return the port associated with this thread to the pool.
    
    ReturnPortToPool(storage);

    // pthreads has already set this thread's per-thread storage for our key to 
    // NULL before calling us. So we don't need to do anything to remove it.

    assert( pthread_getspecific(sPerThreadStorageKey) == NULL );
}

OSStatus SendMessageThreadSafe(
    AppleEvent *            eventPtr,
    AppleEvent *            replyPtr,
	AESendMode              sendMode,
    long                    timeOutInTicks
)
    // See comment in header.
{
    OSStatus        err = noErr;
    mach_port_t     replyPort;
    assert(eventPtr != NULL);
    assert(replyPtr != NULL);
    
	if (sendMode && kAEWaitReply) {
		replyPort = MACH_PORT_NULL;
		
		// Set up the reply port if necessary.
		
		err = BindReplyMachPortToThread(&replyPort);
		if ( (err == noErr) && (replyPort != MACH_PORT_NULL) ) {
			err = AEPutAttributePtr(eventPtr, keyReplyPortAttr, typeMachPort, &replyPort, sizeof(replyPort));
		}
    }
	
    // Call through to AESendMessage.
    
    if (err == noErr) {
        err = AESendMessage(eventPtr, replyPtr, sendMode, timeOutInTicks);
    }
    
    return err;
}
