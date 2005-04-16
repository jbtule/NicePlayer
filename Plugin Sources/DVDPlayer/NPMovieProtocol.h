//
/**
 * NPMovieProtocol.m
 * NicePlayer
 *
 * Defines the basic protocol that views must adhere to if they are to be considered supported
 * plugins. You should adopt this protocol, as well as inheriting from NPPluginView (or,
 * implement the necessary methods contained in NPPluginView).
 */

#import <Cocoa/Cocoa.h>
#import <AppKit/NSDragging.h>

enum direction { DIRECTION_BACKWARD = -1, DIRECTION_FORWARD = 1};

@protocol NPMoviePlayer

/**
 * Use something like this:
 * [NSDictionary dictionaryWithObjects:@"Quicktime", self,		nil
 *							   forKeys:@"Name",		 @"Class",	nil ];
 * The keys that should exist are: Name, Class.
 */
 
+(NSDictionary *)plugInfo;
+(BOOL)hasConfigurableNib;
+(id)configureNibView;

-(id)initWithFrame:(NSRect)frame;
-(void)close;
-(BOOL)openURL:(NSURL *)url;
-(void)precacheURL:(NSURL*)url;

-(BOOL)loadMovie;

-(void)keyDown:(NSEvent *)anEvent;
-(void)keyUp:(NSEvent *)anEvent;
-(void)mouseDown:(NSEvent *)anEvent;
-(void)mouseMoved:(NSEvent *)anEvent;

/**
 * Sent on screen size change.
 */
-(void)drawMovieFrame;

-(NSSize)naturalSize;
-(void)setLoopMode:(NSQTMovieLoopMode)flag;

-(BOOL)muted;
-(void)setMuted:(BOOL)aBOOL;
-(float)volume;
-(void)setVolume:(float)aVolume;

-(BOOL)isPlaying;
-(void)start;
-(void)stop;

-(void)ffStart:(int)seconds;
-(void)ffDo:(int)seconds;
-(void)ffEnd;
-(void)rrStart:(int)seconds;
-(void)rrDo:(int)seconds;
-(void)rrEnd;

-(void)stepBackward;
-(void)stepForward;


-(double)totalTime;
-(double)currentMovieTime;
-(void)setCurrentMovieTime:(double)newMovieTime;
-(double)currentMovieFrameRate;

-(id)menuPrefix;
-(id)menuTitle;
-(id)pluginMenu;

/** Extra Must Implement Methods **/

@end
