/**
 * RoundRect.h
 * NicePlayer
 */

#import <Cocoa/Cocoa.h>

@interface NSBezierPath(MyCategory)
- (void) appendBezierPathWithRoundedRectangle:(NSRect)aRect  
                                   withRadius:(float) radius;
@end

