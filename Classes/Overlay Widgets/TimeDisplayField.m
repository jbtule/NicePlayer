/**
 * TimeDisplayField.m
 * NicePlayer
 *
 * The NSTextField subclass that displays the current time in the movie. It also
 * controls whether the time displayed is the elapsed time or the time remaining
 * by rotating through time styles stored in NiceWindow.
 */

#import "TimeDisplayField.h"

@implementation TimeDisplayField

- (void)mouseDown:(NSEvent *)theEvent
{
	if([theEvent type] == NSLeftMouseDown){
		[(NiceWindow *)[[self window] parentWindow] rotateTimeDisplayStyle];
	} else {
		[[self window] mouseDown:theEvent];
	}
}

@end
