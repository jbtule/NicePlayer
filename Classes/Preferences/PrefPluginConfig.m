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

-(id)dataCellForRow:(int)row
{
	if(row == -1)
		return [self dataCell];
	
	id tableColumns = [[self tableView] tableColumns];
	id aTableRow = [tableColumns objectAtIndex:1];
	id anObject = [[[self tableView] dataSource] tableView:[self tableView] objectValueForTableColumn:aTableRow row:row];

	id itemClass = [[[[NPPluginReader pluginReader] prefDictionary] valueForKey:anObject] valueForKey:@"Class"];
	
	if(![itemClass hasConfigurableNib])
		return [self dataCell];
	
	id button = [[NSButtonCell new] autorelease];
	[button setTitle:@"Configure"];
	[button setBezelStyle:NSTexturedSquareBezelStyle];
	[button setButtonType:NSMomentaryLightButton];
	[button setControlSize:NSSmallControlSize];
	[button setShowsStateBy:NSPushInCellMask];
	
	[button setTarget:itemClass];
	[button setAction:@selector(displayConfigureNib)];
	return button;
}

@end
