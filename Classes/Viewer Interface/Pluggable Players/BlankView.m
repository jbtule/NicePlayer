//
//  BlankView.m
//  NicePlayer
//
//  Created by James Tuley on 10/14/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "BlankView.h"


@implementation BlankView

- (void)drawRect:(NSRect)aRect{

	[self lockFocus];
	[[NSColor blackColor] set];
	NSRectFill(aRect);
	[self unlockFocus];
}



+(NSDictionary *)plugInfo{
	return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Empty",	[NSArray arrayWithObject:@""],			nil]
                                       forKeys:[NSArray arrayWithObjects:@"Name",		@"FileExtensions",	nil]];
}
+(BOOL)hasConfigurableNib{
	return false;
}

+(id)configureNibView{
	return nil;
}

-(id)initWithFrame:(NSRect)frame{
    if((self = [super initWithFrame:frame])){
		volume =1.0;
	}return self;
}
-(void)close{

}
-(BOOL)openURL:(NSURL *)url{
	return YES;
}

-(BOOL)loadMovie{
	return YES;
}

-(void)keyDown:(NSEvent *)anEvent{

}
-(void)keyUp:(NSEvent *)anEvent{}
-(void)mouseDown:(NSEvent *)anEvent{}
-(void)mouseMoved:(NSEvent *)anEvent{}

/**
 * Sent on screen size change.
 */
-(void)drawMovieFrame{}

//until re do the plugin interface
//this is a quick hack to allow percent loading
//for plugins
-(NSNumber*)_percentLoaded{

	return [NSNumber numberWithDouble: (double) -1.0];
}

-(NSSize)naturalSize{
	return NSMakeSize(320,240);
}
-(void)setLoopMode:(NSQTMovieLoopMode)flag{}

-(BOOL)muted{
	return volume < 0;
}
-(void)setMuted:(BOOL)aBOOL{
	if(aBOOL){
		if(![self muted])
			volume *= -1.0;
	}else{
		if([self muted])
			volume *= -1.0;
	}
}
-(float)volume{
	return volume;
}
-(void)setVolume:(float)aVolume{
	volume = aVolume;
}

-(BOOL)isPlaying{
	return NO;
}
-(void)start{

}
-(void)stop{

}

-(void)ffStart:(int)seconds{}
-(void)ffDo:(int)seconds{}
-(void)ffEnd{}
-(void)rrStart:(int)seconds{}
-(void)rrDo:(int)seconds{}
-(void)rrEnd{}

-(void)stepBackward{}
-(void)stepForward{}

-(BOOL)hasEnded:(id)sender{return NO;}

-(double)totalTime{ return 0.0;}
-(double)currentMovieTime{ return 0.0;}
-(void)setCurrentMovieTime:(double)newMovieTime{}
-(double)currentMovieFrameRate{ return 0.0;}

-(id)menuPrefix{    return @"Empty";
}
-(id)menuTitle{return @"Empty Movie";}

-(id)pluginMenu{return [NSMutableArray array];}


@end
