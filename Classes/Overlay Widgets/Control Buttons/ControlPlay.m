/**
 * ControlPlay.m
 * NicePlayer
 *
 * The play button implementation.
 */

#import "ControlPlay.h"

@implementation ControlPlay

-(id)initWithFrame:(NSRect)rect
{
    if (self = [super initWithFrame:rect]) {
		[self changeToProperButton:NO];
	}
    return self;
}

-(void)mouseDown:(NSEvent *)theEvent 
{ 
	[super mouseDown:theEvent];
	[self togglePlaying];
}

-(void)togglePlaying
{
	if([actionView isPlaying])
		[(NPMovieView *)actionView stop];
	else
		[actionView start];
}

-(void)changeToProperButton:(BOOL)isPlaying
{
	iAmPlaying = isPlaying;
	if(isPlaying){
		[self changeToPauseButton];
	} else {
		[self changeToPlayButton];
	}
}

-(void)changeToPauseButton
{
    [self setImage:[NSImage imageNamed:@"pause"]];
    [self setAlternateImage:[NSImage imageNamed:@"pauseClick"]];
}

-(void)changeToPlayButton
{
	[self setImage:[NSImage imageNamed:@"play"]];
	[self setAlternateImage:[NSImage imageNamed:@"playClick"]];
}

-(void)mouseEntered:(NSEvent *)theEvent
{
	if(iAmPlaying)
		[self setImage:[NSImage imageNamed:@"pause_over"]];
	else
		[self setImage:[NSImage imageNamed:@"play_over"]];
}

-(void)mouseExited:(NSEvent *)theEvent
{
	if(iAmPlaying)
		[self setImage:[NSImage imageNamed:@"pause"]];
	else
		[self setImage:[NSImage imageNamed:@"play"]];
	[super mouseExited:theEvent];
}

@end
