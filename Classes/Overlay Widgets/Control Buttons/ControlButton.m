/**
 * ControlButton.m
 * NicePlayer
 *
 * The superclass for the button classes that perform a down->pressed->up pattern of mouse
 * events. This set of three types of events allows us to better tell the individual movie
 * views what actions to take.
 */

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
	NSLog(@"%@ = Entered", [self class]);
}

-(void)mouseExited:(NSEvent *)theEvent
{
	[self mouseUp:theEvent];
}

@end
