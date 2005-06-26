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

+(BOOL)accessInstanceVariablesDirectly
{
	return NO;
}



-(void)handleEnterFullScreen:(id)tempWindow
{
    [self handleEnterFullScreen:tempWindow onScreen:[tempWindow screen]];
}

-(void)handleEnterFullScreen:(id)tempWindow onScreen:(NSScreen*)aScreen
{
    [NSApp activateIgnoringOtherApps:YES];
    [tempWindow makeFullScreenOnScreen:aScreen];
    [self presentScreenOnScreen:aScreen];
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
