//
//  FadeOut.m
//  NicePlayer
//
//  Created by Robert Chin on 2/11/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "FadeOut.h"
#import "Preferences.h"

#define INITIAL_FADE_DURATION	5.0
#define ALPHA_VALUE_DELTA		0.04
#define TIMER_INTERVAL			0.01

static id fadeOutInstance = nil;

@implementation FadeOut

+(id)fadeOut
{
	if(!fadeOutInstance)
		fadeOutInstance = [FadeOut new];
	return fadeOutInstance;
}

-(id)init
{
	if(self = [super init]){
		windowList = [[NSMutableSet set] retain];
		faderTimer = nil;
	}
	return self;
}

-(void)initialFadeForObjects:(id)anArray
{
	if([[Preferences mainPrefs] showInitialOverlays]){
		[NSTimer scheduledTimerWithTimeInterval:INITIAL_FADE_DURATION
										 target:self
									   selector:@selector(doInitialFadeForObjects:)
									   userInfo:anArray
										repeats:NO];
	} else {
		id anObject, e = [anArray objectEnumerator];
		while(anObject = [e nextObject]){
			[anObject setAlphaValue:0.0];
		}
	}
}

-(void)doInitialFadeForObjects:(NSTimer *)aTimer
{
	if([[Preferences mainPrefs] fadeOverlays]){
		[windowList addObjectsFromArray:[aTimer userInfo]];
		[self destroyAndCreateTimer];
	} else {
		id anObject, e = [[aTimer userInfo] objectEnumerator];
		while(anObject = [e nextObject]){
			[anObject setAlphaValue:0.0];
		}
	}
}

-(void)addWindow:(id)anObject
{
	if([[Preferences mainPrefs] fadeOverlays]){
		[windowList addObject:anObject];
		[self destroyAndCreateTimer];
	} else
		[anObject setAlphaValue:0.0];
}

-(void)removeWindow:(id)anObject
{
	[windowList removeObject:anObject];
}

-(void)destroyAndCreateTimer
{
	if(([windowList count] > 0) && (faderTimer == nil)){
		faderTimer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL
													  target:self
													selector:@selector(updateAlphaValues)
													userInfo:nil
													 repeats:YES];
	}
	if(([windowList count] == 0) && (faderTimer != nil)){
		[faderTimer invalidate];
		faderTimer = nil;
	}
}

-(void)updateAlphaValues
{
	id anObject, e = [windowList objectEnumerator];
	while(anObject = [e nextObject]){
		float newValue = [anObject alphaValue] - ALPHA_VALUE_DELTA;
		newValue = (newValue < 0.0) ? 0.0 : newValue;
		[anObject setAlphaValue:newValue];
	}
	[self testForRemoval];
	[self destroyAndCreateTimer];
}

-(void)testForRemoval
{
	id newSet = [[NSMutableSet set] retain];
	id anObject, e = [windowList objectEnumerator];
	while(anObject = [e nextObject]){
		if([anObject alphaValue] > 0.0)
			[newSet addObject:anObject];
	}
	
	[windowList release];
	windowList = newSet;
}

@end
