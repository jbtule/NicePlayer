/**
 * ControlButton.h
 * NicePlayer
 */

#import <Cocoa/Cocoa.h>
#import "NPMovieView.h"

@interface ControlButton : NSButton {
	id actionView;
	BOOL start;
	BOOL activated;
	NSTrackingRectTag tRectTag;
}

-(void)setActionView:(id)aView;
-(BOOL)isInFinalState;
-(void)mousePressed:(id)sender;
-(void)makeTrackingRect;

@end
