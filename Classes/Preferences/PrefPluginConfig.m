//
//  PrefPluginConfig.m
//  NicePlayer
//
//  Created by Robert Chin on 12/12/04.
//  Copyright 2004 __MyCompanyName__. All rights reserved.
//

#import "PrefPluginConfig.h"
#import "../Viewer Interface/NPPluginReader.h"
#import "../Viewer Interface/Pluggable Players/NPMovieProtocol.h"

@implementation PrefPluginConfig

-(void)awakeFromNib
{
	currSubview = nil;
}

-(void)selectRowIndexes:(NSIndexSet *)indexes byExtendingSelection:(BOOL)extend
{
	[self setDelegate:self];
	[super selectRowIndexes:indexes byExtendingSelection:extend];
}

-(void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
	if(oldWindowFrame.origin.x == 0){
		oldWindowFrame = [[self window] frame];
		oldViewFrame = [insertView frame];
	}
		
	id itemClass = [self classForRow:[self selectedRow]];
	if((itemClass = [self classForRow:[self selectedRow]]) == nil)
		return;

	if(![itemClass hasConfigurableNib])
		[self hideWidgets];
	else
		[self showWidgets];
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
