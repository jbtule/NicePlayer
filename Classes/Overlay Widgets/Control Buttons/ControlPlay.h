/**
 * ControlPlay.h
 * NicePlayer
 */

#import <Cocoa/Cocoa.h>
#import "ControlButton.h"

@interface ControlPlay : ControlButton {
	BOOL iAmPlaying;
}

-(void)togglePlaying;
-(void)changeToProperButton:(BOOL)isPlaying;
-(void)changeToPauseButton;
-(void)changeToPlayButton;

@end
