/**
 * OverlayControllerWindow.m
 * NicePlayer
 */

#import "OverlayControllerWindow.h"

@implementation OverlayControllerWindow

-(void)awakeFromNib
{
    [ffButton setContinuous:YES];
    [rrButton setContinuous:YES];
	
    [ffButton setPeriodicDelay:.5 interval:.2];
	[rrButton setPeriodicDelay:.5 interval:.2];
	
	holdsResizeTriangle = NO;
}

-(void)createResizeTriangle
{
	[overlayResize setFrame:[[self parentWindow] frame] display:NO];
    [self addChildWindow:overlayResize ordered:NSWindowAbove];    
    [overlayResize orderFront:self];
	[self setHasShadow:NO];
	[overlayResize setLevel:[self level]];
	holdsResizeTriangle = YES;
}




-(void)setAlphaValue:(float)windowAlpha
{
	[super setAlphaValue:windowAlpha];
	if(holdsResizeTriangle)
		[overlayResize setAlphaValue:windowAlpha];
}

-(void)setResizeOrigin:(NSPoint)aPoint
{
	[overlayResize setFrameOrigin:aPoint];
}

-(void)setFrame:(NSRect)frameRect display:(BOOL)flag
{
	[super setFrame:frameRect display:flag];
	if(holdsResizeTriangle)
		[overlayResize setFrame:[[self parentWindow] frame] display:flag];
}

- (void)setLevel:(int)newLevel
{
	[super setLevel:newLevel];
	if(holdsResizeTriangle)
		[overlayResize setLevel:newLevel];
}

@end
