//
//  FadeOut.m
//  NicePlayer
//
//  Created by Robert Chin on 2/11/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//


/* ***** BEGIN LICENSE BLOCK *****
* Version: MPL 1.1/GPL 2.0/LGPL 2.1
*
* The contents of this file are subject to the Mozilla Public License Version
* 1.1 (the "License"); you may not use this file except in compliance with
* the License. You may obtain a copy of the License at
* http://www.mozilla.org/MPL/
*
* Software distributed under the License is distributed on an "AS IS" basis,
* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
* for the specific language governing rights and limitations under the
* License.
*
* The Original Code is NicePlayer.
*
* The Initial Developer of the Original Code is
* James Tuley & Robert Chin.
* Portions created by the Initial Developer are Copyright (C) 2004-2005
* the Initial Developer. All Rights Reserved.
*
* Contributor(s):
*           Robert Chin <robert@osiris.laya.com> (NicePlayer Author)
*           James Tuley <jay+nicesource@tuley.name> (NicePlayer Author)
*
* Alternatively, the contents of this file may be used under the terms of
* either the GNU General Public License Version 2 or later (the "GPL"), or
* the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
* in which case the provisions of the GPL or the LGPL are applicable instead
* of those above. If you wish to allow use of your version of this file only
* under the terms of either the GPL or the LGPL, and not to allow others to
* use your version of this file under the terms of the MPL, indicate your
* decision by deleting the provisions above and replace them with the notice
* and other provisions required by the GPL or the LGPL. If you do not delete
* the provisions above, a recipient may use your version of this file under
* the terms of any one of the MPL, the GPL or the LGPL.
*
* ***** END LICENSE BLOCK ***** */



#import "FadeOut.h"
#import "Preferences.h"
#import "NiceWindow.h"

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
	if((self = [super init])){
		windowSet = [[NSMutableSet set] retain];
		faderTimer = nil;
	}
	return self;
}

-(id)initialFadeForDict:(id)aDictionary
{
    return [self fadeForDict:aDictionary
		   inSeconds:[[Preferences mainPrefs] fadeOverlayTime]];
}

-(id)notifierFadeForDict:(id)aDictionary
{
    return [self fadeForDict:aDictionary inSeconds:[[Preferences mainPrefs] displayNotificationTime]];
}

-(id)fadeForDict:(id)aDictionary inSeconds:(float)seconds
{
	return [NSTimer scheduledTimerWithTimeInterval:seconds
						target:self
					      selector:@selector(doFadeForDict:)
					      userInfo:aDictionary
					       repeats:NO];
}

-(void)doFadeForDict:(NSTimer *)aTimer
{
	if([[Preferences mainPrefs] fadeOverlays]){
		[windowSet unionSet:[[aTimer userInfo] objectForKey:@"Fade"]];
		[self destroyAndCreateTimer];
	} else {
		id anObject, e = [[aTimer userInfo] objectEnumerator];
		while((anObject = [e nextObject])){
			[anObject setAlphaValue:0.0];
		}
	}
	
    NSString *selString = [[aTimer userInfo] objectForKey:@"Selector"];
    if(selString){
		[[[aTimer userInfo] objectForKey:@"Window"] performSelector:NSSelectorFromString(selString)];
    }
}

-(void)addWindow:(id)anObject
{
	if([[Preferences mainPrefs] fadeOverlays]){
		[windowSet addObject:anObject];
		[self destroyAndCreateTimer];
	} else
		[anObject setAlphaValue:0.0];
}

-(void)removeWindow:(id)anObject
{
	[windowSet removeObject:anObject];
}

-(void)destroyAndCreateTimer
{
	if(([windowSet count] > 0) && (faderTimer == nil)){
		faderTimer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL
													  target:self
													selector:@selector(updateAlphaValues)
													userInfo:nil
													 repeats:YES];
	}
	if(([windowSet count] == 0) && (faderTimer != nil)){
		[faderTimer invalidate];
		faderTimer = nil;
	}
}

-(void)updateAlphaValues
{
	id anObject, e = [windowSet objectEnumerator];
	while((anObject = [e nextObject])){
		float newValue = [anObject alphaValue] - ALPHA_VALUE_DELTA;
		newValue = (newValue < 0.0) ? 0.0 : newValue;
		[anObject setAlphaValue:newValue];
	}
	[self testForRemoval];
	[self destroyAndCreateTimer];
}

-(void)testForRemoval
{
	id newSet = [NSMutableSet set];
	id anObject, e = [windowSet objectEnumerator];
	while((anObject = [e nextObject])){
		if([anObject alphaValue] > 0.0)
			[newSet addObject:anObject];
	}
	
	[windowSet setSet:newSet];
}

@end
