//
//  NiceDocumentScripting.m
//  NicePlayer
//
//  Created by Robert Chin on 2/13/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "NiceDocument.h"

@implementation NiceDocument (NiceDocumentScripting)

-(void)handlePauseCommand:(id)sender
{
	[theMovieView stop];
}

-(void)handlePlayPauseCommand:(id)sender
{
	if([theMovieView isPlaying])
		[theMovieView stop];
	else
		[theMovieView start];
}

-(void)stopExistingTimer
{
	if(asffrrTimer){
		SEL stopSel = NSSelectorFromString([[asffrrTimer userInfo] objectForKey:@"StopSelector"]);
		[asffrrTimer invalidate];
		asffrrTimer = nil;
		[self performSelector:stopSel];
	}
}

-(void)stopExistingTimerIfEqualsSelector:(SEL)aSelector
{
	if(asffrrTimer){
		SEL stopSel = NSSelectorFromString([[asffrrTimer userInfo] objectForKey:@"StopSelector"]);
		if(aSelector == stopSel){
			[asffrrTimer invalidate];
			asffrrTimer = nil;
		}
	}
}

-(void)startTimerWithDoSelector:(SEL)doSelector
		   finishSelectorString:(id)finishSelectorString
{
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:finishSelectorString
														 forKey:@"StopSelector"];
	asffrrTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
												   target:theMovieView
												 selector:doSelector
												 userInfo:userInfo
												  repeats:YES];
}

-(void)handleFFStartCommand:(id)sender
{
	[self stopExistingTimer];
	[self startTimerWithDoSelector:@selector(ffDo)
			  finishSelectorString:@"handleFFStopCommand:"];
	[theMovieView ffStart];
}

-(void)handleFFStopCommand:(id)sender
{
	[self stopExistingTimerIfEqualsSelector:@selector(handleFFStopCommand:)];
	[theMovieView ffEnd];
}

-(void)handleRRStartCommand:(id)sender
{
	[self stopExistingTimer];
	[self startTimerWithDoSelector:@selector(rrDo)
			  finishSelectorString:@"handleRRStopCommand:"];
	[theMovieView rrStart];
}

-(void)handleRRStopCommand:(id)sender
{
	[self stopExistingTimerIfEqualsSelector:@selector(handleRRStopCommand:)];
	[theMovieView rrEnd];
}

-(void)handleIncrementVolumeCommand:(id)sender
{
	[theMovieView incrementVolume];
}

-(void)handleDecrementVolumeCommand:(id)sender
{
	[theMovieView decrementVolume];
}

-(void)handleToggleMuteCommand:(id)sender
{
	[theMovieView toggleMute];
}

-(void)volume
{
	[theMovieView volume];
}

-(void)setVolume:(float)aFloat
{
	[theMovieView setVolume:aFloat];
}

-(void)muted
{
	[theMovieView muted];
}

-(void)setMuted:(BOOL)aBool
{
	[theMovieView setMuted:aBool];
}

@end
