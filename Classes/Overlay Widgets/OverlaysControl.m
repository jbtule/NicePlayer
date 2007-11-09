/**
 * OverlaysControl.m
 * NicePlayer
 *
 * The class that determines which overlays should be showing in which window.
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

#import "OverlaysControl.h"
#import "NiceWindow.h"

static id overlayControl = nil;

@implementation OverlaysControl

+(id)control
{
	static BOOL tooLate = NO;
	
    if ( !tooLate ) {
        overlayControl = [OverlaysControl new];
        tooLate = YES;
    }
	
	return overlayControl;
}

-(id)init
{
	if(overlayControl)
		return overlayControl;
	
	if((self = [super init])){
	}
	
	return self;
}

-(BOOL)isLocation:(NSPoint)aScreenPoint inWindow:(id)aWindow
{
	return NSMouseInRect(aScreenPoint, [aWindow frame], NO);
}

-(BOOL)inControlRegion:(NSPoint)aScreenPoint forWindow:(NiceWindow *)aWindow
{
    if([aWindow isFullScreen]){
	NSRect mainScreenFrame = [[NSScreen mainScreen] frame];
	return (aScreenPoint.y <= (mainScreenFrame.origin.y + [aWindow scrubberHeight])
		&& aScreenPoint.y >= (mainScreenFrame.origin.y)
		&& aScreenPoint.x >= mainScreenFrame.origin.x
		&& aScreenPoint.x <= mainScreenFrame.size.width);
    }
    
    NSRect windowFrame = [aWindow frame];
    NSRect mainVisibleFrame = [[NSScreen mainScreen] visibleFrame];
    NSRect tempRect = NSMakeRect(windowFrame.origin.x, windowFrame.origin.y, windowFrame.size.width, [aWindow scrubberHeight]);
    
    if (mainVisibleFrame.origin.y < windowFrame.origin.y){
	tempRect.origin = NSMakePoint(0, 0);
    } else {
	tempRect.origin = [aWindow convertScreenToBase:NSMakePoint(windowFrame.origin.x, mainVisibleFrame.origin.y)];
    }
    return NSMouseInRect([aWindow convertScreenToBase:aScreenPoint], tempRect, NO);
}

-(BOOL)inTitleRegion:(NSPoint)aScreenPoint forWindow:(NiceWindow*)aWindow
{
    if([aWindow isFullScreen]){
		NSRect mainScreenFrame = [[NSScreen mainScreen] frame];
		return (aScreenPoint.y <= (mainScreenFrame.origin.y + mainScreenFrame.size.height) 
				&& aScreenPoint.y >= (mainScreenFrame.origin.y + mainScreenFrame.size.height - [aWindow titlebarHeight] - [NSMenuView menuBarHeight]) 
				&& aScreenPoint.x >= mainScreenFrame.origin.x
				&& aScreenPoint.x <= mainScreenFrame.size.width);
	}
	
	NSRect windowFrame = [aWindow frame];
	NSRect mainVisibleFrame = [[NSScreen mainScreen] visibleFrame];
	NSRect tempRect = NSMakeRect(windowFrame.origin.x,  windowFrame.origin.y + windowFrame.size.height - [aWindow titlebarHeight],
								 windowFrame.size.width, [aWindow titlebarHeight]);
	
	if ((mainVisibleFrame.origin.y + mainVisibleFrame.size.height) > (windowFrame.origin.y + windowFrame.size.height)){	
		tempRect.origin = NSMakePoint(0, windowFrame.size.height - [aWindow titlebarHeight]);
	} else {
	    tempRect.origin = [aWindow convertScreenToBase:NSMakePoint(windowFrame.origin.x, mainVisibleFrame.origin.y
								       + mainVisibleFrame.size.height - [aWindow titlebarHeight])];
	}
	return NSMouseInRect([aWindow convertScreenToBase:aScreenPoint], tempRect, NO);
}

-(BOOL)inResizeRegion:(NSPoint)aScreenPoint forWindow:(NiceWindow*)aWindow
{
    NSRect movieRect = [aWindow frame];
    NSRect resizeRect;
    resizeRect.size.height = [aWindow resizeHeight];
    resizeRect.size.width = [aWindow resizeWidth];
    resizeRect.origin.x = movieRect.origin.x + movieRect.size.width - resizeRect.size.width;
    resizeRect.origin.y = movieRect.origin.y;
    return NSMouseInRect(aScreenPoint, resizeRect, NO);
}

-(void)mouseMovedInScreenPoint:(NSPoint)aScreenPoint
{
    id someWindows = [NSApp orderedWindows];
    id aWindow;
    unsigned i;
    BOOL hitTopMost = NO;
    
    for(i = 0, aWindow = [someWindows objectAtIndex:i];
	i < [someWindows count]; aWindow = [someWindows objectAtIndex:i++]){
	if([aWindow isKindOfClass:[NiceWindow class]]){
	    if(!hitTopMost){
		if([self showOverlayForWindow:aWindow atPoint:aScreenPoint]){
		    hitTopMost = YES;
		    continue;
		} else if([self isLocation:aScreenPoint inWindow:aWindow]){
		    hitTopMost = YES;
		}
	    }
	    [aWindow hideOverlays];
	}
    }
}

-(BOOL)showOverlayForWindow:(NiceWindow *)aWindow atPoint:(NSPoint)aScreenPoint
{
    if([self inControlRegion:aScreenPoint forWindow:aWindow]){
		[aWindow showOverlayControlBar];
		return YES;
    } else if([self inTitleRegion:aScreenPoint forWindow:aWindow]){
		[aWindow showOverLayTitle];
		return YES;
    } else if([self inResizeRegion:aScreenPoint forWindow:aWindow]){
		[aWindow showOverlayControlBar];
		return YES;
    }
    return NO;
}

@end