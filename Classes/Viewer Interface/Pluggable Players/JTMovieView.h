/**
 * JTMovieView.h
 * NicePlayer
 */

#import <Cocoa/Cocoa.h>
#import <QuickTime/QuickTime.h>
#import <Carbon/Carbon.h>
#import "NPMovieProtocol.h"
#import "../../Preferences/Preferences.h"
#import "../../NiceWindow/NiceWindow.h"
#import "NPPluginView.h"

@interface JTMovieView : NSMovieView <NPMoviePlayer>
{
	enum play_states oldPlayState;
	NSURL *myURL;
	NSMovie *film;
	BOOL muted;
	NSDictionary* movieCache;
}

+(id)blankImage;

-(double)totalTimePrecise;
-(long)currentMovieTimePrecise;
-(void)setCurrentMovieTimePrecise:(long)newMovieTime;
-(long)currentMovieTimeScale;
-(void)incrementMovieTime:(long)timeDifference inDirection:(enum direction)aDirection;
-(void)stepFrameInDirection:(int)aDirection;

@end
