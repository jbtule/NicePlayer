//
//  ResizeTriangle.m
//  NicePlayer
//
//  Created by Robert Chin on 2/14/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "ResizeTriangle.h"


@implementation ResizeTriangle

- (id)initWithContentRect:(NSRect)contentRect styleMask:(unsigned int)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
	if(self = [super initWithContentRect:contentRect
							   styleMask:NSBorderlessWindowMask
								 backing:NSBackingStoreBuffered
								   defer:YES]){
		[self setBackgroundColor: [NSColor clearColor]];
		[self setIgnoresMouseEvents:YES];
		[self setOpaque:NO];
	}
	return self;
}

-(void)awakeFromNib
{
	[self setHasShadow:NO];
}

-(void)setAlphaValue:(float)windowAlpha
{
    [super setAlphaValue:windowAlpha];
    
    if(windowAlpha ==0.0){
        id tWin =[self parentWindow];
        [tWin removeChildWindow:self];
        [self orderWindow:NSWindowBelow relativeTo:[[tWin parentWindow] windowNumber]];
        [tWin addChildWindow:self ordered:NSWindowBelow];
    }else if(windowAlpha ==1.0){
        id tWin =[self parentWindow];
        [tWin removeChildWindow:self];
        [self orderWindow:NSWindowAbove relativeTo:[[tWin parentWindow] windowNumber]];
        [tWin addChildWindow:self ordered:NSWindowAbove]; 
    }
    
}

-(void)setFrame:(NSRect)frameRect display:(BOOL)flag
{
	NSRect newRect = NSMakeRect(frameRect.origin.x + frameRect.size.width-14, frameRect.origin.y, 14, 14);
	[super setFrame:newRect display:flag];
}

@end
