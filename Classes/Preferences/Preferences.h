/**
 * Preferences.h
 * NicePlayer
 */

#import <Cocoa/Cocoa.h>
#import "PreferencesController.h"

enum doubleClickMoviePrefValues { MAKE_WINDOW_FULL_SCREEN, PLAY_PAUSE_MOVIE };
enum rightClickMoviePrefValues { RIGHT_CLICK_DISPLAY_CONTEXT_MENU, RIGHT_CLICK_PLAY_PAUSE_MOVIE };
enum scrollWheelMoviePrefValues { SCROLL_WHEEL_ADJUSTS_SIZE, SCROLL_WHEEL_ADJUSTS_VOLUME };
enum scrollResizePinValues { PIN_LEFT_TOP, PIN_CENTER, PIN_SMART };
enum defaultTimeDisplayValues { ELAPSED_TIME, TIME_REMAINING };
enum defaultRepeatModeValues { REPEAT_NONE, REPEAT_LIST, REPEAT_ONE };
enum defaultOpenModeValues { OPEN_PLAYLIST, OPEN_WINDOWS };

@interface Preferences : NSObject {
	enum doubleClickMoviePrefValues doubleClickMoviePref;
	enum rightClickMoviePrefValues rightClickMoviePref;
	enum scrollWheelMoviePrefValues scrollWheelMoviePref;
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

-(enum scrollResizePinValues)scrollResizePin;
-(void)setScrollResizePin:(enum scrollResizePinValues)anInt;
-(enum defaultTimeDisplayValues)defaultTimeDisplay;
-(void)setDefaultTimeDisplay:(enum defaultTimeDisplayValues)anInt;
-(enum defaultRepeatModeValues)defaultRepeatMode;
-(void)setDefaultRepeatMode:(enum defaultRepeatModeValues)anInt;
-(enum defaultOpenModeValues)defaultOpenMode;
-(void)setDefaultOpenMode:(enum defaultOpenModeValues)anInt;

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

-(void)integrateViewerPluginPrefs;
-(NSMutableArray *)viewerPluginPrefs;
-(void)setViewerPluginPrefs:(NSMutableArray *)aDictionary;
@end
