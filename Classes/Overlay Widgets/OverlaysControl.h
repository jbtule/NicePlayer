/**
 * OverlaysControl.h
 * NicePlayer
 */

#import <Cocoa/Cocoa.h>
#import "../NiceWindow/NiceWindow.h"

@interface OverlaysControl : NSObject {
	id windows;
}

+(id)control;
-(void)mouseMovedInScreenPoint:(NSPoint)aScreenPoint;

@end
