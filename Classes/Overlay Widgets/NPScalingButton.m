//
//  NPScalingButton.m
//  NicePlayer
//
//  Created by James Tuley on 11/8/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "NPScalingButton.h"
#import "NPScalingButtonCell.h"

@implementation NPScalingButton

-(id)initWithCoder:(id)aCoder{
    self =[super initWithCoder:aCoder];
	 NSButtonCell* tCell =[ [[NPScalingButtonCell alloc] init] autorelease];
	[tCell setBezelStyle:NSRegularSquareBezelStyle];
	[tCell setImage:[[self cell] image]];
	[tCell setAlternateImage:[[self cell] alternateImage]];
	[tCell setHighlightsBy:NSContentsCellMask];

	[tCell setBordered:NO];
	[self setCell: tCell];
	
    return self;
}


@end
