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
    
    BOOL dropScreen;		/* Controls movie dropping onto other screens (not the primary display) */
	BOOL theWindowIsFloating;
	
    id timeUpdaterTimer;
	id initialFadeObjects;
    int oldWindowLevel;
	int timeDisplayStyle;
    float miniVolume;
    NSRect beforeFullScreen;
	id initialFadeTimer;
}

- (BOOL)validateMenuItem:(NSMenuItem*)anItem;
-(IBAction)performClose:(id)sender;
-(void)updateVolume;
-(void)restoreVolume;
- (void)performMiniaturize:(id)sender;
-(BOOL)inResizeLocation:(NSEvent *)anEvent;
-(void)rotateTimeDisplayStyle;
-(IBAction)updateByTime:(id)sender;

#pragma mark -
#pragma mark Overlays

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
-(void)setWindowIsFloating:(BOOL)aBOOL;
-(void)toggleWindowFloat;

#pragma mark Window Attributes

-(void)makeFullScreen;
-(void)makeNormalScreen;
-(void)presentMultiple;
-(void)unPresentMultiple;
-(void)floatWindow;
-(void)unfloatWindow;
-(BOOL)isFullScreen;
-(void)setLevel:(int)windowLevel;
-(void)resizeWithSize:(NSSize)aSize animate:(BOOL)animate;
-(void)resize:(float)amount animate:(BOOL)animate;
- (void)setTitle:(NSString *)aString;
-(void)initialDefaultSize;
-(IBAction)halfSize:(id)sender;
-(IBAction)normalSize:(id)sender;
-(IBAction)doubleSize:(id)sender;
-(void)resetFillingFlags;
-(IBAction)fillScreenSize:(id)sender;
-(IBAction)fillWidthSize:(id)sender;
-(void)setAspectRatio:(NSSize)ratio;
-(NSSize)getResizeAspectRatioSize;
-(void)resizeToAspectRatio;
-(void)resizeNormalByScaler:(float)aScaler;
-(IBAction)center:(id)sender;
-(void)center;
-(NSRect)centeredLocation;

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
