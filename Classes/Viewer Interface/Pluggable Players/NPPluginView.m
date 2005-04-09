/**
 * NPPluginView.m
 * NicePlayer
 *
 * A superclass for plugins to inherit off of. You'll want to use -Wno-protocol so that you
 * don't get warnings about unimplemented protocol methods that are not implemented in your
 * subclass, but are implemented in this superclass.
 */

#import "NPPluginView.h"
#import "NPMovieProtocol.h"

@implementation NPPluginView

+(BOOL)hasConfigurableNib
{
	return NO;
}

+(id)configureNibView
{
    NSLog(@"Error");
    return nil;
}

/* Forward all drag events to the window itself. */
-(NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
	return [[self window] draggingEntered:sender];
}

-(NSDragOperation)draggingUpdated:(id)sender
{
	return [[self window] draggingUpdated:sender];
}

-(BOOL)prepareForDragOperation:(id)sender
{
	return [[self window] prepareForDragOperation:sender];
}

-(BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
	return [[self window] performDragOperation:sender];
}

-(void)concludeDragOperation:(id <NSDraggingInfo>)sender
{
	[[self window] concludeDragOperation:sender];
}

-(void)ffStart:(int)seconds
{
	if(oldPlayState == STATE_INACTIVE)
		oldPlayState = [(<NPMoviePlayer>)self isPlaying] ? STATE_PLAYING : STATE_STOPPED;
	[(<NPMoviePlayer>)self stop];
}

-(void)ffEnd
{
	if(oldPlayState == STATE_PLAYING)
		[(<NPMoviePlayer>)self start];
	else
		[(<NPMoviePlayer>)self stop];
	oldPlayState = STATE_INACTIVE;
}

-(void)rrStart:(int)seconds
{
	if(oldPlayState == STATE_INACTIVE)
		oldPlayState = [(<NPMoviePlayer>)self isPlaying] ? STATE_PLAYING : STATE_STOPPED;
	[(<NPMoviePlayer>)self stop];
}

-(void)rrEnd
{
	if(oldPlayState == STATE_PLAYING)
		[(<NPMoviePlayer>)self start];
	else
		[(<NPMoviePlayer>)self stop];
	oldPlayState = STATE_INACTIVE;
}

@end
