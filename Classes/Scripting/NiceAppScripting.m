//
//  NiceAppScripting.m
//  NicePlayer
//
//  Created by Robert Chin on 2/14/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "NPApplication.h"

/* To enable AE debugging: defaults write NSGlobalDomain NSScriptingDebugLogLevel 1 */
@implementation NPApplication (NiceAppScripting)

/* The default NSApp implementation is bogus when it comes to supporting AS... strange. */
-(void)handleOpenScriptCommand:(id)sender
{
	if([[sender directParameter] isKindOfClass:[NSArray class]]){
		[[NiceController controller] openFiles:[sender directParameter]];
	} else {
		NSURL *newURL = (NSURL *)CFURLCreateWithFileSystemPath(NULL, (CFStringRef)[sender directParameter], 
															   kCFURLHFSPathStyle, NO);
		[[NiceController controller] openFiles:[NSArray arrayWithObject:[newURL path]]];
		[newURL release];
	}
}

-(void)handleQuitScriptCommand:(id)sender
{
	[self terminate:self];
}

@end
