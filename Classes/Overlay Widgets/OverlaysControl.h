/**
 * OverlaysControl.h
 * NicePlayer
 */

#import <Cocoa/Cocoa.h>
#import "../NiceWindow/NiceWindow.h"

@interface OverlaysControl : NSObject {
}

+(id)control;
-(void)mouseMovedInScreenPoint:(NSPoint)aScreenPoint;

@end
