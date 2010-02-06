
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
#import <Sparkle/Sparkle.h>
#import <STEnum/STEnum.h>




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
	
	if(NPBuildingForMacPorts){
		[self setShouldCheckAtStartup:NO];
	}

	
        if([[CSMScriptMenu sharedMenuGenerator] countOfScripts] == 0){
            [self copyDefaultScriptsToApplicationSupport];
        }else{
			[self moveOldDefaultScriptsAndCopy];

		}
        [[CSMScriptMenu sharedMenuGenerator] updateScriptMenu];
    
}

-(RemoteControl*) remote{
	return remote;
}

-(void)setRemote:(RemoteControl*)aRemote{
	remote=[aRemote retain];
}


-(IBAction)checkForUpdatesMain:(id)sender{
	if(NPBuildingForMacPorts)
		NSRunInformationalAlertPanel(@"This copy of NicePlayer was built using MacPorts!", @"To update using the ports system on your computer.", @"Okay",nil, nil);
	else
		[sparkleUpdater checkForUpdates:nil];
}

-(void)setShouldCheckAtStartup:(bool)aBool{
	[[NSUserDefaults standardUserDefaults] setBool:aBool forKey: SUCheckAtStartupKey];
	
}
-(bool)shouldCheckAtStartUp{
	return [[NSUserDefaults standardUserDefaults] boolForKey: SUCheckAtStartupKey];
	
}



-(void)moveOldDefaultScriptsAndCopy{
    NSString* tPath =[[[TTCSearchPathForDirectoriesInDomains(TTCApplicationSupportDirectory,NSUserDomainMask,YES) firstObject] stringByAppendingPathComponent:@"NicePlayer"] stringByAppendingPathComponent:@"Scripts"];
    
    NSDictionary* tDict = [NSDictionary dictionaryWithContentsOfFile:[tPath stringByAppendingPathComponent:@".info.plist"]];
    
    if ([[tDict objectForKey:@"BuildNumber"] compare:@"569"] == NSOrderedAscending){
		NSCalendarDate* tDate =[NSCalendarDate date];
		
		NSString* tFormattedDate = [tDate descriptionWithCalendarFormat:@"_%Y_%m_%d"];
		
		[[NSFileManager defaultManager] movePath:tPath toPath:[tPath stringByAppendingString:tFormattedDate] handler:nil];
		[self copyDefaultScriptsToApplicationSupport];
	}
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
        NSEvent *newEvent = [[NSEvent mouseEventWithType:NSMouseMoved
                                               location:lastPoint
                                          modifierFlags:0
                                              timestamp:0
                                           windowNumber:0
                                                context:nil
                                            eventNumber:0
                                             clickCount:0
                                               pressure:1.0] retain];
        [self sendEvent:newEvent];
		[newEvent release];
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

-(IBAction)emailAuthor:(id)sender{
    id tempInfo =[[NSBundle mainBundle] infoDictionary];
    id tempEmail =[tempInfo objectForKey:@"JTAuthorEmail"];
    if(tempEmail == nil){
        NSRunAlertPanel(@"Email", @"Contact email address not provided by author.", @"Okay",nil,nil);
    }else{
        NSLog([NSString stringWithFormat:@"mailto:%@?subject=%@/%@(v%@)",tempEmail,[tempInfo objectForKey:@"CFBundleName"],[tempInfo objectForKey:@"CFBundleShortVersionString"],[tempInfo objectForKey:@"CFBundleVersion"],nil]);
        [[NSWorkspace sharedWorkspace ]openURL: [NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@?subject=%@/%@(v%@)",tempEmail,[tempInfo objectForKey:@"CFBundleName"],[tempInfo objectForKey:@"CFBundleShortVersionString"],[tempInfo objectForKey:@"CFBundleVersion"],nil]]];
    }
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
        [NSURL URLWithString:@"http://code.google.com/p/niceplayer/"]];
}

-(IBAction)visitProjectRoadmap:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:
        [NSURL URLWithString:@"http://code.google.com/p/niceplayer/issues/list"]];
}

-(IBAction)donateToNicePlayer:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:
        [NSURL URLWithString:@"http://code.google.com/p/niceplayer/wiki/Donations"]];
}

-(IBAction)onlineSupportWikiFAQ:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:
        [NSURL URLWithString:@"http://code.google.com/p/niceplayer/w/list"]];
}

-(IBAction)customHelp:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:
	 [NSURL URLWithString:@"http://code.google.com/p/niceplayer/wiki/NicePlayerHelp"]];
}

-(IBAction)submitBug:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:
        [NSURL URLWithString:@"http://code.google.com/p/niceplayer/issues/entry?template=User%20defect%20report"]];
}

-(IBAction)featureRequest:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:
	[NSURL URLWithString:@"http://code.google.com/p/niceplayer/issues/entry?template=User%20feature%20request"]];
}

-(IBAction)disccusionGroup:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:
	[NSURL URLWithString:@"http://groups.google.com/group/niceplayer-discuss?hl=en"]];
}


-(IBAction)visitAcknowlegementsPage:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:
        [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"acknowledgements" ofType:@"html"]]];
}

@end
