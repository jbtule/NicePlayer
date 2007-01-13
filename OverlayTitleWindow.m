//
//  OverlayTitleWindow.m
//  NicePlayer
//
//  Created by James Tuley on 1/10/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "OverlayTitleWindow.h"
#import "TitleBackgroundView.h"

@implementation OverlayTitleWindow:OverlayWindow


-(id)initWithContentRect:(NSRect)contentRect styleMask:(unsigned int)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    
    if((self = [super initWithContentRect:contentRect
							   styleMask:NSBorderlessWindowMask
								 backing:NSBackingStoreBuffered
								   defer:YES])){
		[self setBackgroundColor: [NSColor clearColor]];
		[self setOpaque:NO];
	}
    return self;
}



@end
