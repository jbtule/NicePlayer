//
//  NPScalingButtonCell.m
//  NicePlayer
//
//  Created by James Tuley on 11/8/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "NPScalingButtonCell.h"


@implementation NPScalingButtonCell


- (void)drawImage:(NSImage*)image withFrame:(NSRect)frame inView:(NSView*)controlView{
	
	[controlView lockFocus];
	[[NSGraphicsContext currentContext] saveGraphicsState];
	[[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
	[image setFlipped:YES];
	[image drawInRect:NSIntegralRect(frame) fromRect:NSMakeRect(0, 0, [image size].width, [image size].height) operation:NSCompositeSourceOver fraction:1.0];
	[[NSGraphicsContext currentContext] restoreGraphicsState];
	[controlView unlockFocus];
}

@end
