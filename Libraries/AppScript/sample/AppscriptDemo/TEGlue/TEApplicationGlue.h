/*
 * TEApplicationGlue.h
 *
 * /applications/textedit.app
 * osaglue 0.2.0
 *
 */

#import <Foundation/Foundation.h>


#import "Appscript/Appscript.h"
#import "TEConstantGlue.h"
#import "TEReferenceGlue.h"


@interface TEApplication : TEReference
- (id)initWithTargetType:(ASTargetType)targetType_ data:(id)targetData_;
- (id)init;
- (id)initWithName:(NSString *)name;
- (id)initWithBundleID:(NSString *)bundleID;
- (id)initWithPath:(NSString *)path;
- (id)initWithURL:(NSURL *)url;
- (id)initWithPID:(pid_t)pid;
- (id)initWithDescriptor:(NSAppleEventDescriptor *)desc;
@end

