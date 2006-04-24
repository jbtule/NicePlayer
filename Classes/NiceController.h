/**
* NiceController.h
 * NicePlayer
 */

#import <AppKit/AppKit.h>
#import <Carbon/Carbon.h>
#import "Overlay Widgets/BlackWindow.h"
#import "NiceWindow/NiceWindow.h"
#import <HodgePodge/IndyKit.h>

@interface NiceController : NSDocumentController {
    IBOutlet id mainWindowProxy;
    bool fullScreenMode;
    bool showingMenubar;
    NSDate* lastCursorMoveDate;
    NSPoint lastMouseLocation;
    NSTimer* mouseMoveTimer;
    id backgroundWindow;
    id prefWindow;
    id presentWindow;
    NSArray* backgroundWindows;
    IBOutlet id toggleOnTopMenuItem;
    id antiSleepTimer;
    IBOutlet id toggleFixedAspectMenuItem;
	IBOutlet id openURLField;
	IBOutlet id openURLWindow;
}

+(id)controller;
+(void)setController:(id)aNiceController;

-(id)mainWindowProxy;
-(void)openFiles:(NSArray *)files;
-(void)openURLs:(NSArray *)files;
-(void)checkMouseLocation:(id)sender;
-(id)mainDocument;
-(void)changedWindow:(NSNotification *)notification;

#pragma mark Interface

-(IBAction)openDocument:(id)sender;
-(IBAction)newDocument:(id)sender;
-(IBAction)presentMultiple:(id)sender;
-(IBAction)playAll:(id)sender;
-(IBAction)stopAll:(id)sender;
-(IBAction)toggleFullScreen:(id)sender;
-(IBAction)showPreferences:(id)sender;
-(IBAction)toggleAlwaysOnTop:(id)sender;
-(IBAction)toggleFixedAspectRatio:(id)sender;

-(IBAction)openWebURL:(id)sender;

#pragma mark -
#pragma mark Presentation

-(void)presentScreen;
-(void)presentScreenOnScreen:(NSScreen*)aScreen;
-(void)presentAllScreeens;
-(void)unpresentAllScreeens;
-(void)unpresentScreen;
-(void)enterFullScreen;
-(void)enterFullScreenOnScreen:(NSScreen*)aScreen;
-(void)exitFullScreen;

#pragma mark -
#pragma mark Accessor Methods

-(id)backgroundWindow;

@end
