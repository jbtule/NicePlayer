/*
 * TEApplicationGlue.m
 *
 * /applications/textedit.app
 * osaglue 0.2.0
 *
 */

#import "TEApplicationGlue.h"



@implementation TEApplication

// clients shouldn't need to call this next method themselves
- (id)initWithTargetType:(ASTargetType)targetType_ data:(id)targetData_ {
    ASAppData *appData;
    
    appData = [[ASAppData alloc] initWithApplicationClass: [AEMApplication class]
                                            constantClass: [TEConstant class]
                                           referenceClass: [TEReference class]
                                               targetType: targetType_
                                               targetData: targetData_];
    self = [super initWithAppData: appData aemReference: AEMApp];
    if (!self) return self;
    return self;
}

// initialisers

- (id)init {
    return [self initWithTargetType: kASTargetCurrent data: nil];
}

- (id)initWithName:(NSString *)name {
    return [self initWithTargetType: kASTargetName data: name];
}

// TO DO: initWithSignature

- (id)initWithBundleID:(NSString *)bundleID {
    return [self initWithTargetType: kASTargetBundleID data: bundleID];    
}

- (id)initWithPath:(NSString *)path {
    return [self initWithTargetType: kASTargetPath data: path];    
}

- (id)initWithURL:(NSURL *)url {
    return [self initWithTargetType: kASTargetURL data: url];
}

- (id)initWithPID:(pid_t)pid {
    return [self initWithTargetType: kASTargetPID data: [NSNumber numberWithUnsignedLong: pid]];
}

- (id)initWithDescriptor:(NSAppleEventDescriptor *)desc {
    return [self initWithTargetType: kASTargetDescriptor data: desc];
}

@end

