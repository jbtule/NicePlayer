/**
 * MainWindowProxy.h
 * NicePlayer
 */

#import "MainWindowProxy.h"


@implementation MainWindowProxy

- (void)forwardInvocation:(NSInvocation *)invocation
{
    id friend = [[NSApp delegate] documentForWindow:[NSApp mainWindow]];
    if ([friend respondsToSelector:[invocation selector]])
        [invocation invokeWithTarget:friend];
    else
        [self doesNotRecognizeSelector:[invocation selector]];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    
  return  [NSWindow instanceMethodSignatureForSelector:aSelector];
}
@end
