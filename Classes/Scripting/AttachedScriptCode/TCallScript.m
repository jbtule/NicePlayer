/*

File: TCallScript.m

Abstract: A class for calling through from 
Objective-C to AppleScript

Version: 1.0

(c) Copyright 2006 Apple Computer, Inc. All rights reserved.

IMPORTANT:  This Apple software is supplied to 
you by Apple Computer, Inc. ("Apple") in 
consideration of your agreement to the following 
terms, and your use, installation, modification 
or redistribution of this Apple software 
constitutes acceptance of these terms.  If you do 
not agree with these terms, please do not use, 
install, modify or redistribute this Apple 
software.

In consideration of your agreement to abide by 
the following terms, and subject to these terms, 
Apple grants you a personal, non-exclusive 
license, under Apple's copyrights in this 
original Apple software (the "Apple Software"), 
to use, reproduce, modify and redistribute the 
Apple Software, with or without modifications, in 
source and/or binary forms; provided that if you 
redistribute the Apple Software in its entirety 
and without modifications, you must retain this 
notice and the following text and disclaimers in 
all such redistributions of the Apple Software. 
Neither the name, trademarks, service marks or 
logos of Apple Computer, Inc. may be used to 
endorse or promote products derived from the 
Apple Software without specific prior written 
permission from Apple.  Except as expressly 
stated in this notice, no other rights or 
licenses, express or implied, are granted by 
Apple herein, including but not limited to any 
patent rights that may be infringed by your 
derivative works or by other works in which the 
Apple Software may be incorporated.

The Apple Software is provided by Apple on an "AS 
IS" basis.  APPLE MAKES NO WARRANTIES, EXPRESS OR 
IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED 
WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY 
AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING 
THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE 
OR IN COMBINATION WITH YOUR PRODUCTS.

IN NO EVENT SHALL APPLE BE LIABLE FOR ANY 
SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL 
DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS 
OF USE, DATA, OR PROFITS; OR BUSINESS 
INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, 
REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF 
THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER 
UNDER THEORY OF CONTRACT, TORT (INCLUDING 
NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN 
IF APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF 
SUCH DAMAGE.

*/


#import "TCallScript.h"
#import "AEDescUtils.h"
#import <Carbon/Carbon.h>
#import <stdarg.h>


@implementation TCallScript



	/* initialized a TCallScript loading a pre-compiled script
	containing the handlers we wish to call */
- (TCallScript*) initWithURLToCompiledScript:(NSURL*)scriptURL {
	if ((self = [super init]) != NULL) {
		NSDictionary* errorInfo;
			/* load the compiled version of our AppleScript from the file AttachedScripts.scpt
			in the resources folder.  This script contains all of the handlers we will
			be using in this application.  */
		[self setTheScript:[[NSAppleScript alloc] initWithContentsOfURL:scriptURL error:&errorInfo]];
	}
	return self;
}

- (void) dealloc {
	[self setTheScript: nil];
	[super dealloc];
}


	/* the following two routines are accessor methods for getting/setting
	the theScript field in our object.  Note that unlike the canonical
	way of implementing these routines we do not perform a copy when
	setting the theScript filed.  This is because the implementation of
	NSAppleScript does not allow you to do that. */
- (NSAppleScript *)theScript {
    return [[theScript retain] autorelease];
}

- (void)setTheScript:(NSAppleScript *)value {
    if (theScript != value) {
        [theScript release];
        theScript = value; /* [newTheScript copy] not with aedescs. */
    }
}



	/* callScript is the main workhorse routine we use for calling handlers
	in our AppleScript.  Essentially, this routine creates a 'call subroutine' Apple event
	and then it dispatches the event to the compiled AppleScript we loaded in our awakeFromNib
	routine. */
- (NSAppleEventDescriptor*) callScript:(NSString *)handlerName 
			withArrayOfParameters:(NSAppleEventDescriptor*) parameterList {
	ProcessSerialNumber PSN = {0, kCurrentProcess};
	NSAppleEventDescriptor *theAddress;
	
		/* create the target address descriptor specifying our own process as the target */
	if ( theAddress = [NSAppleEventDescriptor descriptorWithDescriptorType:typeProcessSerialNumber 
			bytes:&PSN length:sizeof(PSN)] ) {
		NSAppleEventDescriptor *theEvent;
			
			/* create a new Apple event of type typeAppleScript/kASSubroutineEvent */
		if ( theEvent = [NSAppleEventDescriptor appleEventWithEventClass:typeAppleScript 
						eventID:kASSubroutineEvent targetDescriptor:theAddress 
						returnID:kAutoGenerateReturnID transactionID:kAnyTransactionID] ) {
			NSAppleEventDescriptor* theHandlerName;
					
					/* create a descriptor containing the handler's name.  AppleScript handler
					names must be converted to lowercase before including them in a call
					subroutine Apple event.  */
			if ( theHandlerName = [NSAppleEventDescriptor descriptorWithString:
													[handlerName lowercaseString]] ) {
				NSDictionary *errorInfo;
				NSAppleEventDescriptor *theResult;
				
					/* add the handler's name to the Apple event using the
					keyASSubroutineName keyword */
				[theEvent setDescriptor:theHandlerName forKeyword:keyASSubroutineName];
				
					/* add the parameter list.  If none was specified, then create an empty one */
				if ( parameterList != nil ) {
					[theEvent setDescriptor:parameterList forKeyword:keyDirectObject];
				} else {
					NSAppleEventDescriptor* paramList = [NSAppleEventDescriptor listDescriptor];
					[theEvent setDescriptor:paramList forKeyword:keyDirectObject];
				}
				
					/* send the subroutine event to the script  */
				theResult = [[self theScript] executeAppleEvent:theEvent error:&errorInfo];
				
					/* if an error happened in the AppleScript, display the error information.  */
				if ( nil == theResult ) {
					NSString* paramStr;
					
						/* collect the parameters into a string of comma separated values
						so the user can see what they are */
					if ( parameterList != nil ) {
						NSArray* theParamStrings = [parameterList listOfStringsToArray];
						paramStr = [theParamStrings componentsJoinedByString:@", "];
					} else {
						paramStr = @"";
					}
					
						/* create the error message string */
					NSString *err = [NSString stringWithFormat:
							@"Error %@ occured the %@(%@) call: %@",
							[errorInfo objectForKey:NSAppleScriptErrorNumber],
							handlerName, paramStr,
							[errorInfo objectForKey:NSAppleScriptErrorBriefMessage]];
						
						/* display an alert panel showing the error */
					NSRunAlertPanel(@"AttachAScript Error", err, @"ok", nil, nil);
				}
				
					/* return whatever result the script returned */
				return theResult;
			}
		}
	}
	return nil;
}


	/* callHandler is a convenience routine that calls through to
	callScript:withArrayOfParameters:.  This method received parameters
	as a variable argument list of Objective-C objects and it automatically
	builds the AEDescList parameter for callScript:withArrayOfParameters: based
	on the types of objects provided as parameters.  Parameters may be NSNumbers,
	NSStrings, or NSAppleEventDescriptors.  */
- (NSAppleEventDescriptor*) callHandler:(NSString *)handlerName withParameters: (id) firstParameter, ... {
	va_list args;
	int index = 1;
	id nthID;
	NSAppleEventDescriptor* paramList = [NSAppleEventDescriptor listDescriptor];
	
	va_start(args, firstParameter);
	
	for (nthID=firstParameter; nthID != nil; nthID = va_arg(args, id) ) {
	
		if ( [nthID isKindOfClass: [NSNumber class]] ) {
		
			[paramList insertDescriptor:
					[NSAppleEventDescriptor descriptorWithInt32:[nthID longValue]] atIndex:(index++)];
					
		} else if ( [nthID isKindOfClass: [NSString class]] ) {
		
			[paramList insertDescriptor:
					[NSAppleEventDescriptor descriptorWithString:nthID] atIndex:(index++)];
					
		} else if ( [nthID isKindOfClass: [NSAppleEventDescriptor class]] ) {
		
			[paramList insertDescriptor: nthID atIndex:(index++)];
			
		} else {
		
			NSLog(@"unrecognized parameter type for parameter %d in callHandler:withParameters:", index);
			return nil; /* bad parameter */
			
		}
	}
	
	va_end(args);
	
	return [self callScript: handlerName withArrayOfParameters: paramList];
}


@end


