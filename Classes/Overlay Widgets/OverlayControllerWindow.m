/**
 * OverlayControllerWindow.m
 * NicePlayer
 */

#import "OverlayControllerWindow.h"

@implementation OverlayControllerWindow

-(void)awakeFromNib
{
    [super awakeFromNib];
    [ffButton setContinuous:YES];
    [rrButton setContinuous:YES];
    
    [ffButton setPeriodicDelay:.5 interval:.2];
    [rrButton setPeriodicDelay:.5 interval:.2];
}

-(void)createResizeTriangle
{
    [self addChildWindow:overlayResize ordered:NSWindowAbove];    
    [self setHasShadow:NO];
    [overlayResize setFrame:[[self parentWindow] frame] display:NO];
    [overlayResize orderFront:self];
}

-(void)setAlphaValue:(float)windowAlpha
{
    [overlayResize setAlphaValue:windowAlpha];
    [super setAlphaValue:windowAlpha];
}

-(void)setFrame:(NSRect)frameRect display:(BOOL)flag
{
    [super setFrame:frameRect display:flag];

    NSRect movieRect = [[[self parentWindow] contentView] frame];
    movieRect.origin = [[self parentWindow] convertBaseToScreen:movieRect.origin];
    [overlayResize setFrame:movieRect display:flag];
    
}

-(void)setLevel:(int)newLevel
{
    [overlayResize setLevel:newLevel];
    [super setLevel:newLevel];
}

@end
