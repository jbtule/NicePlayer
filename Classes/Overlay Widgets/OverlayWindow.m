/**
 * OverlayWindow.m
 * NicePlayer
 *
 * The superclass that sets up all of the states necessary for the overlay
 * to operate properly.
 */

#import "OverlayWindow.h"

@implementation OverlayWindow
-(id)initWithContentRect:(NSRect)contentRect styleMask:(unsigned int)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    
    NSWindow *result = [super initWithContentRect:contentRect
                                        styleMask:NSBorderlessWindowMask
                                          backing:NSBackingStoreBuffered
                                            defer:YES];
    [result setBackgroundColor: [NSColor clearColor]];
    [self setOpaque:NO];
    return result;
}

-(BOOL)canBecomeMainWindow
{
    return NO;
}

-(BOOL)canBecomeKeyWindow
{
    return NO;
}

-(void)mouseMoved:(NSEvent *)anEvent
{
    NSEvent *newEvent = [NSEvent mouseEventWithType:NSMouseMoved
					   location:[((NiceWindow *)[self parentWindow]) convertScreenToBase:[NSEvent mouseLocation]]
				      modifierFlags:0
					  timestamp:0
				       windowNumber:0
					    context:nil
					eventNumber:0
					 clickCount:0
					   pressure:1.0];
    [((NiceWindow *)[self parentWindow]) mouseMoved:newEvent];
}


@end
