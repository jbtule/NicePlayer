//
//  reference.m
//  appscript
//
//  Copyright (C) 2007 HAS
//

#import "reference.h"


/**********************************************************************/


@implementation ASAppData

- (id)initWithApplicationClass:(Class)appClass
				 constantClass:(Class)constClass
				referenceClass:(Class)refClass
					targetType:(ASTargetType)type
					targetData:(id)data {
	self = [super init];
	if (!self) return self;
	aemApplicationClass = appClass;
	constantClass = constClass;
	referenceClass = refClass;
	targetType = type;
	targetData = [data retain];
	return self;
}

- (void)dealloc {
	[targetData release];
	[target release];
	[super dealloc];
}

- (BOOL)connect {
	switch (targetType) {
		case kASTargetCurrent:
			target = [[aemApplicationClass alloc] init];
			break;
		case kASTargetName:
			target = [[aemApplicationClass alloc] initWithName: targetData];
			break;
		case kASTargetBundleID:
			target = [[aemApplicationClass alloc] initWithBundleID: targetData];
			break;
		case kASTargetPath:
			target = [[aemApplicationClass alloc] initWithPath: targetData];
			break;
		case kASTargetURL:
			target = [[aemApplicationClass alloc] initWithURL: targetData];
			break;
		case kASTargetPID:
			target = [[aemApplicationClass alloc] initWithPID: [targetData unsignedLongValue]];
			break;
		case kASTargetDescriptor:
			target = [[aemApplicationClass alloc] initWithDescriptor: targetData];
	}
	return target != nil;
}

- (id)target { // returns AEMApplication instance or equivalent
	if (!target)
		if (![self connect]) return nil;
	return target;
}

// override pack, various unpack methods

- (NSAppleEventDescriptor *)pack:(id)object {
	if ([object isKindOfClass: [ASReference class]])
		return [object AS_packSelf: self];
	else if ([object isKindOfClass: [ASConstant class]])
		return [object AS_packSelf: self];
	else
		return [super pack: object];
}

- (id)unpackAERecordKey:(AEKeyword)key {
	return [constantClass constantWithCode: key];
}

- (id)unpackType:(NSAppleEventDescriptor *)desc {
	id result;
	
	result = [constantClass constantWithCode: [desc typeCodeValue]];
	if (!result)
		result = [super unpackType: desc];
	return result;
}

- (id)unpackEnum:(NSAppleEventDescriptor *)desc {
	id result;
	
	result = [constantClass constantWithCode: [desc enumCodeValue]];
	if (!result)
		result = [super unpackType: desc];
	return result;
}

- (id)unpackProperty:(NSAppleEventDescriptor *)desc {
	id result;
	
	result = [constantClass constantWithCode: [desc typeCodeValue]];
	if (!result)
		result = [super unpackType: desc];
	return result;
}

- (id)unpackKeyword:(NSAppleEventDescriptor *)desc {
	id result;
	
	result = [constantClass constantWithCode: [desc typeCodeValue]];
	if (!result)
		result = [super unpackType: desc];
	return result;
}

- (id)unpackObjectSpecifier:(NSAppleEventDescriptor *)desc {
	return [referenceClass referenceWithAppData: self
								aemReference: [super unpackObjectSpecifier: desc]];
}

- (id)unpackInsertionLoc:(NSAppleEventDescriptor *)desc {
	return [referenceClass referenceWithAppData: self
								aemReference: [super unpackInsertionLoc: desc]];
}

@end


/**********************************************************************/


@implementation ASCommand

// note: current design doesn't support returnID; not sure how best to implement this

+ (id)commandWithAppData:(id)appData
			  eventClass:(AEEventClass)classCode
				 eventID:(AEEventID)code
		 directParameter:(id)directParameter
		 parentReference:(id)parentReference {
	return [[[[self class] alloc] initWithAppData: appData
									   eventClass: classCode
										  eventID: code
								  directParameter: directParameter
								  parentReference: parentReference] autorelease];
}

- (id)initWithAppData:(id)appData
		   eventClass:(AEEventClass)classCode
			  eventID:(AEEventID)code
	  directParameter:(id)directParameter
	  parentReference:(id)parentReference {

	self = [super init];
	if (!self) return self;
	sendMode = kAEWaitReply | kAECanSwitchLayer;
	timeout = kAEDefaultTimeout;
	AS_event = [[appData target] eventWithEventClass: classCode
											 eventID: code
											  codecs: appData];
	[AS_event retain];
	if (!AS_event) return nil; // TO DO: better error reporting?
	if (directParameter)
		if (![AS_event setParameter: directParameter forKeyword: keyDirectObject]) return nil;
	if (parentReference)
		if (directParameter) {
			if (![AS_event setAttribute: parentReference forKeyword: keySubjectAttr]) return nil;
		} else {
			if (![AS_event setParameter: parentReference forKeyword: keyDirectObject]) return nil;
		}
	return self;
}

- (void)dealloc {
	[AS_event release];
	[super dealloc];
}

- (AEMEvent *)AS_aemEvent {
	return AS_event;
}

- (id)sendMode:(AESendMode)flags {
	sendMode = flags;
	return self;
}

- (id)timeout:(long)timeout_ {
	timeout = timeout_ * 60;
	return self;
}

- (id)requestedType:(ASConstant *)type {
	if (![AS_event setParameter: type forKeyword: keyAERequestedType]) return nil;
	return self;
}

- (id)returnType:(DescType)type {
	[AS_event unpackResultAsType: type];
	return self;
}

- (id)returnListOfType:(DescType)type {
	[AS_event unpackResultAsListOfType: type];
	return self;
}

- (id)returnDescriptor {
	[AS_event dontUnpackResult];
	return self;
}

- (id)sendWithError:(NSError **)error {
	return [AS_event sendWithMode: sendMode timeout: timeout error: error];
}

- (id)send {
	return [self sendWithError: nil];
}

// TO DO: attribute methods

@end


/**********************************************************************/


@implementation ASReference

+ (id)referenceWithAppData:(id)appData aemReference:(id)aemReference {
	return [[[self alloc] initWithAppData: appData aemReference: aemReference] autorelease];
}

- (id)initWithAppData:(id)appData aemReference:(id)aemReference {
	self = [super init];
	if (!self) return self;
	AS_appData = [appData retain];
	AS_aemReference = [aemReference retain];
	return self;
}

- (void)dealloc {
	[AS_appData release];
	[AS_aemReference release];
	[super dealloc];
}


- (NSAppleEventDescriptor *)AS_packSelf:(id)codecs {
	return [AS_aemReference packSelf: codecs];
}


// TO DO: hash, isEqual

- (id)AS_appData {
	return AS_appData;
}

// TO DO: AS_newReference, get+set shortcuts

- (id)AS_aemReference {
	return AS_aemReference;
}

@end

