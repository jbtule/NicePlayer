//
//  NiceControllerScripting.m
//  NicePlayer
//
//  Created by Robert Chin on 2/13/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "NiceController.h"
#import "NiceControllerScripting.h"

@implementation NiceController (NiceControllerScripting)

-(void)handleEnterFullScreen:(id)tempWindow
{
	[NSApp activateIgnoringOtherApps:YES];
	[tempWindow makeFullScreen];
	[self presentScreen];
	[backgroundWindow setPresentingWindow:tempWindow];
}

-(void)handleExitFullScreen:(id)tempWindow
{
	if(tempWindow != nil)
		[tempWindow makeNormalScreen];
	[self unpresentScreen];
}

-(void)handleToggleFullScreen:(id)tempWindow
{
	if(fullScreenMode)
		[self handleExitFullScreen:tempWindow];
	else
		[self handleEnterFullScreen:tempWindow];
}

@end
