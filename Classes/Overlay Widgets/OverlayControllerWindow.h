/**
 * OverlayControllerWindow.h
 * NicePlayer
 */

#import <Cocoa/Cocoa.h>
#import "OverlayWindow.h"

@interface OverlayControllerWindow : OverlayWindow
{
    IBOutlet NSButton* ffButton;
    IBOutlet NSButton* rrButton;
	
    IBOutlet NSWindow* overlayResize;
	
	BOOL holdsResizeTriangle;
}

-(void)createResizeTriangle;

@end
