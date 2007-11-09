/**
* NiceScrubber.h
 * NicePlayer
 *
 * The implementation of the movie scrubber.
 */

/* ***** BEGIN LICENSE BLOCK *****
* Version: MPL 1.1/GPL 2.0/LGPL 2.1
*
* The contents of this file are subject to the Mozilla Public License Version
* 1.1 (the "License"); you may not use this file except in compliance with
* the License. You may obtain a copy of the License at
* http://www.mozilla.org/MPL/
*
* Software distributed under the License is distributed on an "AS IS" basis,
* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
* for the specific language governing rights and limitations under the
* License.
*
* The Original Code is NicePlayer.
*
* The Initial Developer of the Original Code is
* James Tuley & Robert Chin.
* Portions created by the Initial Developer are Copyright (C) 2004-2006
* the Initial Developer. All Rights Reserved.
*
* Contributor(s):
*           Robert Chin <robert@osiris.laya.com> (NicePlayer Author)
*           James Tuley <jay+nicesource@tuley.name> (NicePlayer Author)
*
* Alternatively, the contents of this file may be used under the terms of
* either the GNU General Public License Version 2 or later (the "GPL"), or
* the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
* in which case the provisions of the GPL or the LGPL are applicable instead
* of those above. If you wish to allow use of your version of this file only
* under the terms of either the GPL or the LGPL, and not to allow others to
* use your version of this file under the terms of the MPL, indicate your
* decision by deleting the provisions above and replace them with the notice
* and other provisions required by the GPL or the LGPL. If you do not delete
* the provisions above, a recipient may use your version of this file under
* the terms of any one of the MPL, the GPL or the LGPL.
*
* ***** END LICENSE BLOCK ***** */

#import "NiceScrubber.h"
#import <Carbon/Carbon.h>

#define OFFSET (10 * HIGetScaleFactor())

@implementation NiceScrubber

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
		
      //  left = [[NSImage imageNamed:@"scrubbar_left"]retain];
//		right = [[NSImage imageNamed:@"scrubbar_right"]retain];
//		center = [[NSImage imageNamed:@"scrubbar_center"]retain];
		
		scrubClick = [[NSImage imageNamed:@"scrubberClick"]retain];
		scrub = [[NSImage imageNamed:@"scrubber"] retain];
		value=0.0;
		loaded=1.0;
		target = nil;
		action = NULL;
		dragging = NO;
    }
    return self;
}

-(void)dealloc
{
    [left release];
    [right release];
    [center release];
    [scrubClick release];
    [scrub release];
    [target release];
    [super dealloc];
}

- (void)drawRect:(NSRect)rect
{
    /* I think it looks better without the pressed state -- the entire area is draggable anyway, and you can
	click at any point and continue dragging and the entire thing will drag at that point anyway. */
    id tempImage = scrub;
//#if 0
//    if (dragging)
//        tempImage = scrubClick;
//    else 
//        tempImage = scrub;
//#endif
    
	if([self loadedValue] >= 0){
		    [self lockFocus];

		//[left drawAtPoint:NSMakePoint(0,0) 
//				 fromRect:NSMakeRect(0, 0,
//									 [left size].width,
//									 [left size].height) 
//				operation:NSCompositeSourceOver
//				 fraction:1.0];
//    	
//		[center drawInRect:NSMakeRect(5,0,
//									  [self frame].size.width-10,
//									  [self frame].size.height)
//				  fromRect:NSMakeRect(0,0,
//									  [center size].width,
//									  [center size].height) 
//				 operation:NSCompositeSourceOver
//				  fraction:1.0];
		
		CGPoint points[2];
		points[0] = CGPointMake(OFFSET , floor([self frame].size.height / 2.0));
		points[1] = CGPointMake([self frame].size.width - OFFSET, floor([self frame].size.height / 2.0));
		
		points[1].x =(points[1].x - 	points[0].x) * [self loadedValue] + points[0].x;
		
		CGContextRef cgRef = [[NSGraphicsContext currentContext] graphicsPort];
		CGContextSetAllowsAntialiasing(cgRef, NO);
		CGContextSetGrayStrokeColor(cgRef, 1.0, 1.0);
		CGContextSetLineWidth(cgRef, 1);
		CGContextSetLineCap(cgRef, kCGLineCapRound);
		CGContextStrokeLineSegments(cgRef, points, 2);
		CGContextSetAllowsAntialiasing(cgRef, YES);
//		
//		[right drawAtPoint:NSMakePoint([self frame].size.width-5,0)
//				  fromRect:NSMakeRect(0,0,
//									  [right size].width,
//									  [right size].height) 
//				 operation:NSCompositeSourceOver
//				  fraction:1.0];
    	
		float scrubWidth = [self frame].size.height;//width and height are equal with scrubber
		float scrubHeight = [self frame].size.height;

		
		[[NSGraphicsContext currentContext] saveGraphicsState];
		[[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
		NSPoint tPoint =NSMakePoint(OFFSET+([self doubleValue]*([self frame].size.width-(OFFSET * 2))),[self frame].size.height/2 );
		NSRect tScrubRect =NSMakeRect(tPoint.x, tPoint.y, scrubWidth, scrubHeight);
		[tempImage drawInRect:NSIntegralRect(NSOffsetRect(tScrubRect,- tScrubRect.size.width/2.0,-tScrubRect.size.height/2.0))
										
					 
					 fromRect:NSMakeRect(0,0,
										  [tempImage size].width,
										  [tempImage size].height) 
					 operation:NSCompositeSourceOver
					  fraction:1.0];
		[[NSGraphicsContext currentContext] restoreGraphicsState];

		[self unlockFocus];
	}
    
}

-(void)setLoadedValue:(double)aValue
{
    loaded = aValue;
}

-(double)loadedValue
{
    return loaded;
}

-(void)setDoubleValue:(double)aValue
{
    value = aValue;
}

-(double)doubleValue
{
    return value;
}

-(void)setTarget:(id)aTarget
{
    [target release];
    target = [aTarget retain];
}

-(id)target
{
    return target;
}
-(void)setAction:(SEL)anAction
{
    action = anAction;
}

-(SEL)action
{
    return action;
}


- (void)mouseDragged:(NSEvent *)anEvent
{
    float loc =[self convertPoint:[anEvent locationInWindow]fromView:nil].x;
    
    if(loc <= OFFSET)
        [self setDoubleValue:0.0];
    else if(loc >=OFFSET && loc <= ([self frame].size.width-OFFSET)){
        [self setDoubleValue: (loc-OFFSET)/([self frame].size.width-(OFFSET * 2))];
        
    } else 
        [self setDoubleValue:1.0];
    [[self target] performSelector:[self action]withObject:self];
}

-(BOOL)inUse
{
    return dragging;
}

-(void)mouseUp:(NSEvent *)anEvent
{
    dragging = NO;
    [self setNeedsDisplay:YES];
}

-(void)mouseDown:(NSEvent *)anEvent
{
    dragging =YES;
    float loc =[self convertPoint:[anEvent locationInWindow]fromView:nil].x;
	
    if(loc <= OFFSET)
        [self setDoubleValue:0.0];
    else if(loc >=OFFSET && loc <= ([self frame].size.width-OFFSET)){
        [self setDoubleValue: (loc-OFFSET)/([self frame].size.width-(OFFSET * 2))];
		
    } else 
        [self setDoubleValue:1.0];
    [[self target] performSelector:[self action]withObject:self];
}

@end
