//
//  NiceWindowController.m
//  NicePlayer
//
//  Created by Robert Chin on 2/12/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "NiceWindowController.h"
#import "NiceWindow.h"

@implementation NiceWindowController

-(id)initWithWindowNibName:(NSString *)windowNibName
{
	if(self = [super initWithWindowNibName:windowNibName]){
	}
	return self;
}

-(IBAction)showWindow:(id)sender
{
	[super showWindow:sender];
	[(NiceWindow *)[self window] setupOverlays];
}

-(NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName
{
	if([displayName hasPrefix:@"Untitled"])
		return @"NicePlayer";
	else
		return displayName;
}

@end
