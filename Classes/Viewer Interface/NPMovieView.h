/**
 * NPMovieView.h
 * NicePlayer
 */

#import <Cocoa/Cocoa.h>
#import "Pluggable Players/NPMovieProtocol.h"
#import "NiceWindow.h"
#import "ControlButton.h"
#import "NPPluginReader.h"

@class ControlPlay;

@interface NPMovieView : NSView {
	BOOL dragButton;
	id trueMovieView;
	id contextMenu;
}

+(id)blankImage;

-(BOOL)openURL:(NSURL *)url;
-(void)loadMovie;
-(void)closeReopen;
-(void)close;

-(void)mouseDoubleClick:(NSEvent *)anEvent;

-(void)start;
-(void)stop;
-(void)ffStart;
-(void)ffDo;
-(void)ffEnd;
-(void)rrStart;
-(void)rrDo;
-(void)rrEnd;

-(void)toggleMute;
-(void)incrementVolume;
-(void)decrementVolume;
-(void)setVolume:(float)aVolume;
-(float)volume;

-(BOOL)isPlaying;

-(void)finalProxyViewLoad;

-(void)showOverLayVolume;
-(void)smartHideMouseOverOverlays;
-(void)timedHideOverlayWithSelector:(NSString *)aStringSelector;
-(void)cancelPreviousPerformRequestsWithSelector:(NSString *)aStringSelector;
-(void)hideOverlayWithSelector:(NSString *)aStringSelector;

-(id)myMenu;
-(id)menuTitle;
-(id)pluginMenu;
-(id)contextualMenu;
-(void)rebuildMenu;

#pragma mark -
#pragma mark Calculations

-(double)scrubLocation:(id)sender;
-(NSSize)naturalSize;
-(BOOL)hasEnded:(id)sender;
-(BOOL)muted;
-(void)setMuted:(BOOL)aBool;
-(double)currentMovieTime;
-(double)totalTime;
-(void)drawMovieFrame;
-(void)setLoopMode:(NSQTMovieLoopMode)flag;

@end
