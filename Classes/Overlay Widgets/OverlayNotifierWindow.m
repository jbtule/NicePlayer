//
//  OverlayNotifierWindow.m
//  NicePlayer
//
//  Created by Robert Chin on 4/9/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "OverlayNotifierWindow.h"


@implementation OverlayNotifierWindow

-(void)awakeFromNib
{
    NSString *versionString = [NSString stringWithFormat:@"NicePlayer v%@ (%@)",
	[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"],
	[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"]];
    [self setText:versionString];
}

-(void)setText:(NSString *)aString
{
    NSMutableAttributedString *newString = [[NSMutableAttributedString alloc] initWithString:aString];
    [newString addAttribute:NSForegroundColorAttributeName
		      value:[[Preferences mainPrefs] notificationColor]
		      range:NSMakeRange(0, [newString length])];
    [theNotificationText setAttributedStringValue:newString];
    [newString autorelease];
    [self display];
}

@end
