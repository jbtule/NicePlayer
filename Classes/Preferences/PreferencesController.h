/**
 * PreferencesController.h
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
#import "Preferences.h"
@class PFPreferenceWindowController;

@interface PreferencesController : NSObject {
    IBOutlet id prefWindow;
	IBOutlet PFPreferenceWindowController* prefWindowController;
    IBOutlet id paneMain;
    IBOutlet id paneActions;
    IBOutlet id paneOverlays;
    IBOutlet id paneView;
	IBOutlet id paneInput;
	IBOutlet id paneWindowDefaults;
	IBOutlet id paneSparkle;

    
    IBOutlet id bundlePriorityTable;
    
	
	IBOutlet id sparkleAuto;
	IBOutlet id spakleInterval;
	
    IBOutlet id doubleClickMoviePref;
    IBOutlet id rightClickMoviePref;
    IBOutlet id scrollWheelMoviePref;
	IBOutlet id scrollWheelHorizontalMoviePref;
    IBOutlet id scrollResizePin;
    IBOutlet id defaultTimeDisplay;
    IBOutlet id defaultRepeatMode;
    IBOutlet id defaultOpenMode;
    IBOutlet id enableAppleRemote;
    
    IBOutlet id rrSpeedSlider;
    IBOutlet id ffSpeedSlider;
    
    IBOutlet id autoplayOnFullScreen;
    IBOutlet id autostopOnNormalScreen;
    
    IBOutlet id showInitialOverlays;
    IBOutlet id fadeOverlays;
    IBOutlet id fadeOverlayTime;

    IBOutlet id showNotificationOverlays;
    IBOutlet id fadeNotificationOverlays;
    IBOutlet id displayNotificationTime;
    IBOutlet id notificationColor;
    
    IBOutlet id movieOpenedPlay;
    IBOutlet id movieOpenedFullScreen;
    IBOutlet id windowAlwaysOnTop;
    IBOutlet id windowLeaveFullScreen;
	IBOutlet id audioVolumeSimilarToLastWindow;
	IBOutlet id disableShowingOverlaysOnKeyPress;
	IBOutlet id opacityWhenWindowIsTransparent;
    
    id _draggingObjects;
    BOOL _tableLocked;
}


-(IBAction)sparkleStartCheck:(id)sender;

-(IBAction)doubleClickMoviePref:(id)sender;
-(IBAction)rightClickMoviePref:(id)sender;
-(IBAction)scrollWheelMoviePref:(id)sender;
-(IBAction)scrollWheelHorizontalMoviePref:(id)sender;
-(IBAction)scrollResizePin:(id)sender;
-(IBAction)defaultTimeDisplay:(id)sender;
-(IBAction)defaultRepeatMode:(id)sender;
-(IBAction)defaultOpenMode:(id)sender;
-(IBAction)enableAppleRemote:(id)sender;

-(IBAction)rrSpeed:(id)sender;
-(IBAction)ffSpeed:(id)sender;

-(IBAction)autoplayOnFullScreen:(id)sender;
-(IBAction)autostopOnNormalScreen:(id)sender;

-(IBAction)showInitialOverlays:(id)sender;
-(IBAction)fadeOverlays:(id)sender;
-(IBAction)fadeOverlayTime:(id)sender;

-(IBAction)showNotificationOverlays:(id)sender;
-(IBAction)fadeNotificationOverlays:(id)sender;
-(IBAction)displayNotificationTime:(id)sender;
-(IBAction)notificationColor:(id)sender;

-(IBAction)movieOpenedPlay:(id)sender;
-(IBAction)movieOpenedFullScreen:(id)sender;
-(IBAction)windowAlwaysOnTop:(id)sender;
-(IBAction)windowLeaveFullScreen:(id)sender;
-(IBAction)audioVolumeSimilarToLastWindow:(id)sender;
-(IBAction)disableShowingOverlaysOnKeyPress:(id)sender;
-(IBAction)opacityWhenWindowIsTransparent:(id)sender;

@end
