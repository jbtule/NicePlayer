/**
 * NiceWindow.h
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

@class NPMovieView;
@class NiceScrubber;

@interface NiceWindow : NSWindow
{
    IBOutlet NPMovieView* theMovieView;
    IBOutlet id theOverlayControllerWindow;
    IBOutlet id theOverlayTitleBar;
    IBOutlet id theOverlayVolume;
	IBOutlet id theOverlaySubTitleWindow;
    IBOutlet id theOverlaySubTitle;
    IBOutlet id theOverlayNotifier;
    IBOutlet id theVolumeView;
    IBOutlet id theTitleField;
	IBOutlet id theResizeWindow;
	
    IBOutlet NiceScrubber* theScrubBar;
    IBOutlet id theTimeField;
    IBOutlet id thePlayButton;
    IBOutlet id theRRButton;
    IBOutlet id theFFButton;
	
    BOOL windowOverlayControllerIsShowing;
    BOOL titleOverlayIsShowing;
	
    BOOL resizeDrag;
    BOOL scrubbingDrag;
    BOOL fullScreen;
    BOOL presentScreen;
    BOOL fillScreen;
    BOOL fillWidthScreen;
    BOOL isFilling;
	BOOL isClosing;
    BOOL isWidthFilling;
    BOOL isInitialDisplay;    
    BOOL fixedAspectRatio;
    BOOL partiallyTransparent;
	
    BOOL dropScreen;		/* Controls movie dropping onto other screens (not the primary display) */
    BOOL theWindowIsFloating;
    id timeUpdaterTimer;
    int oldWindowLevel;
    int timeDisplayStyle;
    float miniVolume;
    NSRect beforeFullScreen;

    id initialFadeTimer;
	
    NSSize aspectRatio;
	NSPoint initialDrag;
    
    id notifierTimer;
	NSSize _lastSize;

	
}
-(float)resizeWidth;
-(float)resizeHeight;
-(float)scrubberHeight;

-(float)titlebarHeight;

-(void)setResizeDrag:(bool)aDrag;


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
-(void)putOverlay:(NSWindow*)anOverlay asChildOf:(NSWindow*)aChild inFrame:(NSRect)aFrame withVisibility:(BOOL)isVisible;
-(void)hideOverlays;
-(void)hideInitialWindows;
-(void)hideAllImmediately;
-(void)initialFadeComplete;
-(void)automaticShowOverlayControllerWindow;
-(void)showOverlayControlBar;
-(void)setOverlayControllerWindowLocation;
-(void)hideOverLayWindow;
-(void)showOverLayTitle;
-(void)setOverlayTitleLocation;
-(void)hideOverLayTitle;
-(void)automaticShowOverLayVolume;
-(void)showOverLayVolume;
-(void)setOverLayVolumeLocation;
-(void)hideOverLayVolume;
-(id)subtitleView;
-(void)setOverLaySubtitleLocation;
-(void)showOverLaySubtitle;
-(BOOL)isOverlaySubtitleShowing;
-(void)hideOverLaySubtitle;
#pragma mark -
#pragma mark Window Toggles

-(BOOL)toggleWindowFullScreen;
-(void)unFullScreen;
-(BOOL)windowIsFloating;
-(BOOL)fixedAspect;
-(void)setFixedAspect:(BOOL)aBool;
-(void)setWindowIsFloating:(BOOL)aBool;
-(void)toggleFixedAspectRatio;
-(void)togglePartiallyTransparent;
-(BOOL)partiallyTransparent;
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
-(void)setInitialDrag:(NSEvent *)anEvent;
-(void)scrollWheel:(NSEvent *)anEvent;

#pragma mark -
#pragma mark Accessor Methods

-(id)playButton;
-(id)rrButton;
-(id)ffButton;

-(NSArray *)acceptableDragTypes;

@end
