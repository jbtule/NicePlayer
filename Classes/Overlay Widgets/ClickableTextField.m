/**
 * ClickableTextField.m
 * NicePlayer
 */

#import "ClickableTextField.h"

@implementation ClickableTextField

- (void)mouseDown:(NSEvent *)theEvent
{
    if([theEvent clickCount]>1)
        [theNiceWindow performMiniaturize:theEvent];
   
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    [theNiceWindow mouseDragged:theEvent];
}

@end
