/**
 * ControlFF.m
 * NicePlayer
 *
 * The fast forward button implementation.
 */

#import "ControlFF.h"
#import "../../Viewer Interface/NPMovieView.h"

@implementation ControlFF

-(void)mouseStart
{
	[actionView ffStart];
	activated = YES;
}

-(void)mousePressed:(NSEvent *)theEvent
{
	if(![self isInFinalState])
		[actionView ffDo];
	[super mousePressed:theEvent];
}

-(void)mouseUp:(NSEvent *)theEvent 
{
	if(activated)
		[actionView ffEnd];
	activated = NO;
	[super mouseUp:theEvent];
}

-(void)mouseEntered:(NSEvent *)theEvent
{
	[self setImage:[NSImage imageNamed:@"ff_over"]];
}

-(void)mouseExited:(NSEvent *)theEvent
{
	[self setImage:[NSImage imageNamed:@"ff"]];
	[super mouseExited:theEvent];
}

@end
