//
//  DelegateAnimation.m
//  NicePlayer
//
//  Created by Robert Chin on 11/10/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "DelegateAnimation.h"

@protocol DelegateAnimationAddition
-(void)setCurrentAnimationValue:(float)value;
@end

@implementation DelegateAnimation

-(void)setCurrentProgress:(NSAnimationProgress)progress
{
	[super setCurrentProgress:progress];
	[[self delegate] setCurrentAnimationValue:[self currentValue]];
}

@end
