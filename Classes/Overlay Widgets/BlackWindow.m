/**
 * BlackWindow.m
 * NicePlayer
 *
 * The black window that forms the background behind a movie when it is displayed full screen.
 */

#import "BlackWindow.h"


@implementation BlackWindow

- (id)initWithContentRect:(NSRect)contentRect styleMask:(unsigned int)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    
    NSWindow *result = [super initWithContentRect:contentRect
                                        styleMask:NSBorderlessWindowMask
                                          backing:NSBackingStoreBuffered
                                            defer:YES];
    [result setBackgroundColor: [NSColor blackColor]];
    presentingWindow =nil;
    [result setLevel:NSFloatingWindowLevel+1];
    
    return result;
    
}

- (BOOL)canBecomeMainWindow
{
    return NO;
}

- (BOOL)canBecomeKeyWindow
{
    return NO;
}

-(void)setPresentingWindow:(id)window
{
    presentingWindow = window;
}

- (BOOL)isExcludedFromWindowsMenu
{
    return YES;
}

-(void)mouseDown:(NSEvent *)anEvent
{
    if(presentingWindow != nil)
		[presentingWindow makeKeyAndOrderFront:anEvent];

	if(([anEvent type] == NSLeftMouseDown) &&  ([anEvent clickCount] > 0) && (([anEvent clickCount] % 2) == 0)){
		[presentingWindow mouseDoubleClick:anEvent];
	}
}

-(void)mouseUp:(NSEvent *)anEvent
{
	if(([anEvent type] == NSLeftMouseUp) && (([anEvent modifierFlags] & NSControlKeyMask) == NSControlKeyMask)){ /* This is a control click. */
		[presentingWindow rightMouseUp:anEvent];
		return;
	}
}

-(void)rightMouseUp:(NSEvent *)anEvent
{
	[presentingWindow rightMouseUp:anEvent];
}

-(void)orderOut:(id)sender
{
    presentingWindow = nil;
    [super orderOut:sender];
}

@end
