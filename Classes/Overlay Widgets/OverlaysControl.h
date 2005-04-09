/**
 * OverlaysControl.h
 * NicePlayer
 */

#import <Cocoa/Cocoa.h>

@class NiceWindow;

@interface OverlaysControl : NSObject {
}

+(id)control;
-(void)mouseMovedInScreenPoint:(NSPoint)aScreenPoint;
-(BOOL)inResizeRegion:(NSPoint)aScreenPoint forWindow:(id)aWindow;
-(BOOL)showOverlayForWindow:(NiceWindow *)aWindow atPoint:(NSPoint)aScreenPoint;

@end
