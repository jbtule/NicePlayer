/**
 * Preferences.h
 * NicePlayer
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

#import <Cocoa/Cocoa.h>
#import "PreferencesController.h"

enum doubleClickMoviePrefValues { MAKE_WINDOW_FULL_SCREEN, PLAY_PAUSE_MOVIE };
enum rightClickMoviePrefValues { RIGHT_CLICK_DISPLAY_CONTEXT_MENU, RIGHT_CLICK_PLAY_PAUSE_MOVIE, RIGHT_CLICK_MAKE_FULL_SCREEN };
enum scrollWheelMoviePrefValues { SCROLL_WHEEL_ADJUSTS_SIZE, SCROLL_WHEEL_ADJUSTS_VOLUME, SCROLL_WHEEL_ADJUSTS_NONE, SCROLL_WHEEL_SCRUBS };
enum scrollResizePinValues { PIN_LEFT_TOP, PIN_CENTER, PIN_SMART };
enum defaultTimeDisplayValues { ELAPSED_TIME, TIME_REMAINING };
enum defaultRepeatModeValues { REPEAT_NONE, REPEAT_LIST, REPEAT_ONE };
enum defaultOpenModeValues { OPEN_PLAYLIST, OPEN_WINDOWS };

@interface Preferences : NSObject {
	enum doubleClickMoviePrefValues doubleClickMoviePref;
	enum rightClickMoviePrefValues rightClickMoviePref;
	enum scrollWheelMoviePrefValues scrollWheelMoviePref;
	enum scrollWheelMoviePrefValues scrollWheelHorizontalMoviePref;
	enum scrollResizePinValues scrollResizePin;
	enum defaultTimeDisplayValues defaultTimeDisplay;
	enum defaultRepeatModeValues defaultRepeatMode;
	enum defaultOpenModeValues defaultOpenMode;

	int rrSpeed;
	int ffSpeed;

	BOOL autoplayOnFullScreen;
	BOOL autostopOnNormalScreen;

	BOOL showInitialOverlays;
	BOOL fadeOverlays;
	float fadeOverlayTime;
	
	BOOL showNotificationOverlays;
	BOOL fadeNotificationOverlays;
	float displayNotificationTime;
	id notificationColor;
	
	BOOL movieOpenedPlay;
	BOOL movieOpenedFullScreen;
	BOOL windowAlwaysOnTop;
	BOOL windowLeaveFullScreen;
	BOOL audioVolumeSimilarToLastWindow;
	float defaultAudioVolume;
	
	BOOL disableAppleRemote;
	BOOL disableShowingOverlaysOnKeyPress;
	float opacityWhenWindowIsTransparent;
	
	NSMutableArray *viewerPluginPrefs;
}

+(Preferences *)mainPrefs;
+(int)defaultTimeDisplayValuesNum;
+(int)defaultRepeatModeValuesNum;

-(enum doubleClickMoviePrefValues)doubleClickMoviePref;
-(void)setDoubleClickMoviePref:(enum doubleClickMoviePrefValues)anInt;
-(enum rightClickMoviePrefValues)rightClickMoviePref;
-(void)setRightClickMoviePref:(enum rightClickMoviePrefValues)anInt;
-(enum scrollWheelMoviePrefValues)scrollWheelMoviePref;
-(void)setScrollWheelMoviePref:(enum scrollWheelMoviePrefValues)anInt;
-(enum scrollWheelMoviePrefValues)scrollWheelHorizontalMoviePref;
-(void)setScrollWheelHorizontalMoviePref:(enum scrollWheelMoviePrefValues)anInt;

-(enum scrollResizePinValues)scrollResizePin;
-(void)setScrollResizePin:(enum scrollResizePinValues)anInt;
-(enum defaultTimeDisplayValues)defaultTimeDisplay;
-(void)setDefaultTimeDisplay:(enum defaultTimeDisplayValues)anInt;
-(enum defaultRepeatModeValues)defaultRepeatMode;
-(void)setDefaultRepeatMode:(enum defaultRepeatModeValues)anInt;
-(enum defaultOpenModeValues)defaultOpenMode;
-(void)setDefaultOpenMode:(enum defaultOpenModeValues)anInt;
-(BOOL)disableAppleRemote;
-(void)setDisableAppleRemote:(BOOL)aBool;

-(int)rrSpeed;
-(void)setRrSpeed:(int)anInt;
-(int)ffSpeed;
-(void)setFfSpeed:(int)anInt;

-(BOOL)autoplayOnFullScreen;
-(void)setAutoplayOnFullScreen:(BOOL)aBool;
-(BOOL)autostopOnNormalScreen;
-(void)setAutostopOnNormalScreen:(BOOL)aBool;

-(BOOL)showInitialOverlays;
-(void)setShowInitialOverlays:(BOOL)aBool;
-(BOOL)fadeOverlays;
-(void)setFadeOverlays:(BOOL)aBool;
-(float)fadeOverlayTime;
-(void)setFadeOverlayTime:(float)anInt;

-(BOOL)showNotificationOverlays;
-(void)setShowNotificationOverlays:(BOOL)aBool;
-(BOOL)fadeNotificationOverlays;
-(void)setFadeNotificationOverlays:(BOOL)aBool;
-(float)displayNotificationTime;
-(void)setDisplayNotificationTime:(float)aFloat;
-(id)notificationColor;
-(void)setNotificationColor:(id)anObject;

-(BOOL)movieOpenedPlay;
-(void)setMovieOpenedPlay:(BOOL)aBool;
-(BOOL)movieOpenedFullScreen;
-(void)setMovieOpenedFullScreen:(BOOL)aBool;
-(BOOL)windowAlwaysOnTop;
-(void)setWindowAlwaysOnTop:(BOOL)aBool;
-(BOOL)windowLeaveFullScreen;
-(void)setWindowLeaveFullScreen:(BOOL)aBool;
-(BOOL)audioVolumeSimilarToLastWindow;
-(void)setAudioVolumeSimilarToLastWindow:(BOOL)aBool;
-(float)defaultAudioVolume;
-(void)setDefaultAudioVolume:(float)aFloat;
-(BOOL)disableShowingOverlaysOnKeyPress;
-(void)setDisableShowingOverlaysOnKeyPress:(BOOL)aBool;
-(float)opacityWhenWindowIsTransparent;
-(void)setOpacityWhenWindowIsTransparent:(float)aFloat;
-(NSString*)windowPosition;
-(void)setWindowPosition:(NSPoint) aPoint;

-(void)integrateViewerPluginPrefs;
-(NSMutableArray *)viewerPluginPrefs;
-(void)setViewerPluginPrefs:(NSMutableArray *)aDictionary;
@end
