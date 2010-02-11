/**
 * Preferences.m
 * NicePlayer
 *
 * The preferences cache for the application.
 */

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
* Portions created by the Initial Developer are Copyright (C) 2004-2006
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

#import "Preferences.h"
#import "../Viewer Interface/NPPluginReader.h"
#import "AppleRemote.h"
#import "NPApplication.h"

@implementation Preferences

+ (void)initialize
{	
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithBool:NO], @"audioVolumeSimilarToLastWindow",
		[NSNumber numberWithFloat:1.0], @"defaultAudioVolume",
		[NSNumber numberWithInt:SCROLL_WHEEL_ADJUSTS_NONE], @"scrollWheelHorizontalMoviePref",
		[NSNumber numberWithBool:NO], @"disableShowingOverlaysOnKeyPress",
		[NSNumber numberWithFloat:0.5], @"opacityWhenWindowIsTransparent",
		nil];
	
    [defaults registerDefaults:appDefaults];
}

+(Preferences *)mainPrefs
{
        static Preferences * prefs = nil;
	if(prefs == nil)
		prefs = [Preferences new];
	return prefs;
}

+(int)defaultTimeDisplayValuesNum;
{
	return 2;
}

+(int)defaultRepeatModeValuesNum;
{
	return 3;
}

-(id)init
{
	if((self = [super init])){
		doubleClickMoviePref = [[NSUserDefaults standardUserDefaults] integerForKey:@"doubleClickMoviePref"];
		rightClickMoviePref = [[NSUserDefaults standardUserDefaults] integerForKey:@"rightClickMoviePref"];
		scrollWheelMoviePref = [[NSUserDefaults standardUserDefaults] integerForKey:@"scrollWheelMoviePref"];
		scrollWheelHorizontalMoviePref = [[NSUserDefaults standardUserDefaults] integerForKey:@"scrollWheelHorizontalMoviePref"];
		disableAppleRemote = [[NSUserDefaults standardUserDefaults] boolForKey:@"disableAppleRemote"];

		if([[NSUserDefaults standardUserDefaults] objectForKey:@"scrollResizePin"] == nil)
		    scrollResizePin = PIN_SMART;
		else
		    scrollResizePin = [[NSUserDefaults standardUserDefaults] integerForKey:@"scrollResizePin"];
		defaultTimeDisplay = [[NSUserDefaults standardUserDefaults] integerForKey:@"defaultTimeDisplay"];
		defaultRepeatMode = [[NSUserDefaults standardUserDefaults] integerForKey:@"defaultRepeatMode"];
		defaultOpenMode = [[NSUserDefaults standardUserDefaults] integerForKey:@"defaultOpenMode"];

		rrSpeed = ([[NSUserDefaults standardUserDefaults] integerForKey:@"rrSpeed"] == 0)
			? 5 
			: [[NSUserDefaults standardUserDefaults] integerForKey:@"rrSpeed"];
		ffSpeed = ([[NSUserDefaults standardUserDefaults] integerForKey:@"ffSpeed"] == 0) 
			? 5 
			: [[NSUserDefaults standardUserDefaults] integerForKey:@"ffSpeed"];

		autoplayOnFullScreen = [[NSUserDefaults standardUserDefaults] boolForKey:@"autoplayOnFullScreen"];
		autostopOnNormalScreen = [[NSUserDefaults standardUserDefaults] boolForKey:@"autostopOnNormalScreen"];

		showInitialOverlays = ![[NSUserDefaults standardUserDefaults] boolForKey:@"noShowInitialOverlays"];
		fadeOverlays = ![[NSUserDefaults standardUserDefaults] boolForKey:@"noFadeOverlays"];
		fadeOverlayTime = ([[NSUserDefaults standardUserDefaults] floatForKey:@"fadeOverlayTime"] <= 0.0) 
		    ? 5.0
		    : [[NSUserDefaults standardUserDefaults] floatForKey:@"fadeOverlayTime"];
		
		showNotificationOverlays = ![[NSUserDefaults standardUserDefaults] boolForKey:@"noShowNotificationOverlays"];
		fadeNotificationOverlays = ![[NSUserDefaults standardUserDefaults] boolForKey:@"noFadeNotificationOverlays"];
		displayNotificationTime = ([[NSUserDefaults standardUserDefaults] floatForKey:@"displayNotificationTime"] <= 0.0) 
		    ? 2.0
		    : [[NSUserDefaults standardUserDefaults] floatForKey:@"displayNotificationTime"];
		notificationColor = [[NSUserDefaults standardUserDefaults] objectForKey:@"notificationColor"];
		if(notificationColor)
		    notificationColor =	[[NSUnarchiver unarchiveObjectWithData:notificationColor] retain];
		else
		    notificationColor = [[NSColor whiteColor] retain];
		
		movieOpenedPlay = [[NSUserDefaults standardUserDefaults] boolForKey:@"movieOpenedPlay"];
		movieOpenedFullScreen = [[NSUserDefaults standardUserDefaults] boolForKey:@"movieOpenedFullScreen"];
		windowAlwaysOnTop = ![[NSUserDefaults standardUserDefaults] boolForKey:@"windowNotAlwaysOnTop"];
		windowLeaveFullScreen = ![[NSUserDefaults standardUserDefaults] boolForKey:@"windowNotLeaveFullScreen"];
		audioVolumeSimilarToLastWindow = [[NSUserDefaults standardUserDefaults] boolForKey:@"audioVolumeSimilarToLastWindow"];
		defaultAudioVolume = [[NSUserDefaults standardUserDefaults] floatForKey:@"defaultAudioVolume"];
		disableShowingOverlaysOnKeyPress = [[NSUserDefaults standardUserDefaults] boolForKey:@"disableShowingOverlaysOnKeyPress"];
		opacityWhenWindowIsTransparent = [[NSUserDefaults standardUserDefaults] floatForKey:@"opacityWhenWindowIsTransparent"];
		[self integrateViewerPluginPrefs];
	}
	return self;
}

-(enum doubleClickMoviePrefValues)doubleClickMoviePref
{
	return doubleClickMoviePref;
}

-(void)setDoubleClickMoviePref:(enum doubleClickMoviePrefValues)anInt
{
	doubleClickMoviePref = anInt;
	[[NSUserDefaults standardUserDefaults] setInteger:anInt forKey:@"doubleClickMoviePref"];
}

-(enum rightClickMoviePrefValues)rightClickMoviePref
{
	return rightClickMoviePref;
}

-(void)setRightClickMoviePref:(enum rightClickMoviePrefValues)anInt
{
	rightClickMoviePref = anInt;
	[[NSUserDefaults standardUserDefaults] setInteger:anInt forKey:@"rightClickMoviePref"];
}

-(enum scrollWheelMoviePrefValues)scrollWheelMoviePref
{
    return scrollWheelMoviePref;
}

-(void)setScrollWheelMoviePref:(enum scrollWheelMoviePrefValues)anInt
{
    scrollWheelMoviePref = anInt;
    [[NSUserDefaults standardUserDefaults] setInteger:anInt forKey:@"scrollWheelMoviePref"];
}

-(enum scrollWheelMoviePrefValues)scrollWheelHorizontalMoviePref
{
    return scrollWheelHorizontalMoviePref;
}

-(void)setScrollWheelHorizontalMoviePref:(enum scrollWheelMoviePrefValues)anInt
{
    scrollWheelHorizontalMoviePref = anInt;
    [[NSUserDefaults standardUserDefaults] setInteger:anInt forKey:@"scrollWheelHorizontalMoviePref"];
}

-(enum scrollResizePinValues)scrollResizePin
{
	return scrollResizePin;
}

-(void)setScrollResizePin:(enum scrollResizePinValues)anInt
{
	scrollResizePin = anInt;
	[[NSUserDefaults standardUserDefaults] setInteger:anInt forKey:@"scrollResizePin"];
}

-(void)setWindowPosition:(NSPoint) aPoint
{
	[[NSUserDefaults standardUserDefaults] setObject:NSStringFromPoint(aPoint) forKey:@"windowOrigin"];
}

-(NSString*)windowPosition
{
	return [[NSUserDefaults standardUserDefaults] valueForKey:@"windowOrigin"];
}

-(enum defaultTimeDisplayValues)defaultTimeDisplay
{
	return defaultTimeDisplay;
}

-(void)setDefaultTimeDisplay:(enum defaultTimeDisplayValues)anInt
{
	defaultTimeDisplay = anInt;
	[[NSUserDefaults standardUserDefaults] setInteger:anInt forKey:@"defaultTimeDisplay"];
}

-(enum defaultRepeatModeValues)defaultRepeatMode
{
	return defaultRepeatMode;
}

-(void)setDefaultRepeatMode:(enum defaultRepeatModeValues)anInt
{
	defaultRepeatMode = anInt;
	[[NSUserDefaults standardUserDefaults] setInteger:anInt forKey:@"defaultRepeatMode"];
}

-(enum defaultOpenModeValues)defaultOpenMode
{
	return defaultOpenMode;
}

-(void)setDefaultOpenMode:(enum defaultOpenModeValues)anInt
{
	defaultOpenMode = anInt;
	[[NSUserDefaults standardUserDefaults] setInteger:anInt forKey:@"defaultOpenMode"];
}

-(BOOL)disableAppleRemote
{
    return disableAppleRemote;
}

-(void)setDisableAppleRemote:(BOOL)aBool
{
    disableAppleRemote = aBool;
    if(!disableAppleRemote)
	[[(NPApplication*)NSApp remote] startListening:self];
    else
	[[(NPApplication*)NSApp remote] stopListening:self];

    [[NSUserDefaults standardUserDefaults] setBool:aBool forKey:@"disableAppleRemote"];
}

#pragma mark -

-(int)rrSpeed
{
	return rrSpeed;
}

-(void)setRrSpeed:(int)anInt
{
	rrSpeed = anInt;
	[[NSUserDefaults standardUserDefaults] setInteger:anInt forKey:@"rrSpeed"];
}

-(int)ffSpeed
{
	return ffSpeed;
}

-(void)setFfSpeed:(int)anInt
{
	ffSpeed = anInt;
	[[NSUserDefaults standardUserDefaults] setInteger:anInt forKey:@"ffSpeed"];
}

#pragma mark -

-(BOOL)autoplayOnFullScreen
{
	return autoplayOnFullScreen;
}

-(void)setAutoplayOnFullScreen:(BOOL)aBool
{
	autoplayOnFullScreen = aBool;
	[[NSUserDefaults standardUserDefaults] setBool:aBool forKey:@"autoplayOnFullScreen"];
}

-(BOOL)autostopOnNormalScreen
{
	return autostopOnNormalScreen;
}

-(void)setAutostopOnNormalScreen:(BOOL)aBool
{
	autostopOnNormalScreen = aBool;
	[[NSUserDefaults standardUserDefaults] setBool:aBool forKey:@"autostopOnNormalScreen"];
}

#pragma mark -

-(BOOL)showInitialOverlays
{
	return showInitialOverlays;
}

-(void)setShowInitialOverlays:(BOOL)aBool
{
	showInitialOverlays = aBool;
	[[NSUserDefaults standardUserDefaults] setBool:!aBool forKey:@"noShowInitialOverlays"];
}

-(BOOL)fadeOverlays
{
	return fadeOverlays;
}

-(void)setFadeOverlays:(BOOL)aBool
{
	fadeOverlays = aBool;
	[[NSUserDefaults standardUserDefaults] setBool:!aBool forKey:@"noFadeOverlays"];
}

-(float)fadeOverlayTime
{
    return fadeOverlayTime;
}

-(void)setFadeOverlayTime:(float)aFloat
{
    fadeOverlayTime = aFloat;
    [[NSUserDefaults standardUserDefaults] setFloat:aFloat forKey:@"fadeOverlayTime"];
}

#pragma mark -

-(BOOL)showNotificationOverlays
{
    return showNotificationOverlays;
}

-(void)setShowNotificationOverlays:(BOOL)aBool
{
    showNotificationOverlays = aBool;
    [[NSUserDefaults standardUserDefaults] setBool:!aBool forKey:@"noShowNotificationOverlays"];
}

-(BOOL)fadeNotificationOverlays
{
    return fadeNotificationOverlays;
}

-(void)setFadeNotificationOverlays:(BOOL)aBool
{
    fadeNotificationOverlays = aBool;
    [[NSUserDefaults standardUserDefaults] setBool:!aBool forKey:@"noFadeNotificationOverlays"];
}

-(float)displayNotificationTime
{
    return displayNotificationTime;
}

-(void)setDisplayNotificationTime:(float)aFloat
{
    displayNotificationTime = aFloat;
    [[NSUserDefaults standardUserDefaults] setFloat:aFloat forKey:@"displayNotificationTime"];
}

-(id)notificationColor
{
    return notificationColor;
}

-(void)setNotificationColor:(id)anObject
{
    notificationColor = anObject;
    [[NSUserDefaults standardUserDefaults] setObject:[NSArchiver archivedDataWithRootObject:anObject] forKey:@"notificationColor"];
}

#pragma mark -

-(BOOL)movieOpenedPlay
{
	return movieOpenedPlay;
}

-(void)setMovieOpenedPlay:(BOOL)aBool
{
	movieOpenedPlay = aBool;
	[[NSUserDefaults standardUserDefaults] setBool:aBool forKey:@"movieOpenedPlay"];
}

-(BOOL)movieOpenedFullScreen
{
	return movieOpenedFullScreen;
}

-(void)setMovieOpenedFullScreen:(BOOL)aBool
{
	movieOpenedFullScreen = aBool;
	[[NSUserDefaults standardUserDefaults] setBool:aBool forKey:@"movieOpenedFullScreen"];
}

-(BOOL)windowAlwaysOnTop
{
	return windowAlwaysOnTop;
}

-(void)setWindowAlwaysOnTop:(BOOL)aBool
{
	windowAlwaysOnTop = aBool;
	[[NSUserDefaults standardUserDefaults] setBool:!aBool forKey:@"windowNotAlwaysOnTop"];
}

-(BOOL)windowLeaveFullScreen
{
	return windowLeaveFullScreen;
}

-(void)setWindowLeaveFullScreen:(BOOL)aBool
{
	windowLeaveFullScreen = aBool;
	[[NSUserDefaults standardUserDefaults] setBool:!aBool forKey:@"windowNotLeaveFullScreen"];
}

-(BOOL)audioVolumeSimilarToLastWindow
{
	return audioVolumeSimilarToLastWindow;
}

-(void)setAudioVolumeSimilarToLastWindow:(BOOL)aBool
{
	audioVolumeSimilarToLastWindow = aBool;
	[[NSUserDefaults standardUserDefaults] setBool:aBool forKey:@"audioVolumeSimilarToLastWindow"];
}

-(float)defaultAudioVolume
{
	return defaultAudioVolume;
}

-(void)setDefaultAudioVolume:(float)aFloat
{
	defaultAudioVolume = aFloat;
	[[NSUserDefaults standardUserDefaults] setFloat:aFloat forKey:@"defaultAudioVolume"];
}

-(BOOL)disableShowingOverlaysOnKeyPress
{
	return disableShowingOverlaysOnKeyPress;
}

-(void)setDisableShowingOverlaysOnKeyPress:(BOOL)aBool
{
	disableShowingOverlaysOnKeyPress = aBool;
	[[NSUserDefaults standardUserDefaults] setFloat:aBool forKey:@"disableShowingOverlaysOnKeyPress"];
}

-(float)opacityWhenWindowIsTransparent
{
	return opacityWhenWindowIsTransparent;
}

-(void)setOpacityWhenWindowIsTransparent:(float)aFloat
{
	[self willChangeValueForKey:@"opacityWhenWindowIsTransparent"];
	opacityWhenWindowIsTransparent = aFloat;
	[[NSUserDefaults standardUserDefaults] setFloat:aFloat forKey:@"opacityWhenWindowIsTransparent"];
	[self didChangeValueForKey:@"opacityWhenWindowIsTransparent"];
}

#pragma mark -

-(void)integrateViewerPluginPrefs
{
	viewerPluginPrefs = [[NPPluginReader pluginReader] integratePrefs:
		[[NSUserDefaults standardUserDefaults] valueForKey:@"viewerPluginPrefs"]];
}

-(NSMutableArray *)viewerPluginPrefs
{
	return viewerPluginPrefs;
}

-(void)setViewerPluginPrefs:(NSMutableArray *)anArray
{
	viewerPluginPrefs = anArray;
	[[NSUserDefaults standardUserDefaults] setObject:anArray forKey:@"viewerPluginPrefs"];
}

@end
