//
//  TitleBackgroundView.m
//  NicePlayer
//
//  Created by James Tuley on 1/10/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "TitleBackgroundView.h"


@implementation TitleBackgroundView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(rebuildTrackingRects)
													 name:NSViewFrameDidChangeNotification
												   object:nil];
		trackingRect = [self addTrackingRect:[self bounds] owner:[self window] userData:nil assumeInside:NO];
    }
    return self;
}

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


-(void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

-(void)rebuildTrackingRects
{
	[self viewWillMoveToWindow:[self window]];
}

-(void)viewWillMoveToWindow:(NSWindow *)window
{
	if([self window])
		[self removeTrackingRect:trackingRect];
	if(window)
		trackingRect = [self addTrackingRect:[self bounds] owner:window userData:nil assumeInside:NO];
}


@end
