/**
 * RoundRect.m
 * NicePlayer
 */

//Sample code found everywhere

#import "RoundRect.h"

@implementation NSBezierPath(RoundRect)
- (void) appendBezierPathWithRoundedRectangle:(NSRect)aRect  
                                   withRadius:(float) radius
{
    NSPoint topMid = NSMakePoint(NSMidX(aRect), NSMaxY(aRect));
    NSPoint topLeft = NSMakePoint(NSMinX(aRect), NSMaxY(aRect));
    NSPoint topRight = NSMakePoint(NSMaxX(aRect), NSMaxY(aRect));
    NSPoint bottomRight = NSMakePoint(NSMaxX(aRect), NSMinY(aRect));
    
    [self moveToPoint:topMid];
    [self appendBezierPathWithArcFromPoint:topLeft toPoint:aRect.origin  
                                    radius:radius];
    [self appendBezierPathWithArcFromPoint:aRect.origin  
                                   toPoint:bottomRight radius:radius];
    [self appendBezierPathWithArcFromPoint:bottomRight toPoint:topRight  
                                    radius:radius];
    [self appendBezierPathWithArcFromPoint:topRight toPoint:topLeft  
                                    radius:radius];
    [self closePath];
}
@end
