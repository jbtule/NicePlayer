/**
 * RCMovieView.m
 * NicePlayer
 *
 * An implementation of a QTKit movie view for NicePlayer.
 */


#import "RCMovieView.h"

@implementation RCMovieView

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
    return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"CoreVideo",	extensions,			nil]
                                       forKeys:[NSArray arrayWithObjects:@"Name",		@"FileExtensions",	nil]];	
}

+(BOOL)hasConfigurableNib
{
    return NO;
}

+(id)configureNibView
{
    return nil;
}

-(BOOL)openURL:(NSURL *)url
{
    myURL = url;
    film = [[movieCache objectForKey:url] retain];
    if(film == NULL)
        film = [[QTMovie movieWithURL:url error:nil] retain];
    return (film) ? YES : NO;
}

-(void)precacheURL:(NSURL*)url
{
    movieCache = [NSDictionary dictionaryWithObject: [[[QTMovie alloc] initWithURL:url byReference:YES]autorelease] forKey:url];
}

-(id)initWithFrame:(NSRect)frame
{
    if (floor(NSAppKitVersionNumber) <= NSAppKitVersionNumber10_3) /* QTKit won't load on anything less than 10.4 Tiger. */
	return nil;

    if(self = [super initWithFrame:frame]){
	qtView = [[QTMovieView alloc] initWithFrame:frame];
	[self addSubview:[qtView autorelease]];
        oldPlayState = STATE_INACTIVE;
        [self setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
	[qtView setFillColor:[NSColor blackColor]];
        [qtView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
        [qtView setControllerVisible:NO];
        [qtView setEditable:NO];
	[qtView setPreservesAspectRatio:NO];
    }
    
    return self;
}

-(void)dealloc
{
    [qtView removeFromSuperview];
    [super dealloc];
}

-(void)close
{
}

-(BOOL)loadMovie
{
    [qtView setMovie:[film autorelease]];
    muted = [film muted];
    return YES;
}

-(void)keyDown:(NSEvent *)anEvent
{
}

-(void)keyUp:(NSEvent *)anEvent
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
    [qtView setNeedsDisplay:YES];
}

-(NSSize)naturalSize
{
    Rect aRect;
    GetMovieNaturalBoundsRect([film quickTimeMovie], &aRect);
    return NSMakeSize((float)(aRect.right - aRect.left),
                      (float)(aRect.bottom - aRect.top));
}

-(void)setLoopMode:(NSQTMovieLoopMode)flag
{
    BOOL shouldLoop = !(flag == NSQTMovieNormalPlayback);
    [film setMovieAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
	[NSNumber numberWithBool:shouldLoop],
	QTMovieLoopsAttribute,
	nil]];
}

- (void)drawRect:(NSRect)aRect{
    [qtView drawRect:aRect];
}
#pragma mark Volume

-(BOOL)muted
{
    return [film muted];
}

-(void)setMuted:(BOOL)aBOOL
{
    muted = aBOOL;
    [film setMuted:aBOOL];
}

-(float)volume
{
    return [film volume];
}

-(void)setVolume:(float)aVolume
{
    [film setVolume:aVolume];
}

#pragma mark -
#pragma mark Controls

-(BOOL)isPlaying
{
    return ([film rate] != 0.0);
}

-(void)start
{
    [film play];
}

-(void)stop
{
    [film stop];
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
    Movie tempMovie = [film quickTimeMovie];
    TimeRecord tempRecord;
    TimeValue newTime;
    TimeValue tempTime = GetMovieTime(tempMovie, &tempRecord);
    myTypes[0] =VisualMediaCharacteristic;      // we want video samples
    GetMovieNextInterestingTime(tempMovie, nextTimeStep, 1, myTypes, tempTime, aDirection, &newTime, nil);
    SetMovieTimeValue(tempMovie, newTime);
}

-(BOOL)hasEnded:(id)sender
{
    Movie tempMovie = [film quickTimeMovie];
    
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

-(double)totalTimePrecise
{
    Movie tempMovie = [film quickTimeMovie];
    return GetMovieDuration(tempMovie);
}

-(double)currentMovieFrameRate{
    int sampleSize =5;
    OSType myTypes[1];
    Movie tempMovie = [film quickTimeMovie];
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

-(long)currentMovieTimeScale
{
    Movie tempMovie = [film quickTimeMovie];
    return GetMovieTimeScale(tempMovie);
}

-(long)currentMovieTimePrecise
{
    Movie tempMovie = [film quickTimeMovie];
    return  GetMovieTime(tempMovie, NULL);
}

-(void)setCurrentMovieTimePrecise:(long)newMovieTime
{
    Movie tempMovie = [film quickTimeMovie];
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
    return @"CoreVideo";
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

@end