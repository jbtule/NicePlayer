//
//  TitleBackgroundView.m
//  NicePlayer
//
//  Created by James Tuley on 1/10/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "TitleBackgroundView.h"


@implementation TitleBackgroundView

-(void)drawRect:(NSRect)rect
{
[[NSImage imageNamed:@"titlebg"]drawInRect:[self frame] fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:0.82];
	
}

- (void)mouseDown:(NSEvent *)theEvent
{
    if([theEvent clickCount]>1)
        [[self window] performMiniaturize:theEvent];
   
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    [[self window] mouseDragged:theEvent];
}



@end
