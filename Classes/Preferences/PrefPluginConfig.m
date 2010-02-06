//
//  PrefPluginConfig.m
//  NicePlayer
//
//  Created by Robert Chin on 12/12/04.
//  Copyright 2004 __MyCompanyName__. All rights reserved.
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

#import "PrefPluginConfig.h"
#import "../Viewer Interface/NPPluginReader.h"
#import "../Viewer Interface/Pluggable Players/NPMovieProtocol.h"

@implementation PrefPluginConfig

-(void)awakeFromNib
{
    currSubview = nil;
    isShowingExpanded = NO;
}

-(void)selectRowIndexes:(NSIndexSet *)indexes byExtendingSelection:(BOOL)aBool
{
	[self setDelegate:self];
	[super selectRowIndexes:indexes byExtendingSelection:aBool];
}

-(void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
	if(!isShowingExpanded){
		oldWindowFrame = [[self window] frame];
		oldViewFrame = [insertView frame];
	}
		
	id itemClass = [self classForRow:[self selectedRow]];
	if(itemClass == nil)
		return;

	if(![itemClass hasConfigurableNib]){
	    [self hideWidgets];
	    isShowingExpanded = NO;
	} else {
	    [self showWidgets];
	    isShowingExpanded = YES;
	}
}

-(void)hideWidgets
{
	[visibleView setHidden:YES];
	NSRect windowRect = NSMakeRect([[self window] frame].origin.x, oldWindowFrame.origin.y, [[self window] frame].size.width, oldWindowFrame.size.height);
	[[self window] setFrame:windowRect display:YES animate:YES];
	NSRect viewRect = oldViewFrame;
	[insertView setFrame:viewRect];
	[currSubview removeFromSuperview];
	currSubview = nil;
}

-(void)showWidgets
{
	id aPluginClass = [self classForRow:[self selectedRow]];
	NSView *aView = [aPluginClass configureNibView];
	[visibleView setHidden:NO];
	int newHeightOffset = [aView frame].size.height;
	NSRect windowRect = NSMakeRect([[self window] frame].origin.x, oldWindowFrame.origin.y - newHeightOffset - oldViewFrame.size.height,
								   [[self window] frame].size.width, oldWindowFrame.size.height + newHeightOffset + oldViewFrame.size.height);
	[[self window] setFrame:windowRect display:YES animate:YES];
	if(currSubview)
		[currSubview removeFromSuperview];

	[insertView addSubview:aView];
	currSubview = aView;
	NSRect frameRect = NSMakeRect([insertView frame].origin.x, [insertView frame].origin.y - newHeightOffset + oldViewFrame.size.height, [insertView frame].size.width, newHeightOffset);
	[insertView setFrame:frameRect];
}

-(id)classForRow:(int)row
{
	if(row == -1)
		return nil;

	id tableColumns = [self tableColumns];
	id aTableRow = [tableColumns objectAtIndex:1];
	id anObject = [[self dataSource] tableView:self objectValueForTableColumn:aTableRow row:row];
	
	id itemClass = [[[[NPPluginReader pluginReader] prefDictionary] valueForKey:anObject] valueForKey:@"Class"];
	
	return itemClass;
}

@end
