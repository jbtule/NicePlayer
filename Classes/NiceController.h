/**
* NiceController.h
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
* Jay Tuley & Robert Chin.
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


#import <AppKit/AppKit.h>
#import <Carbon/Carbon.h>
#import "Overlay Widgets/BlackWindow.h"
#import "NiceWindow/NiceWindow.h"

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
	IBOutlet id partiallyTransparent;
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
-(IBAction)setPartiallyTransparent:(id)sender;
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
