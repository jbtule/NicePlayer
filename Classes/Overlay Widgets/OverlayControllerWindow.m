/**
 * OverlayControllerWindow.m
 * NicePlayer
 */

#import "OverlayControllerWindow.h"

@implementation OverlayControllerWindow
-(void)awakeFromNib{
 
    [ffButton setContinuous:YES];
    [rrButton setContinuous:YES];
        
    [ffButton setPeriodicDelay:.5 interval:.2];
	[rrButton setPeriodicDelay:.5 interval:.2];

}
@end
