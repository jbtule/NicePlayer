//
//  NiceDrawer.m
//  NicePlayer
//
//  Created by Robert Chin on 2/10/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

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

#import "NiceDrawer.h"
#import "NiceDocument.h"

/*************************
Drawers are evil private children, and aren't like normal children thus
they need their own private methods --
they ignore their public ones they inherited from super.
**************************/
@interface NSDrawerWindow : NSWindow 
    -(NSWindow*)_parentWindow;
    -(void)_setTexturedBackground:(bool)hasTexture;
@end

@implementation NiceDrawer

-(void)awakeFromNib{
//[(NSDrawerWindow*)[self window]_setTexturedBackground:YES];  
}

- (void)mouseMoved:(NSEvent *)anEvent
{
	id theWindow = [(NSDrawerWindow*)[self window] _parentWindow];
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
										   location:[theWindow mouseLocationOutsideOfEventStream]
									  modifierFlags:flags
										  timestamp:timestamp
									   windowNumber:windowNumber
											context:context
										eventNumber:eventNumber
										 clickCount:clickCount
										   pressure:pressure];
	
	[theWindow mouseMoved:newEvent];
}

-(void)keyDown:(NSEvent *)anEvent
{
	//NSLog(@"%d",[[anEvent characters] characterAtIndex:0]);

	if(([anEvent type] == NSKeyDown)
	   && 
		([[anEvent characters] characterAtIndex:0] == 127
		||[[anEvent characters] characterAtIndex:0] == 63272)){
		[(NiceDocument *)[[[(NSDrawerWindow*)[self window] _parentWindow] windowController] document] removeURLFromPlaylistAtIndexSet:[playlistTable selectedRowIndexes]];
		return;
	}
	[super keyDown:anEvent];
}

@end
