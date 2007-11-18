//
//  application.h
//  aem
//
//  Copyright (C) 2007 HAS
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>
#import "codecs.h"
#import "connect.h"
#import "SendThreadSafe.h"
#import "event.h"


/**********************************************************************/
// Application class

@interface AEMApplication : NSObject {
	AEMTargetType targetType;
	id targetData;
	NSAppleEventDescriptor *addressDesc;
	id defaultCodecs;
	AETransactionID transactionID;
	
	AEMCreateProcPtr createProc;
	AEMSendProcPtr sendProc;
	Class eventClass;
}

- (id)initWithTargetType:(AEMTargetType)targetType_ data:(id)targetData_;

// clients should call one of the following methods to initialize AEMApplication object

- (id)initWithName:(NSString *)name;

- (id)initWithBundleID:(NSString *)bundleID;

- (id)initWithPath:(NSString *)path; // TO DO: probably delete

- (id)initWithURL:(NSURL *)url;

- (id)initWithPID:(pid_t)pid;

- (id)initWithDescriptor:(NSAppleEventDescriptor *)desc;

// clients can call following methods to modify standard create/send behaviours

- (void)setCreateProc:(AEMCreateProcPtr)createProc_;

- (void)setSendProc:(AEMSendProcPtr)sendProc_;

- (void)setEventClass:(Class)eventClass_;

// create new AEMEvent object

- (id)eventWithEventClass:(AEEventClass)classCode
						  eventID:(AEEventID)code
						 returnID:(AEReturnID)returnID
						   codecs:(id)codecs;

- (id)eventWithEventClass:(AEEventClass)classCode
						  eventID:(AEEventID)code
						 returnID:(AEReturnID)returnID;

- (id)eventWithEventClass:(AEEventClass)classCode
						  eventID:(AEEventID)code
						   codecs:(id)codecs;

- (id)eventWithEventClass:(AEEventClass)classCode
						  eventID:(AEEventID)code;

// transaction support

- (void)beginTransaction;

- (void)beginTransactionWithSession:(id)session;

- (void)endTransaction;

- (void)abortTransaction;
@end
