/**
 * JTMovieView.m
 * NicePlayer
 *
 * An implementation of a Quicktime view for NicePlayer.
 */

#import "JTMovieView.h"

#define FLOAT_TO_FIXED(f) ((short) ((f) * 65536.0))

@implementation JTMovieView

+(id)blankImage
{
	return [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"black" ofType:@"png"]];
}

+(NSDictionary *)plugInfo
{
	NSArray *extensions = [NSArray arrayWithObjects:
/* File extensions */
		@"avi", @"mov", @"qt", @"mpg", @"mpeg", @"m15", @"m75", @"m2v", @"3gpp", @"mpg4", @"mp4", @"png",
		@"gif", @"bmp", @"tif", @"pic", @"pct", @"pict", @"jpg", @"jpeg", @"qtif", @"swf", @"fli",
		@"flc", @"dv", 
/* Finder types */
		@"VfW", @"MooV", @"MPEG", @"m2v ", @"mpg4", @"PNG ", @"GIF ", @"GiFf", @"BMP ", @"TIFF", @"PICT",
		@"JPEG", @"qtif", @"SWFL", @"FLI ", @"dvc!",
		nil];
	return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Quicktime",	extensions,			nil]
									   forKeys:[NSArray arrayWithObjects:@"Name",		@"FileExtensions",	nil]];	
}

+(BOOL)hasConfigurableNib
{
	return NO;
}

+(id)configureNib
{
	return nil;
}

-(BOOL)openURL:(NSURL *)url
{
	myURL = url;
	film = [[movieCache objectForKey:url] retain];
	if(film == NULL)
		film = [[NSMovie alloc] initWithURL:url byReference:YES];
	return (film) ? YES : NO;
}

-(void)precacheURL:(NSURL*)url{
    movieCache = [NSDictionary dictionaryWithObject: [[[NSMovie alloc] initWithURL:url byReference:YES]autorelease] forKey:url];
}

-(id)initWithFrame:(NSRect)frame
{
	if(self = [super initWithFrame:frame]){
                theFirstDraw =NO;
		oldPlayState = STATE_INACTIVE;
		[self setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
		[self showController:NO adjustingSize:NO];
		[self setEditable:NO];
		muted = [super isMuted];
		if(![self movie]){
			id blank = [[NSBundle mainBundle] pathForResource:@"black" ofType:@"png"];
			if(!blank)
				return nil;
			id blankURL = [NSURL fileURLWithPath:blank];
			if(!blankURL)
				return nil;
			id movie = [[NSMovie alloc] initWithURL:blankURL byReference:YES];
			if(!movie)
				return nil;
			[self setMovie:[movie autorelease]];
		}
	}
	
	return self;
}

-(void)close
{
	[film release];
}

-(void)loadMovie
{
	[self setMovie:film];
}

-(void)keyDown:(NSEvent *)anEvent
{
}

-(void)mouseDown:(NSEvent *)anEvent
{
}

-(void)mouseMoved:(NSEvent *)anEvent
{
}

-(void)drawMovieFrame
{
	[self setNeedsDisplay:YES];
}

-(NSSize)naturalSize
{
	Rect aRect;
	GetMovieNaturalBoundsRect([[self movie] QTMovie], &aRect);
	return NSMakeSize((float)(aRect.right - aRect.left),
					  (float)(aRect.bottom - aRect.top));
}

-(void)setLoopMode:(NSQTMovieLoopMode)flag
{
	[super setLoopMode:flag];
}

- (void)drawRect:(NSRect)aRect{
    if(!theFirstDraw){
    [[NSGraphicsContext currentContext] saveGraphicsState];
    [[NSColor blackColor] set];
        NSRectFill(aRect);
    [[NSGraphicsContext currentContext] restoreGraphicsState];
    theFirstDraw=YES;
    }
    [super drawRect:aRect];
}
#pragma mark Volume

-(BOOL)muted
{
	return muted;
}

-(void)setMuted:(BOOL)aBOOL
{
	muted = aBOOL;
    [super setMuted:aBOOL];
}

-(float)volume
{
	float volume = [super volume];
	if(volume < 0)
		volume *= -1;
	
	return volume;
}

-(void)setVolume:(float)aVolume
{
    [super setVolume:aVolume];
}

#pragma mark -
#pragma mark Controls

-(BOOL)isPlaying
{
	return [super isPlaying];
}

-(void)start
{
	[super start:self];
	theFirstDraw = YES;
	[self setNeedsDisplay:YES];
}

-(void)stop
{
    [super stop:self];
}

-(void)ffStart:(int)seconds
{
	if(oldPlayState == STATE_INACTIVE)
		oldPlayState = [self isPlaying] ? STATE_PLAYING : STATE_STOPPED;
	[self stop];
	[self ffDo:seconds];
}

-(void)ffDo:(int)seconds
{
    [self incrementMovieTime:seconds inDirection:DIRECTION_FORWARD];
	[self drawMovieFrame];
}

-(void)ffEnd
{
	if(oldPlayState == STATE_PLAYING)
		[self start];
	oldPlayState = STATE_INACTIVE;
}

-(void)rrStart:(int)seconds
{
	if(oldPlayState == STATE_INACTIVE)
		oldPlayState = [self isPlaying] ? STATE_PLAYING : STATE_STOPPED;
	[self stop];
	[self rrDo:seconds];
}

-(void)rrDo:(int)seconds
{
    [self incrementMovieTime:seconds inDirection:DIRECTION_BACKWARD];
	[self drawMovieFrame];
}

-(void)rrEnd
{
	if(oldPlayState == STATE_PLAYING)
		[self start];
	oldPlayState = STATE_INACTIVE;
}

/* For QuickTime, a positive value is forward, a negative value is backward. */
-(void)stepBackward
{
	[self stepFrameInDirection:-1];
}

-(void)stepForward
{
	[self stepFrameInDirection:1];
}

-(void)stepFrameInDirection:(int)aDirection
{
	OSType myTypes[1];
	Movie tempMovie = [[self movie] QTMovie];
    TimeRecord tempRecord;
	TimeValue newTime;
    TimeValue tempTime = GetMovieTime(tempMovie, &tempRecord);
    myTypes[0] =VisualMediaCharacteristic;      // we want video samples
    GetMovieNextInterestingTime(tempMovie, nextTimeStep, 1, myTypes, tempTime, aDirection, &newTime, nil);
	SetMovieTimeValue(tempMovie, newTime);
}

-(BOOL)hasEnded:(id)sender
{
    Movie tempMovie = [[self movie] QTMovie];
	
    return IsMovieDone(tempMovie);
}

#pragma mark -
#pragma mark Calculations

-(double)totalTime
{
	return (double)[self totalTimePrecise] / [self currentMovieTimeScale];
}

-(double)currentMovieTime
{
	
    return (double)[self currentMovieTimePrecise] / [self currentMovieTimeScale];
}

-(void)setCurrentMovieTime:(double)newMovieTime
{
    [self setCurrentMovieTimePrecise:newMovieTime * [self currentMovieTimeScale]];
}

-(double)totalTimePrecise{
    Movie tempMovie = [[self movie] QTMovie];
    return GetMovieDuration(tempMovie);
}

-(double)currentMovieFrameRate{
    int sampleSize =5;
    OSType myTypes[1];
    Movie tempMovie = [[self movie] QTMovie];
    TimeValue newTime;
    TimeValue tempTime = 0;
    myTypes[0] =VisualMediaCharacteristic;      // we want video samples
    int myCount =0;
    while(tempTime<=(sampleSize *[self currentMovieTimeScale]) && myCount <= (sampleSize*[self currentMovieTimeScale]) ){
        
        GetMovieNextInterestingTime(tempMovie, nextTimeStep, 1, myTypes, tempTime, fixed1, &newTime, NULL);
        if(tempTime== newTime)
            break;
        tempTime =newTime;
        myCount++;
    }
    
    
    return (double)myCount /((double)newTime/[self currentMovieTimeScale]);
}

-(long)currentMovieTimeScale{
    Movie tempMovie = [[self movie] QTMovie];
    return GetMovieTimeScale(tempMovie);
}

-(long)currentMovieTimePrecise{
    Movie tempMovie = [[self movie] QTMovie];
    return  GetMovieTime(tempMovie, NULL);
}

-(void)setCurrentMovieTimePrecise:(long)newMovieTime{
    Movie tempMovie = [[self movie] QTMovie];
    SetMovieTimeValue(tempMovie, newMovieTime);
}

-(void)incrementMovieTime:(long)timeDifference inDirection:(enum direction)aDirection;
{
	[self setCurrentMovieTime:([self currentMovieTime] + (aDirection * timeDifference))];
}

#pragma mark -
#pragma mark Menus

-(id)menuPrefix
{
	return @"QT";
}

-(id)menuTitle
{
	NSString *file = [[[myURL absoluteString] lastPathComponent] stringByDeletingPathExtension];
	file = (NSString *)CFURLCreateStringByReplacingPercentEscapes(NULL, (CFStringRef)file, (CFStringRef)@"");
	return [file autorelease];
}

-(id)pluginMenu
{
	id pluginMenu = [[NSMutableArray array] retain];
	id newItem;
	
	newItem = [[[NSMenuItem alloc] initWithTitle:@"Play Movie Preview"
										  action:@selector(playMoviePreview)
								   keyEquivalent:@""] autorelease];
	[newItem setTarget:self];
	[pluginMenu addObject:newItem];

	newItem = [[[NSMenuItem alloc] initWithTitle:@"Go to Movie Poster Frame"
										  action:@selector(gotoMoviePosterFrame)
								   keyEquivalent:@""] autorelease];
	[newItem setTarget:self];
	[pluginMenu addObject:newItem];
	
	return [pluginMenu autorelease];
}

-(void)playMoviePreview
{
}

-(void)gotoMoviePosterFrame
{
}

#pragma mark -
#pragma mark NPPluginView
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

@end
