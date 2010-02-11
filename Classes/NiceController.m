/**
* NiceController.m
 * NicePlayer
 *
 * The NicePlayer document controller.
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



#import "NiceController.h"
#import "NPPluginReader.h"
#import "NiceUtilities.h"
#import "NPApplication.h"
#import "AppleRemote.h"
#import "Preferences.h"
#import "NiceDocument.h"
#import <Preferable/Preferable.h>
#import <STEnum/STEnum.h>
id controller;

BOOL detectIsPlaying(id each, void* context){
    return [each isPlaying];
}

id makeBackgrounds(id each, void* context){
    id tBWindow = [[BlackWindow alloc] init];
    [tBWindow setReleasedWhenClosed:YES];
    [tBWindow setFrame:[each frame] display:YES];
    [tBWindow orderBack:nil];
    return tBWindow;
}

id swapForWindows(id each, void* context){
    
    return [each window];
    
}

@implementation NiceController

#pragma mark Class Methods
+(id)controller
{
    return controller;
}

+(void)setController:(id)aNiceController
{
    controller = aNiceController;
}

#pragma mark Instance Methods

-(void)awakeFromNib
{
    lastMouseLocation = NSMakePoint(0,0);
    fullScreenMode =  NO;
    showingMenubar = NO;
    mouseMoveTimer = [NSTimer scheduledTimerWithTimeInterval:.2
                                                      target:self
                                                    selector:@selector(checkMouseLocation:)
                                                    userInfo:nil repeats:YES]; // Auto-hides mouse.
    lastCursorMoveDate = [[NSDate alloc] init];
    backgroundWindow = [[BlackWindow alloc] init];
    backgroundWindows = nil;
    presentWindow = nil;
    [NiceController setController:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changedWindow:)
                                                 name:@"NSWindowDidBecomeMainNotification"
                                               object:nil];
    antiSleepTimer = [NSTimer scheduledTimerWithTimeInterval:30.0
                                                      target:self
                                                    selector:@selector(preventSleep:)
                                                    userInfo:nil repeats:YES];
    [NSApp setDelegate:self];
	[NSApp setRemote:[[[AppleRemote alloc]initWithDelegate:self] autorelease]];
    if(![[Preferences mainPrefs] disableAppleRemote])
		[[NSApp remote] startListening:self];
}

-(void)dealloc{
    [mouseMoveTimer invalidate];
    [antiSleepTimer invalidate];
    [lastCursorMoveDate release];
    [backgroundWindows release];
    [super dealloc];
}

-(id)mainWindowProxy
{
    return mainWindowProxy;
}

-(int)runModalOpenPanel:(NSOpenPanel *)openPanel forTypes:(NSArray *)openableFileExtensions
{
    [openPanel setAllowsMultipleSelection:YES];
    [openPanel setCanChooseDirectories:YES];
    [openPanel setCanChooseFiles:YES];
    
    return [super runModalOpenPanel:openPanel
                           forTypes:[[NPPluginReader pluginReader] allowedExtensions]];
}


/**
* Takes an array of NSString files, converts them to NSURLs and opens them, adding subsequent files to the
 *	playlist.
 */
-(void)openFiles:(NSArray *)files
{
    NSMutableArray* tArray = [NSMutableArray array];
    
    BOOL tVerifyType = NO;
    tArray =[files injectUsingFunction:NPInjectNestedDirectories into:tArray context:&tVerifyType];
  //  NSLog(@"%@",tArray);
    
    tArray =[tArray collectUsingFunction:NPConvertFileNamesToURLs context:nil];
    [self openURLs:NPSortUrls(tArray)];
}

-(void)openURLs:(NSArray *)files
{

    id tempDoc = nil;
    unsigned i;
    for (i = 0; i < [files count]; i++){
		NSError* tError = nil;
        id tempURL = [files objectAtIndex:i];
        if(([[Preferences mainPrefs] defaultOpenMode] == OPEN_WINDOWS 
			|| ([@"nicelist" isEqualTo:[[[tempURL path] pathExtension] lowercaseString]]))
           && i !=0 ){
            [self openDocumentWithContentsOfURL:tempURL display:YES error:&tError];
			if (tError) {
				[NSApp presentError:tError];
				return;
			}
            continue;
        }
        if(i==0){
            id docArray = [NSApp orderedDocuments];
            if([docArray count] > 0){
                id document = [docArray objectAtIndex:0];
                if(([document isKindOfClass:[NiceDocument class]]) && ![document isActive])
                    tempDoc = document;
                else
                    tempDoc = [self openDocumentWithContentsOfURL:tempURL display:YES error:&tError];
            } else
                tempDoc = [self openDocumentWithContentsOfURL:tempURL display:YES error:&tError];
            
            if(![@"nicelist" isEqualTo:[[[tempURL path] pathExtension] lowercaseString]])
                [tempDoc loadURL:tempURL firstTime:YES];
            else if(![tempDoc isActive])
                [tempDoc loadPlaylistFromURL:tempURL];
            
            if([[self mainDocument] isActive]){
                if([[Preferences mainPrefs] movieOpenedFullScreen])
                    [self enterFullScreen];
                if([[Preferences mainPrefs] movieOpenedPlay])
                    [[self mainDocument] play:self];
            }
        } else
            [tempDoc addURLToPlaylist:tempURL];
		
		if (tError) {
			[NSApp presentError:tError];
			return;
		}
    }
    

	[tempDoc openPlaylistDrawerConditional:self];
}

-(void)checkMouseLocation:(id)sender
{
    NSRect tempRect =[[[NSScreen screens] objectAtIndex:0] frame];
    NSPoint tempPoint =[NSEvent mouseLocation];
    if(!NSEqualPoints(lastMouseLocation,tempPoint)){
        [lastCursorMoveDate release];
        lastCursorMoveDate = [[NSDate alloc] init];
        lastMouseLocation= tempPoint;
        [NSCursor setHiddenUntilMouseMoves:NO];
    }else{
        if(fullScreenMode && ([lastCursorMoveDate timeIntervalSinceNow] < -3)){
            [NSCursor setHiddenUntilMouseMoves:YES];
        }
    }
    
    tempRect.origin.y=tempRect.size.height -24;
    tempRect.size.height =32;
}

/* As per Technical Q&A QA1160: http://developer.apple.com/qa/qa2004/qa1160.html */
-(void)preventSleep:(id)sender
{



    if([[NSApp orderedDocuments] detectUsingFunction:detectIsPlaying context:nil])
        UpdateSystemActivity(OverallAct);

}

-(id)mainDocument
{
    return [self documentForWindow:[NSApp mainWindow]];
}

-(void)changedWindow:(NSNotification *)notification
{
    if([[NSApp mainWindow] isKindOfClass:[NiceWindow class]]){
        [toggleOnTopMenuItem setState:[((NiceWindow *)[NSApp mainWindow]) windowIsFloating]];
        [toggleFixedAspectMenuItem setState:[((NiceWindow *)[NSApp mainWindow]) fixedAspect]];
    }
}

#pragma mark Interface

-(IBAction)openDocument:(id)sender
{
    NSArray* tempFiles = [self fileNamesFromRunningOpenPanel];
				
    [self openFiles:tempFiles];
}

-(IBAction)newDocument:(id)sender
{
    [super newDocument:sender];
    id tempWindow =[NSApp mainWindow];
    [NSApp changeWindowsItem:tempWindow title:[tempWindow title] filename:NO];
}

-(IBAction)presentMultiple:(id)sender
{
    
    if(fullScreenMode){
        [self exitFullScreen];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PresentMultiple" object:nil];
        [self presentAllScreeens];
        if([[Preferences mainPrefs] autoplayOnFullScreen]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayAllMovies" object:nil];
        }
    }
}

-(IBAction)playAll:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayAllMovies" object:nil];
}

-(IBAction)stopAll:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StopAllMovies" object:nil];
}


-(IBAction)toggleFullScreen:(id)sender
{
    if(fullScreenMode){
        [self exitFullScreen];
    }else if([[NSApp mainWindow] isKindOfClass:[NiceWindow self]]){
        [self enterFullScreen];
    }
}

-(IBAction)showPreferences:(id)sender
{
    if(prefWindow ==nil)
	prefWindow = [[[PFPreferenceWindowController alloc] initWithWindowNibName:@"Preferences"] retain];
    [prefWindow showWindow:self];
    if(fullScreenMode)
	[self exitFullScreen];
    [[prefWindow window] setLevel:NSFloatingWindowLevel];
    [[prefWindow window] makeKeyAndOrderFront:self];
}

-(IBAction)toggleAlwaysOnTop:(id)sender
{
    [((NiceWindow *)[NSApp mainWindow]) toggleWindowFloat];
    [toggleOnTopMenuItem setState:[((NiceWindow *)[NSApp mainWindow]) windowIsFloating]];
}

-(IBAction)toggleFixedAspectRatio:(id)sender
{
    [((NiceWindow *)[NSApp mainWindow]) toggleFixedAspectRatio];
    [toggleFixedAspectMenuItem setState:[((NiceWindow *)[NSApp mainWindow]) fixedAspect]];
}

-(IBAction)setPartiallyTransparent:(id)sender
{
    [((NiceWindow *)[NSApp mainWindow]) togglePartiallyTransparent];
    [partiallyTransparent setState:[((NiceWindow *)[NSApp mainWindow]) partiallyTransparent]];
}

-(IBAction)openWebURL:(id)sender
{
	NSURL *newURL = [NSURL URLWithString:[openURLField stringValue]];
	[self openURLs:[NSArray arrayWithObjects:newURL, nil]];
	[openURLWindow performClose:self];
}

#pragma mark -
#pragma mark Presentation

-(void)presentScreen
{
    [self presentScreenOnScreen:[NSScreen mainScreen]];
}

-(void)presentScreenOnScreen:(NSScreen*)aScreen
{
    fullScreenMode = YES;
    if([aScreen isEqualTo:[[NSScreen screens] objectAtIndex:0]])
        SetSystemUIMode(kUIModeAllHidden, kUIOptionAutoShowMenuBar);
    
    [backgroundWindow setFrame:[aScreen frame] display:YES];
    [backgroundWindow orderBack:nil];
}



-(void)presentAllScreeens
{

    backgroundWindows = [[[NSScreen screens] collectUsingFunction:makeBackgrounds context:nil] retain];
    
    fullScreenMode = YES;
    
    SetSystemUIMode(kUIModeAllHidden, kUIOptionAutoShowMenuBar);
}


-(void)unpresentAllScreeens
{
    [backgroundWindows makeObjectsPerformSelector:@selector(close)];
    
    [backgroundWindows release];
    backgroundWindows = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"unPresentMultiple" object:nil];
    
}

-(BOOL)isFullScreen{
	return fullScreenMode;
}

-(void)unpresentScreen
{
    fullScreenMode = NO;
    showingMenubar = NO;
    SetSystemUIMode(kUIModeNormal, kUIModeNormal);
    [backgroundWindow orderOut:nil];
    [self unpresentAllScreeens];
}

-(void)enterFullScreen
{
    id tempWindow = [NSApp bestMovieWindow];
    [tempWindow makeFullScreen];
    [self presentScreen];
	[tempWindow setOverLaySubtitleLocation];
    [backgroundWindow setPresentingWindow:tempWindow];
}

-(void)enterFullScreenOnScreen:(NSScreen*)aScreen
{
    id tempWindow = [NSApp bestMovieWindow];
    [tempWindow makeFullScreenOnScreen:aScreen];
    [self presentScreenOnScreen:aScreen];
	[tempWindow setOverLaySubtitleLocation];

    [backgroundWindow setPresentingWindow:tempWindow];
}


-(void)exitFullScreen
{
    id tempWindow = [NSApp bestMovieWindow];
    if(tempWindow != nil)
        [tempWindow makeNormalScreen];
    [self unpresentScreen];
}

#pragma mark -
#pragma mark Accessor Methods

-(id)backgroundWindow
{
    return backgroundWindow;
}

- (BOOL)respondsToSelector:(SEL)aSelector{
    
    NSString* aString = NSStringFromSelector(aSelector);
    if([aString hasPrefix:@"ALL"]){
        return YES;
    }else{
        return [super respondsToSelector:aSelector];
    }
    
}

-(IBAction)dummyMethod:(id)temp{
    
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    NSString* aString = NSStringFromSelector(aSelector);
    
    id tSig =[super methodSignatureForSelector:aSelector];
    
    if(tSig == nil && [aString hasPrefix:@"ALL"]){
        
        return [super methodSignatureForSelector:@selector(dummyMethod:)];
    }else{
        
        return tSig;
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    
    NSString* aString = NSStringFromSelector([anInvocation selector]);
    if([aString hasPrefix:@"ALL"] ){//&& [[anInvocation methodSignature]numberOfArguments]==3 && *[[anInvocation methodSignature]getArgumentTypeAtIndex:2]==NSObjCObjectType
        NSObject* anArgumet = nil;
        
        [anInvocation getArgument:&anArgumet atIndex:2];
        
        

        
        aString = [aString substringFromIndex:3];
        
        [[[self documents] collectUsingFunction:swapForWindows context:nil] makeObjectsPerformSelector:NSSelectorFromString(aString) withObject:nil];
    }else{
        [super forwardInvocation:anInvocation];
    }    
}

#pragma mark -
#pragma mark Apple Remote Delegate Method

-(void)sendRemoteButtonEvent:(RemoteControlEventIdentifier)buttonIdentifier pressedDown:(BOOL)pressedDown  remoteControl: (RemoteControl*) remoteControl
{
    if([[NSApp mainWindow] isKindOfClass:[NiceWindow class]])
	[[[[NSApp mainWindow] windowController] document] appleRemoteButton:buttonIdentifier pressedDown:pressedDown];
}

@end
