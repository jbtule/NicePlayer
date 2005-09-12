/**
 * NiceWindow.h
 * NicePlayer
 */

#import <Cocoa/Cocoa.h>
#import "../Viewer Interface/NPMovieView.h"
#import "NiceDocument.h"
#import "../Preferences/Preferences.h"
#import "../Overlay Widgets/OverlaysControl.h"
#import "../NiceController.h"
#import "../Overlay Widgets/NiceScrubber.h"
#import "../Overlay Widgets/Control Buttons/ControlButton.h"

@interface NiceWindow : NSWindow
{
    IBOutlet id theMovieView;
    IBOutlet id theOverlayWindow;
    IBOutlet id theOverlayTitleBar;
    IBOutlet id theOverlayVolume;
    IBOutlet id theOverlaySubTitle;
    IBOutlet id theOverlayNotifier;
    IBOutlet id theVolumeView;
    IBOutlet id theTitleField;

    IBOutlet id theScrubBar;
    IBOutlet id theTimeField;
    IBOutlet id thePlayButton;
    IBOutlet id theRRButton;
    IBOutlet id theFFButton;
	
    BOOL windowOverlayIsShowing;
    BOOL titleOverlayIsShowing;
	
    BOOL resizeDrag;
    BOOL scrubbingDrag;
    BOOL fullScreen;
    BOOL presentScreen;
    BOOL fillScreen;
    BOOL fillWidthScreen;
    BOOL isFilling;
    BOOL isWidthFilling;
    BOOL isInitialDisplay;    
    BOOL fixedAspectRatio;
    
    BOOL dropScreen;		/* Controls movie dropping onto other screens (not the primary display) */
    BOOL theWindowIsFloating;
	
    id timeUpdaterTimer;
    int oldWindowLevel;
    int timeDisplayStyle;
    float miniVolume;
    NSRect beforeFullScreen;

    id initialFadeObjects;
    id initialFadeTimer;
	
    NSSize aspectRatio;
    
    id notifierTimer;
}

-(BOOL)validateMenuItem:(NSMenuItem*)anItem;
-(IBAction)performClose:(id)sender;
-(void)updateVolume;
-(void)restoreVolume;
-(void)performMiniaturize:(id)sender;
-(BOOL)inResizeLocation:(NSEvent *)anEvent;
-(void)rotateTimeDisplayStyle;
-(IBAction)updateByTime:(id)sender;

#pragma mark -
#pragma mark Interface Items

-(void)displayAlertString:(NSString *)aString withInformation:(NSString *)anotherString;

#pragma mark -
#pragma mark Overlays
-(BOOL)scrubberInUse;
-(void)setupOverlays;
-(void)putOverlay:(id)anOverlay inFrame:(NSRect)aFrame withVisibility:(BOOL)isVisible;
-(void)hideOverlays;
-(void)hideInitialWindows;
-(void)hideAllImmediately;
-(void)initialFadeComplete;
-(void)showOverLayWindow;
-(void)setOverlayWindowLocation;
-(void)hideOverLayWindow;
-(void)showOverLayTitle;
-(void)setOverlayTitleLocation;
-(void)hideOverLayTitle;
-(void)showOverLayVolume;
-(void)setOverLayVolumeLocation;
-(void)hideOverLayVolume;

#pragma mark -
#pragma mark Window Toggles

-(BOOL)toggleWindowFullScreen;
-(void)unFullScreen;
-(BOOL)windowIsFloating;
-(BOOL)windowIsFixedAspect;
-(void)setWindowIsFloating:(BOOL)aBool;
-(void)toggleFixedAspectRatio;
-(void)toggleWindowFloat;

#pragma mark Window Attributes

-(void)makeFullScreen;
-(void)makeFullScreenOnScreen:(NSScreen*) aScreen;
-(void)makeNormalScreen;
-(void)presentMultiple;
-(void)unPresentMultiple;
-(void)floatWindow;
-(void)unfloatWindow;
-(BOOL)isFullScreen;
-(void)setLevel:(int)windowLevel;
-(void)resizeWithSize:(NSSize)aSize animate:(BOOL)animate;
-(NSRect)calcResizeSize:(NSSize)aSize;
-(void)resize:(float)amount animate:(BOOL)animate;
- (void)setTitle:(NSString *)aString;
-(void)setNotificationText:(NSString *)aString;
-(void)setNotifierLocation;
-(void)hideNotifier;
-(void)initialDefaultSize;
-(IBAction)halfSize:(id)sender;
-(IBAction)normalSize:(id)sender;
-(IBAction)doubleSize:(id)sender;
-(void)resetFillingFlags;
-(IBAction)fillScreenSize:(id)sender;
-(void)fillScreenSizeOnScreen:(NSScreen*)aScreen;
-(IBAction)fillWidthSize:(id)sender;
-(void)fillWidthSizeWithScreen:(NSScreen*)aScreen;
-(void)setAspectRatio:(NSSize)ratio;
-(NSSize)getResizeAspectRatioSize;
-(NSSize)getResizeAspectRatioSizeOnScreen:(NSScreen*) aScreen;
-(void)resizeToAspectRatio;
-(void)resizeNormalByScaler:(float)aScaler;
-(IBAction)center:(id)sender;
- (void)centerOnScreen:(NSScreen*)aScreen;
-(void)center;
-(NSRect)centerRect:(NSRect)aRect;
-(NSRect)centerRect:(NSRect)aRect onScreen:(NSScreen*)aScreen;

#pragma mark -
#pragma mark Mouse Events

-(void)mouseDown:(NSEvent *)theEvent;
-(void)mouseDragged:(NSEvent *)anEvent;
- (void)mouseMoved:(NSEvent *)anEvent;
-(void)mouseUp:(NSEvent *)anEvent;
-(void)rightMouseUp:(NSEvent *)anEvent;
-(void)mouseDoubleClick:(NSEvent *)anEvent;

#pragma mark -
#pragma mark Accessor Methods

-(id)playButton;
-(id)rrButton;
-(id)ffButton;
-(id)movieView;

-(NSArray *)acceptableDragTypes;

@end
