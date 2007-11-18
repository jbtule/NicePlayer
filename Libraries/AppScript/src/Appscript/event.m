//
//  event.m
//  aem
//
//  Copyright (C) 2007 HAS
//

#import "event.h"


/**********************************************************************/
// NSError userInfo constants

NSString *kAEMErrorDomain				= @"AEMErrorDomain";

NSString *kAEMErrorNumberKey			= @"ErrorNumber";
NSString *kAEMErrorStringKey			= @"ErrorString";
NSString *kAEMErrorBriefMessageKey		= @"ErrorBriefMessage";
NSString *kAEMErrorExpectedTypeKey		= @"ErrorExpectedType";
NSString *kAEMErrorOffendingObjectKey	= @"ErrorOffendingObject";


/**********************************************************************/


// note: [desc stringValue] doesn't work in 10.5 for typeType descs, so use the following workaround:
#define osTypeToString(osType) [[[NSAppleEventDescriptor descriptorWithTypeCode: osType] coerceToDescriptorType: typeUnicodeText] stringValue]


@implementation AEMEvent

/*
 * Note: new AEMEvent instances are constructed by AEMApplication objects; 
 * clients shouldn't instantiate this class directly.
 */
- (id)initWithEvent:(AppleEvent *)event_
			 codecs:(id)codecs_
		   sendProc:(AEMSendProcPtr)sendProc_ {
	self = [super init];
	if (!self) return self;
	event = event_; // note: AEMEvent instance takes ownership of the given AppleEvent descriptor
	[codecs_ retain];
	codecs = codecs_;
	sendProc = sendProc_;
	resultType = typeWildCard;
	isResultList = NO;
	shouldUnpackResult = YES;
	return self;
}

- (void)dealloc {
	AEDisposeDesc(event);
	free(event);
	[codecs release];
	[super dealloc];
}

- (NSString *)description {
	OSStatus err;
	Handle h;
	NSString *result;
	
	err = AEPrintDescToHandle(event, &h);
	if (err) return [super description];
	result = [NSString stringWithFormat: @"<AEMEvent %s>", *h];
	DisposeHandle(h);
	return result;
}

// Access underlying AEDesc

- (const AppleEvent *)aeDesc {
	return event;
}


- (NSAppleEventDescriptor *)appleEventDescriptor {
	AppleEvent eventCopy;
	
	AEDuplicateDesc(event, &eventCopy);
	return [[[NSAppleEventDescriptor alloc] initWithAEDescNoCopy: &eventCopy] autorelease];
}

// Pack event's attributes and parameters, if any.

// TO DO: these methods may need to check for nil values to protect against crashes (need to investigate further)

- (AEMEvent *)setAttributePtr:(void *)dataPtr 
				 size:(Size)dataSize
	   descriptorType:(DescType)typeCode
		   forKeyword:(AEKeyword)key {
	OSErr err = AEPutAttributePtr(event, key, typeCode, dataPtr, dataSize);
	return err ? nil : self;
}

- (AEMEvent *)setParameterPtr:(void *)dataPtr 
				 size:(Size)dataSize
	   descriptorType:(DescType)typeCode
		   forKeyword:(AEKeyword)key {
	OSErr err = AEPutParamPtr(event, key, typeCode, dataPtr, dataSize);
	return err ? nil : self;
}

- (AEMEvent *)setAttribute:(id)value forKeyword:(AEKeyword)key {
	OSErr err = AEPutAttributeDesc(event, key, [[codecs pack: value] aeDesc]);
	return err ? nil : self;
}

- (AEMEvent *)setParameter:(id)value forKeyword:(AEKeyword)key {
	OSErr err = AEPutParamDesc(event, key, [[codecs pack: value] aeDesc]);
	return err ? nil : self;
}

- (AEMEvent *)unpackResultAsType:(DescType)type {
	resultType = type;
	isResultList = NO;
	shouldUnpackResult = YES;
	return self;
}

- (AEMEvent *)unpackResultAsListOfType:(DescType)type {
	resultType = type;
	isResultList = YES;
	shouldUnpackResult = YES;
	return self;
}

- (AEMEvent *)dontUnpackResult {
	shouldUnpackResult = NO;
	return self;
}

/*
 * Send event.
 *
 * (-send, -sendWithMode:, -sendWithTimeout: are convenience shortcuts for -sendWithMode:timeout:)
 *
 * (Note: a single event can be sent multiple times if desired.)
 *
 * (Note: if an Apple Event Manager/application error occurs, these methods will return nil.
 * Clients should test for this, then use the -errorNumber and -errorString methods to
 * retrieve the error description.
 */

- (id)sendWithMode:(AESendMode)sendMode timeout:(long)timeoutInTicks error:(NSError **)error {
	OSErr err, errorNumber;
	NSString *errorString, *errorDescription;
	NSDictionary *errorInfo;
	AEDesc replyDesc = {typeNull, NULL};
	AEDesc classDesc, idDesc;
	OSType classCode, idCode;
	NSAppleEventDescriptor *replyData, *result;
	NSAppleEventDescriptor *errorMessage, *errorObject, *errorType;

	if (error)
		*error = nil;
	// send event
	errorNumber = sendProc(event, &replyDesc, sendMode, timeoutInTicks);
	if (errorNumber) {
		// ignore 'invalid connection' errors caused by application quitting normally after being sent a quit event
		if (errorNumber == connectionInvalid) {
			err = AEGetAttributeDesc(event, keyEventClassAttr, typeType, &classDesc);
			if (!err) return nil;
			err = AEGetDescData(&classDesc, &classCode, sizeof(classCode));
			AEDisposeDesc(&classDesc);
			if (!err) return nil;
			err = AEGetAttributeDesc(event, keyEventIDAttr, typeType, &idDesc);
			if (!err) return nil;
			err = AEGetDescData(&idDesc, &idCode, sizeof(idCode));
			AEDisposeDesc(&idDesc);
			if (!err) return nil;
			if (classCode == kCoreEventClass && idCode == kAEQuitApplication)
				return [NSNull null];
		}
		// for any other Apple Event Manager errors, generate an NSError if one is requested, then return nil
		if (error) {
			errorDescription = [NSString stringWithFormat: @"Apple Event Manager error %i", errorNumber];
			errorInfo = [NSDictionary dictionaryWithObjectsAndKeys: 
					errorDescription, NSLocalizedDescriptionKey,
					[NSNumber numberWithInt: errorNumber], kAEMErrorNumberKey,
					nil];
			*error = [NSError errorWithDomain: kAEMErrorDomain code: errorNumber userInfo: errorInfo];
		}
		return nil;
	}
	// extract reply data, if any
	if (replyDesc.descriptorType == typeNull) return [NSNull null]; // application didn't return anything
	// wrap AEDesc as NSAppleEventDescriptor for convenience // TO DO: might be easier to use C API and wrap AEDescs later
	replyData = [[NSAppleEventDescriptor alloc] initWithAEDescNoCopy: &replyDesc];
	/*
	 * Check for an application error
	 *
	 *	Note: Apple spec says that both keyErrorNumber and keyErrorString parameters should be checked to determine if an 
	 *	error occurred; however, AppleScript only checks keyErrorNmber so we copy its behaviour for compatibility.
	 *	
	 *	Note: some apps (e.g. Finder) may return noErr on success, so ignore that too.
	 */
	errorNumber = (OSErr)[[replyData paramDescriptorForKeyword: keyErrorNumber] int32Value];
	if (errorNumber) {
		// if an application error occurred, generate an NSError if one is requested, then return nil
		if (error) {
			errorString = [[replyData paramDescriptorForKeyword: keyErrorString] stringValue];
			if (errorString)
				errorDescription = [NSString stringWithFormat: @"Application error: %@ (%i)", errorString, errorNumber];
			else
				errorDescription = [NSString stringWithFormat: @"Application error %i", errorNumber];
			errorInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys: 
					errorDescription, NSLocalizedDescriptionKey,
					[NSNumber numberWithInt: errorNumber], kAEMErrorNumberKey,
					nil];
			if (errorString)
				[errorInfo setValue: errorString forKey: kAEMErrorStringKey];
			if (errorMessage = [replyData paramDescriptorForKeyword: kOSAErrorBriefMessage])
				[errorInfo setValue: [errorMessage stringValue] forKey: kAEMErrorBriefMessageKey];
			if (errorObject = [replyData paramDescriptorForKeyword: kOSAErrorOffendingObject])
				[errorInfo setValue: [codecs unpack: errorObject] forKey: kAEMErrorOffendingObjectKey];
			if (errorType = [replyData paramDescriptorForKeyword: kOSAErrorExpectedType])
				[errorInfo setValue: [codecs unpack: errorType] forKey: kAEMErrorExpectedTypeKey];
			*error = [NSError errorWithDomain: kAEMErrorDomain code: errorNumber userInfo: errorInfo];
		}
		[replyData release];
		return nil;
	}
	/*
	 * Check for an application result, returning NSNull instance if none was given
	 */
	result = [replyData paramDescriptorForKeyword: keyAEResult];
	[replyData release];
	if (!result) return [NSNull null];
	/*
	 * If client invoked -dontUnpackResult, return the descriptor as-is
	 */
	if (!shouldUnpackResult) return result;
	/*
	 * Unpack result, performing any coercions specified via -unpackResultAs[ListOf]Type: before unpacking the descriptor
	 */
	if (isResultList) {
		if ([result descriptorType] != typeAEList) 
			result = [result coerceToDescriptorType: typeAEList];
		if (resultType == typeWildCard)
			result = [codecs unpack: result];
		else {
			NSMutableArray *resultList;
			NSAppleEventDescriptor *item;
			int i, length;
			resultList = [NSMutableArray array];
			length = [result numberOfItems];
			for (i = 1; i <= length; i++) {
				item = [result descriptorAtIndex: i];
				if (resultType != typeWildCard && [item descriptorType] != resultType) {
					NSAppleEventDescriptor *originalItem = item;
					item = [item coerceToDescriptorType: resultType];
					if (!item) { // a coercion error occurred
						if (error) {
							errorDescription = [NSString stringWithFormat: 
									@"Couldn't coerce item %i of result list to type '%@': %@", i, osTypeToString(resultType), result];
							errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:
									[NSAppleEventDescriptor descriptorWithTypeCode: resultType], kAEMErrorExpectedTypeKey,
									originalItem, kAEMErrorOffendingObjectKey,
									errorDescription, NSLocalizedDescriptionKey, 
									[NSNumber numberWithInt: errorNumber], kAEMErrorNumberKey, 
									nil];
							*error = [NSError errorWithDomain: kAEMErrorDomain code: errAECoercionFail userInfo: errorInfo];
						}
						return nil;
					}
				}
				[resultList addObject: [codecs unpack: item]];
			}
			return resultList;
		}
	}
	if (resultType != typeWildCard && [result descriptorType] != resultType) {
		NSAppleEventDescriptor *originalResult = result;
		result = [result coerceToDescriptorType: resultType];
		if (!result) { // a coercion error occurred
			if (error) {
				errorDescription = [NSString stringWithFormat: @"Couldn't coerce result to type '%@': %@", osTypeToString(resultType), result];
				errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:
						[NSAppleEventDescriptor descriptorWithTypeCode: resultType], kAEMErrorExpectedTypeKey,
						originalResult, kAEMErrorOffendingObjectKey,
						errorDescription, NSLocalizedDescriptionKey, 
						[NSNumber numberWithInt: errorNumber], kAEMErrorNumberKey, 
						nil];
				*error = [NSError errorWithDomain: kAEMErrorDomain code: errAECoercionFail userInfo: errorInfo];
			}
			return nil;
		}
	}
	return [codecs unpack: result];
}

- (id)sendWithError:(NSError **)error {
	return [self sendWithMode: kAEWaitReply timeout: kAEDefaultTimeout error: error];
}

- (id)send {
	return [self sendWithMode: kAEWaitReply timeout: kAEDefaultTimeout error: nil];
}

@end
