/**
 * OverlayWindow.h
 * NicePlayer
 */

#import <Cocoa/Cocoa.h>
#import "../NiceWindow/NiceWindow.h"

@interface OverlayWindow : NSWindow
{
    NSTrackingRectTag trackingRect;
    BOOL mouseEntered;
}

@end
