/**
 * NiceWindow.m
 * NicePlayer
 *
 * The window subclass for NicePlayer player windows.
 */

#import "NiceWindow.h"
#import "FadeOut.h"
#import "OverlayControllerWindow.h"

@implementation NiceWindow

- (id)initWithContentRect:(NSRect)contentRect
				styleMask:(unsigned int)aStyle
				  backing:(NSBackingStoreType)bufferingType
					defer:(BOOL)flag
{
    if(self = [super initWithContentRect:contentRect
							   styleMask:NSBorderlessWindowMask
								 backing:NSBackingStoreBuffered
								   defer:YES]){
		[[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(presentMultiple)
                                                     name:@"PresentMultiple"
                                                   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(unPresentMultiple)
													 name:@"unPresentMultiple"
												   object:nil];
        
		timeUpdaterTimer = [NSTimer scheduledTimerWithTimeInterval:1
															 target:self
														   selector:@selector(updateByTime:)
														   userInfo:nil
															repeats:YES];
		[self setBackgroundColor:[NSColor blackColor]];
		[self setOpaque:YES];
		[self useOptimizedDrawing:YES];
		[self setHasShadow:YES];
		
		dropScreen = NO;
		presentScreen = NO;
        isFilling = NO;
        isWidthFilling = NO;
        miniVolume = 1;
		windowOverlayIsShowing = NO;
		titleOverlayIsShowing = NO;
		initialFadeTimer = nil;
		isInitialDisplay = [[Preferences mainPrefs] showInitialOverlays];
		timeDisplayStyle = [[Preferences mainPrefs] defaultTimeDisplay];
	}
    return self;
}

-(void)awakeFromNib
{
	[theScrubBar setTarget:theMovieView];
	[self setContentView:theMovieView];
	[theScrubBar setAction:@selector(scrub:)];
	[self setReleasedWhenClosed:YES];
	[self registerForDraggedTypes:[self acceptableDragTypes]];
	
	if([[Preferences mainPrefs] windowAlwaysOnTop])
		[self floatWindow];
	[self makeFirstResponder:self]; 
	[self setAcceptsMouseMovedEvents:YES];
	oldWindowLevel =[self level];

    [thePlayButton setKeyEquivalent:@" "];
    [theRRButton setKeyEquivalent:[NSString stringWithFormat:@"%C",NSLeftArrowFunctionKey,nil]];
    [theFFButton setKeyEquivalent:[NSString stringWithFormat:@"%C",NSRightArrowFunctionKey,nil]];
	
	[thePlayButton setActionView:theMovieView];
	[theRRButton setActionView:theMovieView];
	[theFFButton setActionView:theMovieView];
}

-(void)close
{
	[timeUpdaterTimer invalidate];
	[theMovieView close];
	if(initialFadeTimer)
		[initialFadeTimer invalidate];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super close];
}
-(void)dealloc
{
	[initialFadeObjects release];
	[super dealloc];
}

#pragma mark Overriden Methods

-(void)resignMainWindow
{
    [self hideOverLayWindow];
    [self hideOverLayTitle];
    [super resignMainWindow];
}

-(void)setFrame:(NSRect)frameRect display:(BOOL)displayFlag
{
    [super setFrame:frameRect display:displayFlag];
	[self setOverlayWindowLocation];
	[self setOverlayTitleLocation];
	[self setOverLayVolumeLocation];
}

- (BOOL)canBecomeMainWindow
{
    return YES;
}

- (BOOL)canBecomeKeyWindow
{
    return YES;
}

#pragma mark Interface Items

- (BOOL)validateMenuItem:(NSMenuItem*)anItem
{
        switch([anItem tag]){
        case 7:
            return YES;
            break;
        default:
            return [super validateMenuItem:anItem];        
    }
    
}

-(IBAction)performClose:(id)sender
{
    [(NPMovieView *)theMovieView stop];
    if(fullScreen)
        [[NSDocumentController sharedDocumentController] toggleFullScreen:sender];
    [self close];
}

-(void)updateVolume
{
    [theVolumeView setMuted:[theMovieView muted]];
    [theVolumeView setVolume:[theMovieView volume]];
    miniVolume =[theMovieView volume];
}


-(void)restoreVolume
{
   // NSLog(@"%f",miniVolume);
   [theMovieView setVolume:miniVolume];
}

- (void)performMiniaturize:(id)sender
{
    if(!fullScreen && !presentScreen){
     //   miniVolume =[theMovieView volume];
        //NSLog(@"%f",miniVolume);
        [(NPMovieView *)theMovieView stop];
        [self miniaturize:sender];
    }
}

/**
 * The mouse is in a location to adjust the resize.
 */
-(BOOL)inResizeLocation:(NSEvent *)anEvent
{
    return ([anEvent locationInWindow].x > ([self frame].size.width-16) && [anEvent locationInWindow].y < (16));
}

/**
 * Change the time style that is shown, either time elapsed or time remaining.
 */
-(void)rotateTimeDisplayStyle
{
	timeDisplayStyle = (timeDisplayStyle + 1) % [Preferences defaultTimeDisplayValuesNum];
	[self updateByTime:self];
}

/**
 * Takes care of updating the time display window, as well as choosing the format for the time display.
 * Current the format can only be of two different choices: time elapsed or time remaining.
 */
-(IBAction)updateByTime:(id)sender
{
	Subtitle* tSubTitle =[[[self windowController] document] subTitle];
    if(tSubTitle !=nil){
        [theOverlaySubTitle setStringValue:[tSubTitle stringForTime:(float)[theMovieView currentMovieTime]]];
    }
    
    if([theMovieView hasEnded:self] && ![theScrubBar inUse]){
        [[[self windowController] document] movieHasEnded];
    }
	
	if((sender != self) && [theScrubBar isHidden])
		return;
	
    switch(timeDisplayStyle){
		NSDate *aDate;
		case ELAPSED_TIME:
			aDate = [NSDate dateWithTimeIntervalSinceReferenceDate:
				([theMovieView currentMovieTime]
				 - [[NSTimeZone localTimeZone] secondsFromGMTForDate:
					 [NSDate dateWithTimeIntervalSinceReferenceDate:0]])];
			[theTimeField setStringValue:[aDate descriptionWithCalendarFormat:@"%H:%M:%S" timeZone:nil locale:nil]];
			break;
		case TIME_REMAINING:
			aDate = [NSDate dateWithTimeIntervalSinceReferenceDate:
				([theMovieView totalTime]
				 - [theMovieView currentMovieTime]
				 - [[NSTimeZone localTimeZone] secondsFromGMTForDate:
					 [NSDate dateWithTimeIntervalSinceReferenceDate:0]])];
			[theTimeField setStringValue:[aDate descriptionWithCalendarFormat:@"-%H:%M:%S" timeZone:nil locale:nil]];
			break;
	}
	/* Update rest of UI */
    [theScrubBar setDoubleValue:[theMovieView scrubLocation:sender]];
    [theScrubBar setNeedsDisplay:YES];
}

#pragma mark -
#pragma mark Overlays

/**
 * Setup the locations of all of the overlays given the initial setup of the window. There are three
 * primary overlay windows: the controller bar, the title bar and the volume window.
 */
-(void)setupOverlays
{
	NSRect currentFrame = [self frame];
	[self putOverlay:theOverlayWindow
			 inFrame:NSMakeRect(currentFrame.origin.x,
								currentFrame.origin.y,
								currentFrame.size.width,
								32)
	  withVisibility:YES];
	[theOverlayWindow createResizeTriangle];
	[self putOverlay:theOverlayTitleBar
			 inFrame:NSMakeRect(currentFrame.origin.x,
								currentFrame.origin.y + currentFrame.size.height-24,
								currentFrame.size.width,
								24)
	  withVisibility:YES];
	[self putOverlay:theOverlayVolume
			 inFrame:NSOffsetRect([theOverlayVolume frame],
								  NSMidX(currentFrame) - NSMidX([theOverlayVolume frame]),
								  NSMidY(currentFrame) - NSMidY([theOverlayVolume frame]))
	  withVisibility:NO];

	initialFadeObjects = [[NSMutableSet setWithObjects:theOverlayWindow, theOverlayTitleBar, nil] retain];
	NSDictionary *fadeDict = [NSDictionary dictionaryWithObjects:
		[NSArray arrayWithObjects:self,	initialFadeObjects,	nil]
														 forKeys:
		[NSArray arrayWithObjects:@"Window", @"Fade", nil]];
	initialFadeTimer = [[FadeOut fadeOut] initialFadeForDict:fadeDict];
}

-(void)putOverlay:(id)anOverlay inFrame:(NSRect)aFrame withVisibility:(BOOL)isVisible
{
	[anOverlay setFrame:aFrame display:NO];
    [self addChildWindow:anOverlay ordered:NSWindowAbove];
    
    [anOverlay setAlphaValue:(isVisible ? 1.0 : 0.0)];
    [anOverlay setLevel:[self level]];
    [anOverlay orderFront:self];	
}

-(void)hideOverlays
{
	[self hideOverLayWindow];
	[self hideOverLayTitle];
}

-(void)hideInitialWindows
{
	[[FadeOut fadeOut] addWindow:theOverlayWindow];
	[[FadeOut fadeOut] addWindow:theOverlayTitleBar];
	[[FadeOut fadeOut] addWindow:theOverlayVolume];
	isInitialDisplay = NO;
}

-(void)hideAllImmediately
{
	[[FadeOut fadeOut] removeWindow:theOverlayWindow];
	[[FadeOut fadeOut] removeWindow:theOverlayTitleBar];
	[[FadeOut fadeOut] removeWindow:theOverlayVolume];
	[theOverlayWindow setAlphaValue:0.0];
	[theOverlayTitleBar setAlphaValue:0.0];
	[theOverlayVolume setAlphaValue:0.0];
	isInitialDisplay = NO;
}

-(void)initialFadeComplete
{
	isInitialDisplay = NO;
	initialFadeTimer = nil;
}

-(void)showOverLayWindow
{
	if((windowOverlayIsShowing) && !(isInitialDisplay))
		return;

	if(isInitialDisplay)
		[initialFadeObjects removeObject:theOverlayWindow];
	
	[self setOverlayWindowLocation];
    [self updateByTime:self];
	[[FadeOut fadeOut] removeWindow:theOverlayWindow];
    [theOverlayWindow setAlphaValue:1.0];
    [self setShowsResizeIndicator:YES];
	windowOverlayIsShowing = YES;
}

/**
 * All of this logic is to set the location of the controller/scrubber bar that appears upon mouseover -- its
 * location is dependant on the screen position of the window, the mode of the window, and the location
 * of the window.
 */
-(void)setOverlayWindowLocation
{
	NSRect frame = [self frame];
	NSRect mainFrame = [[NSScreen mainScreen] frame];
	if(!fullScreen){
        if([[NSScreen mainScreen] visibleFrame].origin.y < frame.origin.y){
            [theOverlayWindow setFrame:NSMakeRect(frame.origin.x,
												  frame.origin.y,
												  frame.size.width,
												  32) display:YES];
		}	else{
			[theOverlayWindow setFrame:NSMakeRect(frame.origin.x,
												  [[NSScreen mainScreen] visibleFrame].origin.y,
												  frame.size.width,
													  32) display:YES];
		}
	} else
        [theOverlayWindow setFrame:NSMakeRect(mainFrame.origin.x,
											  mainFrame.origin.y,
											  mainFrame.size.width,
											  32) display:YES];
}

-(void)hideOverLayWindow
{
	if(windowOverlayIsShowing == NO)
		return;
	if(isInitialDisplay)
		[self hideInitialWindows];
	else
		[[FadeOut fadeOut] addWindow:theOverlayWindow];
	[self setShowsResizeIndicator:NO];
	windowOverlayIsShowing = NO;

}
-(void)showOverLayTitle
{
	if((titleOverlayIsShowing) && !(isInitialDisplay))
		return;

	if(isInitialDisplay)
		[initialFadeObjects removeObject:theOverlayTitleBar];
	
	[self setOverlayTitleLocation];
	[[FadeOut fadeOut] removeWindow:theOverlayTitleBar];
    [theOverlayTitleBar setAlphaValue:1.0];
	titleOverlayIsShowing = YES;
}

/**
 * All of this logic is to set the location of the title bar that appears upon mouseover -- its location is
 * dependant on the screen position of the window, the mode of the window, and the location of the window.
 */
-(void)setOverlayTitleLocation
{
	NSRect frame = [self frame];
	NSRect visibleFrame = [[NSScreen mainScreen] visibleFrame];
	if(!fullScreen){
        if((visibleFrame.origin.y + visibleFrame.size.height)
		   > frame.origin.y + frame.size.height)
            [theOverlayTitleBar setFrame:NSMakeRect(frame.origin.x,
													frame.origin.y + frame.size.height - 24,
													frame.size.width,
													24) display:YES];
        else
            [theOverlayTitleBar setFrame:NSMakeRect(frame.origin.x,
													visibleFrame.origin.y
													+ visibleFrame.size.height - 24,
													frame.size.width,
													24) display:YES];
    } else
        [theOverlayTitleBar setFrame:NSMakeRect(visibleFrame.origin.x,
												visibleFrame.origin.y
												+ visibleFrame.size.height - 48,
												visibleFrame.size.width,
												24) display:YES];
}

-(void)hideOverLayTitle
{
	if(titleOverlayIsShowing == NO)
		return;
	
	if(isInitialDisplay)
		[self hideInitialWindows];
	else
		[[FadeOut fadeOut] addWindow:theOverlayTitleBar];
	titleOverlayIsShowing = NO;
}

-(void)showOverLayVolume
{
	[[FadeOut fadeOut] removeWindow:theOverlayVolume];
    [theOverlayVolume setAlphaValue:1.0];
}

-(void)setOverLayVolumeLocation
{
	[theOverlayVolume setFrame:NSOffsetRect([theOverlayVolume frame],
											NSMidX([self frame]) - NSMidX([theOverlayVolume frame]),
											NSMidY([self frame]) - NSMidY([theOverlayVolume frame]))		display:YES];
}

-(void)hideOverLayVolume
{
	if(isInitialDisplay)
		[self hideInitialWindows];
	else
		[[FadeOut fadeOut] addWindow:theOverlayVolume];
}

#pragma mark -
#pragma mark Window Toggles

-(BOOL)toggleWindowFullScreen
{
	[[NiceController controller] toggleFullScreen:self];
	return fullScreen;
}

-(void)unFullScreen
{
	[[NiceController controller] exitFullScreen];
}

-(BOOL)windowIsFloating
{
	return windowIsFloating;
}

-(void)toggleWindowFloat
{
	if(windowIsFloating)
		[self unfloatWindow];
	else
		[self floatWindow];
	[[NiceController controller] changedWindow:nil];
}

#pragma mark Window Attributes

/**
 * The window can either be normal or full screen. Normal implies a normally sized window on the desktop,
 * and full screen implies a full screen presentation of a movie.
 */
-(void)makeFullScreen
{
    fullScreen = YES;
    oldWindowLevel = [self level];
    [self setLevel:NSFloatingWindowLevel +2];
    [[[self windowController] document] closePlaylistDrawer:self];
    [self makeKeyAndOrderFront:self];
    beforeFullScreen = [self frame];
    [self fillScreenSize:self];
	[theMovieView drawMovieFrame];
	if([[Preferences mainPrefs] autoplayOnFullScreen]){
		[theMovieView start];
	};
	[self hideAllImmediately];
}

-(void)makeNormalScreen
{
    [self setLevel:oldWindowLevel];
	if(fullScreen){
		[self resetFillingFlags];
		[self setFrame:beforeFullScreen display:NO];
		fullScreen = NO;
		[self resizeToAspectRatio];
	}
	[theMovieView drawMovieFrame];
    [theOverlayTitleBar orderFront:self];
    [theOverlayVolume orderFront:self];
    [theOverlayWindow orderFront:self];
	[self hideOverLayWindow];
	if([[Preferences mainPrefs] autostopOnNormalScreen]){
		[(NPMovieView *)theMovieView stop];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"StopAllMovies" object:nil];
	}
}

-(void)presentMultiple
{
    presentScreen = YES;
         oldWindowLevel = [self level];
	[self setLevel:NSFloatingWindowLevel + 2];
}

-(void)unPresentMultiple
{
    presentScreen = NO;
    [self setLevel:oldWindowLevel];
}

/**
 * The next two methods set whether the window floats above the others. Behavior changes depending on
 * whether floating is occuring.
 */

-(void)floatWindow
{
    [self setLevel:NSFloatingWindowLevel];
	windowIsFloating = 1;
}

-(void)unfloatWindow
{
    [self setLevel:NSNormalWindowLevel];
	windowIsFloating = 0;
}

-(BOOL)isFullScreen
{
	return fullScreen;
}

/**
 * Sets the window level by setting all of the windows and child windows to their own proper window levels.
 */
-(void)setLevel:(int)windowLevel
{
    id enumerator = [[self childWindows] objectEnumerator];
    id object;
    
    while(object = [enumerator nextObject]){
        [object setLevel:windowLevel];   
    }
    
    [super setLevel:windowLevel];
}

/**
 * Resize the window to the given resolution. Resizes the window depending on the window pinning preferences.
 * Setting animate to YES will cause the window to perform an animated resizing effect.
 */
-(void)resizeWithSize:(NSSize)aSize animate:(BOOL)animate
{
    float newHeight = aSize.height;
    float newWidth = aSize.width;
	
    if(newHeight <= [self minSize].height) {
        newHeight = [self frame].size.height;
        newWidth = [self frame].size.width;
    }

	switch([[Preferences mainPrefs] scrollResizePin]){
		case PIN_LEFT_TOP:
			[self setFrame:NSMakeRect([self frame].origin.x,
									  [self frame].origin.y + ([self frame].size.height - newHeight),
									  newWidth, newHeight) display:YES animate:animate];
			break;
		case PIN_CENTER:
			[self setFrame:NSMakeRect([self frame].origin.x+(([self frame].size.width-newWidth)/2),
									  [self frame].origin.y+(([self frame].size.height-newHeight)/2),
									  newWidth, newHeight) display:YES animate:animate];
			break;
	}
}

/**
 * Resize the window by a floating point percentage value, with 1.0 being no change.
 * Setting animate to YES will cause the window to animate while resizing.
 */
-(void)resize:(float)amount animate:(BOOL)animate
{
    float deltaHeight = amount;
	float newHeight = [self frame].size.height + deltaHeight;
    float newWidth = ([self aspectRatio].width/[self aspectRatio].height)*newHeight;
    
    if(newHeight <= [self minSize].height) {
        deltaHeight = 0;
        newHeight =[self frame].size.height;
        newWidth= [self frame].size.width;
    }

	[self resizeWithSize:NSMakeSize(newWidth, newHeight) animate:animate];
}

-(void)_JTRefitFills{
    if(isFilling)
        [self fillScreenSize:nil];
    if(isWidthFilling)
        [self fillWidthSize:nil];
}

- (void)setTitle:(NSString *)aString
{
    [theTitleField setStringValue:aString];
    [super setTitle:aString];
}

-(IBAction)halfSize:(id)sender
{
    [self resizeNormalByScaler:0.5];

}

-(IBAction)normalSize:(id)sender
{
    [self resizeNormalByScaler:1.0];

}

-(IBAction)doubleSize:(id)sender
{
    [self resizeNormalByScaler:2.0];
}

-(void)resizeNormalByScaler:(float)aScaler{
	[self resetFillingFlags];
    [self resizeWithSize: NSMakeSize(aScaler*[self aspectRatio].width,aScaler*[self aspectRatio].height) animate:NO];
    if (fullScreen)
        [self center];   
}

-(void)resetFillingFlags
{
    isFilling = NO;
    isWidthFilling = NO;
}

-(IBAction)fillScreenSize:(id)sender
{
	[self resetFillingFlags];
    isFilling=YES;
            
	NSSize aSize = [self getResizeAspectRatioSize];
	[self resizeWithSize:aSize animate:NO];
    [self center];
}

-(IBAction)fillWidthSize:(id)sender
{
	[self resetFillingFlags];
    isWidthFilling = YES;
    NSRect tempRect  = [[self screen] frame];
	float tempVertAmount = tempRect.size.width
		*([self aspectRatio].height/[self aspectRatio].width)
		-[self frame].size.height;
	
    [self resize:tempVertAmount animate:NO];
    [self center];
}

/**
 * Sets the internally stored aspect ratio size.
 */
- (void)setAspectRatio:(NSSize)ratio
{   
    [super setAspectRatio:ratio];
    [self setMinSize:NSMakeSize(([self aspectRatio].width/[self aspectRatio].height) *[self minSize].height,[self minSize].height)];
}

/**
 * Get the size given the aspect ratio and current size. This returns a size that has the same height
 * as the current window, but with the width adjusted wrt to the aspect ratio. Or if the window is
 * full screen, it returns a size that has the width stretched out to fit the screen,
 * assuming the current video is also screen filling.
 */

-(NSSize)getResizeAspectRatioSize
{
	NSSize ratio = [self aspectRatio];
	float newWidth = (([self frame].size.height / ratio.height) * ratio.width);
	if(isFilling | isWidthFilling){
		float width = [[self screen] frame].size.width;
		return NSMakeSize(width, (width / ratio.width) * ratio.height);
	}
	return NSMakeSize(newWidth, [self frame].size.height);
}

/**
 * Resize the window so no scaling occurs -- the resolution given by the aspect ratio.
 */
-(void)initialDefaultSize
{
    [self resizeWithSize: NSMakeSize([self aspectRatio].width,[self aspectRatio].height) animate:YES];
    if (fullScreen)
        [self center];	
}

/**
 * Resize the window to the size returned by getResizeAspectRatioSize
 */
-(void)resizeToAspectRatio
{
	NSSize aSize = [self getResizeAspectRatioSize];
	[self resizeWithSize:aSize animate:YES];
    [self _JTRefitFills];
}

- (IBAction)center:(id)sender
{
    [self center];
}

/* Center on the CURRENT screen */
- (void)center
{
    [self setFrame:[self centeredLocation]
           display:YES];
}

-(NSRect)centeredLocation
{
	NSRect myRect = [self frame];
    NSRect screenRect;
    if (!fullScreen)
        screenRect = [[self screen] visibleFrame];
    else
        screenRect = [[self screen] frame];
	
     return NSOffsetRect([self frame], NSMidX(screenRect)-NSMidX(myRect),
						 NSMidY(screenRect)-NSMidY(myRect));
}

#pragma mark -
#pragma mark Mouse Events

-(void)mouseDown:(NSEvent *)theEvent
{
	if([self inResizeLocation:theEvent])
			resizeDrag = YES;

	if([theEvent clickCount] == 2)
		[self toggleWindowFloat];
}

-(void)mouseDragged:(NSEvent *)anEvent
{
    if(resizeDrag /*|| [self inResizeLocation:anEvent] */){
        
        [self resize:[anEvent deltaY] animate:NO];

    }else{
        if(fullScreen && !NSEqualRects([[[NSDocumentController sharedDocumentController] backgroundWindow] frame],[[NSScreen mainScreen]frame])){
            [[[NSDocumentController sharedDocumentController] backgroundWindow] setFrame:[[NSScreen mainScreen]frame] 
																				 display:YES];
            if([[NSScreen mainScreen] isEqualTo:[[NSScreen screens] objectAtIndex:0]])
				SetSystemUIMode(kUIModeAllHidden, kUIOptionAutoShowMenuBar);
            dropScreen = YES;
        }
        [self showOverLayTitle];
       [self setFrameOrigin:NSMakePoint([self frame].origin.x+[anEvent deltaX],[self frame].origin.y-[anEvent deltaY]) ];
    }
}

/* Used to detect what controls the mouse is currently over. */
- (void)mouseMoved:(NSEvent *)anEvent
{
	[[OverlaysControl control] mouseMovedInScreenPoint:[self convertBaseToScreen:[anEvent locationInWindow]]];
}

-(void)mouseUp:(NSEvent *)anEvent
{
    resizeDrag = NO;
    if(dropScreen){			// If the screen has been dropped onto a different display
        [self center];
        [self _JTRefitFills];
    }
    dropScreen = NO;
    
    [self hideOverLayTitle];
	
}

/* These two events always get passed down to the view. */

-(void)rightMouseUp:(NSEvent *)anEvent
{
	[theMovieView rightMouseUp:anEvent];
}

-(void)mouseDoubleClick:(NSEvent *)anEvent
{
	[theMovieView mouseDoubleClick:anEvent];
}

#pragma mark -
#pragma mark Accessor Methods

/* These accessor methods are used to set button attributes by NPMovieView */

-(id)playButton
{
    return thePlayButton;
}
-(id)rrButton
{
    return theRRButton;
}
-(id)ffButton
{
    return theFFButton;
}

-(id)movieView
{
	return theMovieView;
}

#pragma mark -
#pragma mark Drag and Drop

// Lots of info gleaned from http://www.stone.com/The_Cocoa_Files/Ins_and_Outs_of_Drag_and_D.html

-(unsigned int)draggingEntered:(id)sender
{
	unsigned int sourceMask = [sender draggingSourceOperationMask];
	NSPasteboard *pboard = [sender draggingPasteboard];
	NSString *type = [pboard availableTypeFromArray:[self acceptableDragTypes]];
	if (type) return sourceMask;
	return NSDragOperationNone;
}

-(unsigned int)draggingUpdated:(id)sender
{
	return [sender draggingSourceOperationMask];
}

-(BOOL)prepareForDragOperation:(id)sender
{
	return YES;
}

-(BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
	NSPasteboard *pboard = [sender draggingPasteboard];
	NSString *type = [pboard availableTypeFromArray:[self acceptableDragTypes]];
	if (type) {
		if ([type isEqualToString:NSFilenamesPboardType]) {
			unsigned i;
			NSString *filename;
			NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
			for(i = 0; i < [files count]; i++){
				filename = [files objectAtIndex:i];
				[[[self windowController] document] addURLToPlaylist:[NSURL fileURLWithPath:filename]];
			}
			[[[self windowController] document] openPlaylistDrawerConditional:self];
		}	
	}
	return YES;
}

-(NSArray *)acceptableDragTypes
{
	return [NSArray arrayWithObjects:NSFilenamesPboardType,nil];
}

@end
