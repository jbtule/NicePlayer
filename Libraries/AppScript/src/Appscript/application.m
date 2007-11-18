//
//  application.m
//  aem
//
//  Copyright (C) 2007 HAS
//

#import "application.h"


/**********************************************************************/

// TO DO: -reconnect

@implementation AEMApplication

// clients shouldn't call this initializer directly; use one of the methods below
- (id)initWithTargetType:(AEMTargetType)targetType_ data:(id)targetData_ {
	if (!targetData_) return nil;
	self = [super init];
	if (!self) return self;
	// hooks
	createProc = (AEMCreateProcPtr)AECreateAppleEvent;
	sendProc = (AEMSendProcPtr)SendMessageThreadSafe;
	eventClass = [AEMEvent class];
	// description
	targetType = targetType_;
	targetData = targetData_;
	// address desc
	switch (targetType) {
		case kAEMTargetFileURL:
			addressDesc = AEMAddressDescForLocalApplication(targetData);
			break;
		case kAEMTargetEppcURL:
			addressDesc = AEMAddressDescForRemoteProcess(targetData);
			break;
		case kAEMTargetCurrent:
			addressDesc = AEMAddressDescForCurrentProcess();
			break;
		default:
			addressDesc = targetData;
	}
	if (!addressDesc) return nil;
	[targetData_ retain];
	[addressDesc retain];
	// misc
	defaultCodecs = [[AEMCodecs alloc] init];
	transactionID = kAnyTransactionID;
	return self;
}

// initializers

- (id)init {
	return [self initWithTargetType: kAEMTargetCurrent data: [NSNull null]];
}

- (id)initWithName:(NSString *)name {
	return [self initWithTargetType: kAEMTargetFileURL data: AEMFindAppWithName(name)];
}

- (id)initWithBundleID:(NSString *)bundleID {
	return [self initWithTargetType: kAEMTargetFileURL data: AEMFindAppWithBundleID(bundleID)];
}

- (id)initWithPath:(NSString *)path {
	return [self initWithTargetType: kAEMTargetFileURL data: [NSURL fileURLWithPath: path]];	
}

- (id)initWithURL:(NSURL *)url {
	if ([url isFileURL])
		return [self initWithTargetType: kAEMTargetFileURL data: url];
	else
		return [self initWithTargetType: kAEMTargetEppcURL data: url];
}

- (id)initWithPID:(pid_t)pid {
	return [self initWithTargetType: kAEMTargetPID data: AEMAddressDescForLocalProcess(pid)];
}

- (id)initWithDescriptor:(NSAppleEventDescriptor *)desc {
	return [self initWithTargetType: kAEMTargetDescriptor data: desc];
}

// dealloc

- (void)dealloc {
	[targetData release];
	[addressDesc release];
	[defaultCodecs release];
	[super dealloc];
}

// display

- (NSString *)description {
	pid_t pid;
	switch (targetType) {
		case kAEMTargetFileURL:
		case kAEMTargetEppcURL:
			return [NSString stringWithFormat: @"<AEMApplication url=%@>", targetData];
		case kAEMTargetPID:
			[[addressDesc data] getBytes: &pid length: sizeof(pid_t)];
			return [NSString stringWithFormat: @"<AEMApplication pid=%i>", pid];
		case kAEMTargetCurrent:
			return @"<AEMApplication current>";
		default:
			return [NSString stringWithFormat: @"<AEMApplication desc=%@>", addressDesc];
	}
}

// clients can call following methods to modify standard create/send behaviours

- (void)setCreateProc:(AEMCreateProcPtr)createProc_ {
	createProc = createProc_;
}

- (void)setSendProc:(AEMSendProcPtr)sendProc_ {
	sendProc = sendProc_;
}

- (void)setEventClass:(Class)eventClass_ {
	eventClass = eventClass_;
}

// create new AEMEvent object

- (id)eventWithEventClass:(AEEventClass)classCode
						  eventID:(AEEventID)code
						 returnID:(AEReturnID)returnID
						   codecs:(id)codecs {
	OSErr err;
	AppleEvent *appleEvent;
	
	appleEvent = malloc(sizeof(AEDesc));
	if (!appleEvent) return nil;
	err = createProc(classCode, code, [addressDesc aeDesc], returnID, transactionID, appleEvent);
	if (err) return nil;
	return [[[eventClass alloc] initWithEvent: appleEvent
									 codecs: codecs 
								   sendProc: sendProc] autorelease];
}

- (id)eventWithEventClass:(AEEventClass)classCode
						  eventID:(AEEventID)code
						 returnID:(AEReturnID)returnID {
	return [self eventWithEventClass: classCode
							 eventID: code
							returnID: returnID
							  codecs: defaultCodecs];
}

- (id)eventWithEventClass:(AEEventClass)classCode
						  eventID:(AEEventID)code
						   codecs:(id)codecs {
	return [self eventWithEventClass: classCode
							 eventID: code
							returnID: kAutoGenerateReturnID
							  codecs: codecs];
}

- (id)eventWithEventClass:(AEEventClass)classCode
						  eventID:(AEEventID)code {
	return [self eventWithEventClass: classCode
							 eventID: code
							returnID: kAutoGenerateReturnID
							  codecs: defaultCodecs];
}


//

- (BOOL)reconnect {
	return NO; // TO DO
}

// transaction support // TO DO

- (void)beginTransaction {
}

- (void)beginTransactionWithSession:(id)session {
}

- (void)endTransaction {
}

- (void)abortTransaction {
}

@end
