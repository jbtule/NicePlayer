//
//  NiceWindowScripting.m
//  NicePlayer
//
//  Created by Robert Chin on 2/13/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "NiceWindow.h"
#import "NiceControllerScripting.h"

@implementation NiceWindow (NiceWindowScripting)

-(void)handleFullScreenCommand:(id)sender
{
	[[NiceController controller] handleEnterFullScreen:self];
}

-(void)handleNormalScreenCommand:(id)sender
{
	[[NiceController controller] handleExitFullScreen:self];
}

-(void)handleToggleFullScreenCommand:(id)sender
{
	[[NiceController controller] handleToggleFullScreen:self];
}

@end
