

#import "CSMCommandCreator.h"
#import "CSMWorkflowCommand.h"
#import "CSMExecutableCommand.h"
#import "CSMShellScriptCommand.h"
#import "CSMFolderCommand.h"
#import "CSMAppleScriptCommand.h"
#import "CSMPlainOpenCommand.h"
#import "NSString-UTIAdditions.h"

@implementation CSMCommandCreator

-(id)initWithScriptPath:(NSString*) aPath{
    NSString* tWorkflowExt = @"workflow";
    NSString* tUTTypeWorkflow = 
        [(NSString*)TTCTypeCreatePreferredIdentifierForTag(
                                              kUTTagClassFilenameExtension,
                                               (CFStringRef)tWorkflowExt,
                                              NULL) autorelease];
  
    NSString* tUTI = [aPath UTIForPath];
    if([tUTI conformsToUTI:@"com.apple.applescript.text"] 
             || [tUTI conformsToUTI:@"com.apple.applescript.script"]){
       return [[CSMAppleScriptCommand alloc] initWithScriptPath:aPath];
    }else if([tUTI conformsToUTI:@"public.shell-script"]){
        return  [[CSMShellScriptCommand alloc] initWithScriptPath:aPath];
    }else if([tUTI conformsToUTI:(id)TTCConstantIfAvailible((void**)&kUTTypeApplication,@"com.apple.application ")]){
        return [[CSMExecutableCommand alloc] initWithScriptPath:aPath];
    }else if([tUTI conformsToUTI:tUTTypeWorkflow]){
        return [[CSMWorkflowCommand alloc] initWithScriptPath:aPath];
    }else if([tUTI conformsToUTI:(id)TTCConstantIfAvailible((void**)&kUTTypeFolder,@"public.folder")]){
        return [[CSMFolderCommand alloc] initWithScriptPath:aPath];
    }else{
        NSLog(@"Unknown Script %@ | %@",aPath, [aPath UTIForPath]);
        return [[CSMPlainOpenCommand alloc] initWithScriptPath:aPath];
    }
}


@end

