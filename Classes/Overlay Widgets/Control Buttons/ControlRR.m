/**
 * ControlRR.m
 * NicePlayer
 *
 * The rewind button implementation.
 */

#import "ControlRR.h"

@implementation ControlRR

-(void)mouseStart
{
	[actionView rrStart];
	activated = YES;
}

-(void)mousePressed:(NSEvent *)theEvent
{
	if(![self isInFinalState])
		[actionView rrDo];
	[super mousePressed:theEvent];
}

-(void)mouseUp:(NSEvent *)theEvent 
{
	if(activated)
		[actionView rrEnd];
	activated = NO;
	[super mouseUp:theEvent];
}

-(void)mouseEntered:(NSEvent *)theEvent
{
	[self setImage:[NSImage imageNamed:@"rr_over"]];
}

-(void)mouseExited:(NSEvent *)theEvent
{
	[self setImage:[NSImage imageNamed:@"rr"]];
	[super mouseExited:theEvent];
}

@end
