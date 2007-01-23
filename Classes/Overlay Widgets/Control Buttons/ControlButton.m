/**
 * ControlButton.m
 * NicePlayer
 *
 * The superclass for the button classes that perform a down->pressed->up pattern of mouse
 * events. This set of three types of events allows us to better tell the individual movie
 * views what actions to take.
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

#import "ControlButton.h"

@implementation ControlButton

-(id)initWithFrame:(NSRect)rect
{
    if ((self = [super initWithFrame:rect])) {
		start = NO;
		activated = NO;
		tRectTag = 0;
	}
    return self;
}

-(void)awakeFromNib
{
	[self setTarget:self];
	[self setAction:@selector(mousePressed:)];
	[self setContinuous:YES];
	
	/* The following line controls mouse over highlights. */
	[self makeTrackingRect];
}

-(void)setActionView:(id)aView
{
	actionView = aView;
}

-(void)mouseStart
{
}

-(void)mouseDown:(NSEvent *)theEvent
{
	[self setState:NSOnState];
	[super mouseDown:theEvent];
}

-(BOOL)isInFinalState
{
	if([self state] == NSOffState)
		return YES;
	return NO;
}

-(void)mousePressed:(id)sender
{
	if(!start){
		[self mouseStart];
		start = YES;
	}
	
	if([self isInFinalState]){
		[self mouseUp:nil];
	}
}

-(void)mouseUp:(NSEvent *)theEvent
{
	start = NO;
	[super mouseUp:theEvent];
	[self setState:NSOffState];
}

/* For mouseover changes */

-(void)setFrame:(NSRect)frameRect
{
	[super setBounds:frameRect];
	[self makeTrackingRect];
}

-(void)setBounds:(NSRect)boundsRect
{
	[super setBounds:boundsRect];
	[self makeTrackingRect];
}

-(void)makeTrackingRect
{
	if(tRectTag)
		[self removeTrackingRect:tRectTag];
	tRectTag = [self addTrackingRect:[self bounds] owner:self userData:nil assumeInside:NO];
}

-(void)mouseEntered:(NSEvent *)theEvent
{
}

-(void)mouseExited:(NSEvent *)theEvent
{
	[self mouseUp:theEvent];
}

@end
