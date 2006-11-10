
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
*           James Tuley <jbtule@mac.com> (NicePlayer Author)
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

/**
* NPApplication.m
 * NicePlayer
 *
 * The application subclass that allows for us to detect mouse movement when the application
 * is not in focus, allowing us to show and hide movie controls even when other apps are
 * active.
 */

#import "NPApplication.h"
#import <CocoaScriptMenu/CocoaScriptMenu.h>
#import "NiceUtilities.h"
#import <HodgePodge/IndyKit.h>
BOOL selectNiceWindow(id each, void* context){
    return [each isKindOfClass:[NiceWindow class]];
}

@implementation NPApplication

- (void)finishLaunching
{
    [super finishLaunching];
    lastPoint = [NSEvent mouseLocation];
    inactiveTimer = nil;
    [self setDelegate:self];
   // if(NPIs10_4OrGreater()){
        if([[CSMScriptMenu sharedMenuGenerator] countOfScripts] == 0){
            [self copyDefaultScriptsToApplicationSupport];
        }
        [[CSMScriptMenu sharedMenuGenerator] updateScriptMenu];

  //  }
    
    [NSApp automaticCheckForUpdates:self];            
}

-(id)updateCheckPublicKey{return @"<30480241 00c3b3e5 eae022c2 fc065fe4 417c8edb fb2f6306 74e813ca a9860fe8 c677b735 87a7ad1f ef710ad0 eecabf9e 912487de d61de8d4 75d5dbd7 b42d985a 3810cd75 7f020301 0001>";}


-(NSString*)movieOldDefaultScriptsToApplicationSupport{
  /*   NSString* tPath =[[[NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory,NSUserDomainMask,YES) firstObject] stringByAppendingPathComponent:@"NicePlayer"] stringByAppendingPathComponent:@"Scripts"];
    
    NSDictionary tDict = [NSDictionary dictionaryWithContentsOfFile:[tPath stringByAppendingPathComponent:@".info.plist"]];
    
    while*/
    return nil;
}


-(void)copyDefaultScriptsToApplicationSupport{
    
    NSString* tPath =[[[TTCSearchPathForDirectoriesInDomains(TTCApplicationSupportDirectory,NSUserDomainMask,YES) firstObject] stringByAppendingPathComponent:@"NicePlayer"] stringByAppendingPathComponent:@"Scripts"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:tPath]){
        [[NSFileManager defaultManager] removeFileAtPath:tPath handler:nil];
    }
    
    [[NSFileManager defaultManager] copyPath:[[NSBundle mainBundle] pathForResource:@"Default Scripts" ofType:@""] toPath:tPath   handler:nil];
    [[NSDictionary dictionaryWithObjectsAndKeys:[[[NSBundle mainBundle] infoDictionary] objectForKey:
             @"CFBundleVersion"],@"BuildNumber",[[[NSBundle mainBundle] infoDictionary] objectForKey:
                 @"CFBundleShortVersionString"],@"VersionNumber",nil] writeToFile:[tPath stringByAppendingPathComponent:@".info.plist"] atomically:NO];
 
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    [self testCursorMovement];
}

- (void)mouseExited:(NSEvent *)theEvent
{
	[self testCursorMovement];
}

/**
* This method tests to see if the mouse has moved to a different location. If so, inject the event into
 * our applications loop in order to determine of the mouse is in a place where the controls should appear
 * for the movie controller or title bar.
 */
-(void)testCursorMovement
{
    if(!NSEqualPoints(lastPoint, [NSEvent mouseLocation])){
        lastPoint = [NSEvent mouseLocation];
        NSEvent *newEvent = [NSEvent mouseEventWithType:NSMouseMoved
                                               location:lastPoint
                                          modifierFlags:0
                                              timestamp:0
                                           windowNumber:0
                                                context:nil
                                            eventNumber:0
                                             clickCount:0
                                               pressure:1.0];
        [self sendEvent:newEvent];
    }
}

/* Ripped from http://www.cocoabuilder.com/archive/message/cocoa/2004/9/1/116398 */

- (void)sendEvent:(NSEvent *)anEvent
{
    // catch first right mouse click, activate app
    // and hand the event on to the window for further processing
    BOOL done = NO;
    NSPoint locationInWindow;
    NSWindow *theWindow;
    NSView *theView = nil;
    if (![self isActive]) {
        //NSLog(@"a: event type: %i", [anEvent type]);
        // we do NOT get an NSRightMouseDown event
        if(([anEvent type] == NSRightMouseUp) || ([anEvent type] == NSMouseMoved)){
            // there seems to be no window assigned with this event at the moment;
            // but just in case ...
            if ((theWindow = [anEvent window])) {
                locationInWindow = [anEvent locationInWindow];
                theView = [[theWindow contentView] hitTest:locationInWindow];
            } else {
                // find window
		NSPoint locationOnScreen = [NSEvent mouseLocation];
		NSEnumerator *enumerator = [[self orderedWindows] objectEnumerator];
		while ((theWindow = [enumerator nextObject])) {
		    if(NSPointInRect(locationOnScreen, [theWindow frame])){
			locationInWindow = [theWindow convertScreenToBase:locationOnScreen];
			NSView *contentView = [theWindow contentView];
			if(contentView){
			    theView = [contentView hitTest:locationInWindow];
			    if (theView) {
				// we found our view
				//NSLog(@"hit view of class: %@", NSStringFromClass([theView class]));
				break;
			    }
			}
		    }
		}
            }
            if (theView) {
                // create new event with useful window, location and event values
                unsigned int flags = [anEvent modifierFlags];
                NSTimeInterval timestamp = [anEvent timestamp];
                int windowNumber = [theWindow windowNumber];
                NSGraphicsContext *context = [anEvent context];
                // original event is not a mouse down event so the following values	are missing
                int eventNumber = 0; // [anEvent eventNumber]
                int clickCount = 0; // [anEvent clickCount]
                float pressure = 1.0; // [anEvent pressure]
                NSEvent *newEvent = [NSEvent mouseEventWithType:[anEvent type]
                                                       location:locationInWindow
                                                  modifierFlags:flags
                                                      timestamp:timestamp
                                                   windowNumber:windowNumber
                                                        context:context
                                                    eventNumber:eventNumber
                                                     clickCount:clickCount
                                                       pressure:pressure];
                if ([theView acceptsFirstMouse:newEvent]) {
                    // activate app and send event to the window
                    //[self activateIgnoringOtherApps:YES];
                    [theWindow sendEvent:newEvent];
                    done = YES;
                }
            }
        }
    }
    
    if (!done) {
        // we did not catch this one
        [super sendEvent:anEvent];
    }
}

-(NSArray *)movieWindows
{

    return [[super orderedWindows] selectUsingFunction:selectNiceWindow context:nil];
}

-(id)bestMovieWindow
{
    id tempWindow = [NSApp mainWindow];
    if((tempWindow == nil) || (![tempWindow isKindOfClass:[NiceWindow class]]))  {
        tempWindow = [[NSApp movieWindows] firstObject];
    }
    return tempWindow;
    
}

#pragma mark -
#pragma mark Delegate Methods

-(void)application:(NSApplication *)sender openFiles:(NSArray *)filenames
{
    [[NiceController controller] openFiles:filenames];
}

#pragma mark -
#pragma mark Application Web Links

-(IBAction)visitNicePlayerWebSite:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:
        [NSURL URLWithString:@"http://niceplayer.indyjt.com/"]];
}

-(IBAction)visitProjectRoadmap:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:
        [NSURL URLWithString:@"http://charon.laya.com/niceplayer/trac.cgi/roadmap"]];
}

-(IBAction)donateToNicePlayer:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:
        [NSURL URLWithString:@"http://niceplayer.indyjt.com/donate.php"]];
}

-(IBAction)onlineSupportWikiFAQ:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:
        [NSURL URLWithString:@"http://charon.laya.com/niceplayer/trac.cgi/wiki/ListOfQuestions"]];
}

-(IBAction)submitBug:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:
        [NSURL URLWithString:@"http://charon.laya.com/niceplayer/trac.cgi/newticket"]];
}

-(IBAction)featureRequest:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:
        [NSURL URLWithString:@"http://charon.laya.com/niceplayer/trac.cgi/wiki/FeatureRequests"]];
}

-(IBAction)visitAcknowlegementsPage:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:
        [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"acknowledgements" ofType:@"html"]]];
}

@end
