/**
 * NPMovieView.h
 * NicePlayer
 */

#import <Cocoa/Cocoa.h>
#import "Pluggable Players/NPMovieProtocol.h"
#import "../NiceWindow/NiceWindow.h"

@interface NPMovieView : NSView {
	BOOL dragButton;
	id trueMovieView;
	id contextMenu;
}

+(id)blankImage;

-(BOOL)openURL:(NSURL *)url;
-(void)loadMovie;
-(void)closeReopen;

-(void)mouseDoubleClick:(NSEvent *)anEvent;

-(void)start;
-(void)stop;
-(void)ffStart;
-(void)ffDo;
-(void)ffEnd;
-(void)rrStart;
-(void)rrDo;
-(void)rrEnd;

-(void)setVolume:(float)aVolume;
-(float)volume;

-(void)finalProxyViewLoad;

-(void)showOverLayVolume;
-(void)smartHideMouseOverOverlays;
-(void)timedHideOverlayWithSelector:(NSString *)aStringSelector;
-(void)cancelPreviousPerformRequestsWithSelector:(NSString *)aStringSelector;
-(void)hideOverlayWithSelector:(NSString *)aStringSelector;

-(id)myMenu;
-(id)pluginMenu;
-(id)contextualMenu;
-(void)rebuildMenu;

#pragma mark -
#pragma mark Calculations

-(double)scrubLocation:(id)sender;
-(NSSize)naturalSize;
-(BOOL)hasEnded:(id)sender;
-(long)currentMovieTime;
-(long)totalTime;
-(void)drawMovieFrame;

@end
