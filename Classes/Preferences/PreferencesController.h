/**
 * PreferencesController.h
 * NicePlayer
 */

#import <Cocoa/Cocoa.h>
#import "Preferences.h"

@interface PreferencesController : NSObject {
    IBOutlet id prefWindow;
    IBOutlet id paneMain;
    IBOutlet id paneActions;
    IBOutlet id paneOverlays;
    IBOutlet id paneView;
    
    IBOutlet id bundlePriorityTable;
    
    IBOutlet id doubleClickMoviePref;
    IBOutlet id rightClickMoviePref;
    IBOutlet id scrollWheelMoviePref;
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
    
    id _draggingObjects;
    BOOL _tableLocked;
}

-(IBAction)doubleClickMoviePref:(id)sender;
-(IBAction)rightClickMoviePref:(id)sender;
-(IBAction)scrollWheelMoviePref:(id)sender;
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

@end
