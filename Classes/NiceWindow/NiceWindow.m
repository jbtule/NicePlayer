/**
* NiceWindow.m
 * NicePlayer
 *
 * The window subclass for NicePlayer player windows.
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

#import "NiceWindow.h"
#import "FadeOut.h"
#import "OverlayControllerWindow.h"
#import "OverlayNotifierWindow.h"
#import "NPApplication.h"
#import "DelegateAnimation.h"

@implementation NiceWindow

- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(unsigned int)aStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)flag
{
    if((self = [super initWithContentRect:contentRect
                               styleMask:NSBorderlessWindowMask
                                 backing:NSBackingStoreBuffered
                                   defer:YES])){
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
        theWindowIsFloating = NO;
        dropScreen = NO;
        presentScreen = NO;
        isFilling = NO;
        isWidthFilling = NO;
        miniVolume = 1;
        windowOverlayIsShowing = NO;
        titleOverlayIsShowing = NO;
		fixedAspectRatio = YES;
        initialFadeTimer = nil;
        isInitialDisplay = [[Preferences mainPrefs] showInitialOverlays];
        timeDisplayStyle = [[Preferences mainPrefs] defaultTimeDisplay];
		[[Preferences mainPrefs] addObserver:self
								  forKeyPath:@"opacityWhenWindowIsTransparent" 
					 options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
					 context:NULL];
    }
    return self;
}

-(id)subtitleView{
	return theOverlaySubTitle;
}

-(void)awakeFromNib
{

    [theScrubBar setTarget:theMovieView];
    [self setContentView:theMovieView];
    [theScrubBar setAction:@selector(scrub:)];
    [self setReleasedWhenClosed:YES];
    [self registerForDraggedTypes:[self acceptableDragTypes]];
    
	id tParagraph = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
	[tParagraph setAlignment:NSCenterTextAlignment];
	
	id textShadow =[[[NSShadow alloc]init] autorelease];
	NSSize      shadowSize = NSMakeSize(0.0f, -2.0f); 
	[textShadow setShadowOffset:shadowSize]; 
	[textShadow setShadowBlurRadius:5.0f]; 
	[textShadow setShadowColor:[NSColor blackColor]]; 
	
	[theOverlaySubTitle setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
	[NSColor whiteColor],NSForegroundColorAttributeName,
	textShadow,NSShadowAttributeName,
	tParagraph,NSParagraphStyleAttributeName, nil]];
	
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
	NSAutoreleasePool* tPool = [NSAutoreleasePool new];
	[self hideNotifier];
    [[FadeOut fadeOut] removeWindow:theOverlayWindow];
    [[FadeOut fadeOut] removeWindow:theOverlayTitleBar];
    [[FadeOut fadeOut] removeWindow:theOverlayVolume];
    [[FadeOut fadeOut] removeWindow:self];
    if(initialFadeTimer)
        [initialFadeTimer invalidate];
    [timeUpdaterTimer invalidate];
	

	isClosing = YES;
    [theMovieView close];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[[Preferences mainPrefs] removeObserver:self forKeyPath:@"opacityWhenWindowIsTransparent"];
    [super close];
	
	[tPool release];
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
	[self setOverLaySubtitleLocation];
}

-(BOOL)canBecomeMainWindow
{
    return YES;
}

-(void)becomeKeyWindow
{
    [super becomeKeyWindow];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RebuildAllMenus" object:nil];
}

-(BOOL)canBecomeKeyWindow
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
	[self orderOut:sender];//order out before stops double button click from causing crash
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

-(void)setResizeDrag:(bool)aDrag{
	resizeDrag = aDrag;
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
    
    
    if([theMovieView hasEnded:self]){
        [[[self windowController] document] movieHasEnded];
    }
    
    if((sender != self) && [theScrubBar isHidden])
        return;
    id tAttString;
	
	double tLength =[theMovieView totalTime];
		double tCurr =[theMovieView currentMovieTime];

			if(theMovieView==nil){
				tLength=0;
				tCurr =0;
				}
				
    switch(timeDisplayStyle){
        NSDate *aDate;
        case ELAPSED_TIME:
			
            aDate = [NSDate dateWithTimeIntervalSinceReferenceDate:
                (tCurr
                 - [[NSTimeZone localTimeZone] secondsFromGMTForDate:
                     [NSDate dateWithTimeIntervalSinceReferenceDate:0]])];
					 
			 tAttString = [[[NSAttributedString alloc] initWithString:[aDate descriptionWithCalendarFormat:@"%H:%M:%S" timeZone:nil locale:nil]
												attributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSFont boldSystemFontOfSize:[NSFont systemFontSizeForControlSize:NSSmallControlSize]],NSFontAttributeName,nil]] autorelease];
			[theTimeField setAttributedStringValue:tAttString];
            break;
        case TIME_REMAINING:
            aDate = [NSDate dateWithTimeIntervalSinceReferenceDate:
                (tLength
                 - tCurr
                 - [[NSTimeZone localTimeZone] secondsFromGMTForDate:
                     [NSDate dateWithTimeIntervalSinceReferenceDate:0]])];
					 
					 	 tAttString = [[[NSAttributedString alloc] initWithString:[aDate descriptionWithCalendarFormat:@"-%H:%M:%S" timeZone:nil locale:nil]
												attributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSFont boldSystemFontOfSize:[NSFont systemFontSizeForControlSize:NSSmallControlSize]],NSFontAttributeName,nil]]autorelease];
			[theTimeField setAttributedStringValue:tAttString];
            break;
    }
    /* Update rest of UI */
    [theScrubBar setDoubleValue:[theMovieView scrubLocation:sender]];
    [theScrubBar setNeedsDisplay:YES];
}



-(void)displayAlertString:(NSString *)aString withInformation:(NSString *)anotherString
{
	NSAlert *anAlert = [NSAlert alertWithMessageText:aString
									   defaultButton:@"Okay"
									 alternateButton:nil
										 otherButton:nil
						   informativeTextWithFormat:anotherString];
	[anAlert beginSheetModalForWindow:self modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

#pragma mark -
#pragma mark Overlays

/**
 * Setup the locations of all of the overlays given the initial setup of the window. There are three
 * primary overlay windows: the controller bar, the title bar and the volume window.
 */
-(void)setupOverlays
{
	BOOL initialShow = [[Preferences mainPrefs] showInitialOverlays];
	
    NSRect currentFrame = [self frame];
    [self putOverlay:theOverlayWindow
             inFrame:NSMakeRect(currentFrame.origin.x,
                                currentFrame.origin.y,
                                currentFrame.size.width,
                                [theOverlayWindow frame].size.height)
      withVisibility:initialShow];
	  
	      [self putOverlay:theOverlaySubTitleWindow
             inFrame:NSMakeRect(currentFrame.origin.x,
                                currentFrame.origin.y+32,
                                currentFrame.size.width,
                                currentFrame.size.height - 24 - 32)
      withVisibility:YES];
	  
    [theOverlayWindow createResizeTriangle];
    [self putOverlay:theOverlayTitleBar
             inFrame:NSMakeRect(currentFrame.origin.x,
                                currentFrame.origin.y + currentFrame.size.height-[theOverlayTitleBar frame].size.height,
                                currentFrame.size.width,
                                [theOverlayTitleBar frame].size.height)
      withVisibility:initialShow];
    [self putOverlay:theOverlayVolume
             inFrame:NSOffsetRect([theOverlayVolume frame],
                                  NSMidX(currentFrame) - NSMidX([theOverlayVolume frame]),
                                  NSMidY(currentFrame) - NSMidY([theOverlayVolume frame]))
      withVisibility:NO];
    [self putOverlay:theOverlayNotifier
             inFrame:NSMakeRect(currentFrame.origin.x,
                                currentFrame.origin.y + currentFrame.size.height
				- [theOverlayTitleBar frame].size.height - [theOverlayNotifier frame].size.height,
                                currentFrame.size.width,
                                [theOverlayNotifier frame].size.height)
      withVisibility:NO];
	  
	  
	if([[Preferences mainPrefs] showInitialOverlays]){
		id initialFadeObjects = [NSMutableSet setWithObjects:theOverlayWindow, theOverlayTitleBar, nil];
		NSDictionary *fadeDict = [NSDictionary dictionaryWithObjects:
			[NSArray arrayWithObjects:self,	initialFadeObjects, @"initialFadeComplete",	nil]
															 forKeys:
			[NSArray arrayWithObjects:@"Window", @"Fade", @"Selector", nil]];
		initialFadeTimer = [[FadeOut fadeOut] initialFadeForDict:fadeDict];
    }	
}

-(void)putOverlay:(id)anOverlay inFrame:(NSRect)aFrame withVisibility:(BOOL)isVisible
{
    [anOverlay setFrame:aFrame display:NO];
    
    [anOverlay setAlphaValue:(isVisible ? 1.0 : 0.0)];
    [anOverlay setLevel:[self level]];
	/* For some reason on Tiger, we have to add the child window after we set the alpha and level, otherwise
		the child window is visible in locations as setFrame: is being called, very odd. Didn't bother to file
		it in radar. */
    [self addChildWindow:anOverlay ordered:NSWindowAbove];
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

-(BOOL)scrubberInUse{
    return [theScrubBar inUse];
}

-(void)automaticShowOverLayWindow
{
    if(![[Preferences mainPrefs] disableShowingOverlaysOnKeyPress])
		[self showOverLayWindow];
}

-(void)showOverLayWindow
{
    if((windowOverlayIsShowing) && !(isInitialDisplay))
        return;
    
    [self updateByTime:self];
    [self setOverlayWindowLocation];
    [[FadeOut fadeOut] removeWindow:theOverlayWindow];
    [theOverlayWindow setAlphaValue:1.0];
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
        } else {
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
    
    [self setOverlayTitleLocation];
    [[FadeOut fadeOut] removeWindow:theOverlayTitleBar];
    [theOverlayTitleBar setAlphaValue:1.0];
    titleOverlayIsShowing = YES;
}

-(void)showOverLaySubtitle{
    
    [theOverlaySubTitleWindow setAlphaValue:1.0];

}

-(BOOL)isOverlaySubtitleShowing{
    
   return [theOverlaySubTitleWindow alphaValue] > 0.1;
    
}

-(void)hideOverLaySubtitle{
    [theOverlaySubTitleWindow setAlphaValue:0.0];    
}


-(void)setOverLaySubtitleLocation{

 NSRect frame = [self frame];
    NSRect visibleFrame = [[NSScreen mainScreen] visibleFrame];

    if(!fullScreen){
        /*if((visibleFrame.origin.y + visibleFrame.size.height)
           > frame.origin.y + frame.size.height)*/
            [theOverlaySubTitleWindow setFrame:NSMakeRect(frame.origin.x,
                                                    frame.origin.y+32,
                                                    frame.size.width,
                                                     frame.size.height- 24 - 32) display:YES];
       /* else
                [theOverlaySubTitleWindow setFrame:NSMakeRect(visibleFrame.origin.x,
                                                visibleFrame.origin.y+32,
												visibleFrame.size.width,
                                                visibleFrame.size.height- 24 - 32) display:YES];*/
    } else
        [theOverlaySubTitleWindow setFrame:NSMakeRect(visibleFrame.origin.x,
                                                visibleFrame.origin.y+32,
												visibleFrame.size.width,
                                                visibleFrame.size.height- 24 - 32) display:YES];



  
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

-(void)automaticShowOverLayVolume
{
	if(![[Preferences mainPrefs] disableShowingOverlaysOnKeyPress])
		[self showOverLayVolume];
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
	[self setOverLaySubtitleLocation];
    return fullScreen;
}

-(void)unFullScreen
{
    [[NiceController controller] exitFullScreen];
}

-(BOOL)windowIsFloating
{
    return theWindowIsFloating;
}



-(void)setWindowIsFloating:(BOOL)aBool
{
    if(aBool)
	[self floatWindow];
    else
	[self unfloatWindow];
}

-(void)toggleFixedAspectRatio
{
    [self setFixedAspect: ![self fixedAspect]];
}

-(void)setFixedAspect:(BOOL)aBool{
    if(!aBool){
	[self setResizeIncrements:NSMakeSize(1.0,1.0)];
    } else{
	[self setAspectRatio:aspectRatio];
        [self resizeToAspectRatio];
    }
}

-(BOOL)fixedAspect
{
    return fixedAspectRatio;
}

-(void)togglePartiallyTransparent
{
	partiallyTransparent = !partiallyTransparent;
	
	NSAnimation *animation = [[DelegateAnimation alloc] initWithDuration:0.1 animationCurve:NSAnimationEaseInOut];
	[animation setAnimationBlockingMode:NSAnimationNonblocking];
	[animation setDelegate:self];
	[animation startAnimation];
}

-(void)setCurrentAnimationValue:(float)value
{
	float opacity = [[Preferences mainPrefs] opacityWhenWindowIsTransparent];
	if(partiallyTransparent){
		[self setAlphaValue:(1.0 - value) + opacity * value];
	} else {
		[self setAlphaValue:value + opacity * (1.0 - value)];
	}	
}

- (void)animationDidEnd:(NSAnimation*)animation
{
	[self setCurrentAnimationValue:[animation currentValue]];
	[animation release];
}

-(BOOL)partiallyTransparent
{
	return partiallyTransparent;
}

-(void)toggleWindowFloat
{
    if(theWindowIsFloating)
        [self unfloatWindow];
    else
        [self floatWindow];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object 
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if([keyPath isEqual:@"opacityWhenWindowIsTransparent"]){
		[self setCurrentAnimationValue:1.0];
    }
}

#pragma mark Window Attributes

/**
* The window can either be normal or full screen. Normal implies a normally sized window on the desktop,
 * and full screen implies a full screen presentation of a movie.
 */
-(void)makeFullScreen
{
    return [self makeFullScreenOnScreen:[self screen]];
}
-(void)makeFullScreenOnScreen:(NSScreen*) aScreen
{
    if(!fullScreen){
	fullScreen = YES;
	oldWindowLevel = [self level];
        
	[self setLevel:NSFloatingWindowLevel +2];
	[[[self windowController] document] closePlaylistDrawer:self];
	[self makeKeyAndOrderFront:self];
	beforeFullScreen = [self frame];
	[self fillScreenSizeOnScreen:aScreen];

	[self hideNotifier];
    }
    [theMovieView drawMovieFrame];
    if([[Preferences mainPrefs] autoplayOnFullScreen]){
        [theMovieView start];
    };
    [self hideAllImmediately];
	[self setOverLaySubtitleLocation];

}

-(void)makeNormalScreen
{
    if(fullScreen){
	[self setLevel:oldWindowLevel];
        [self resetFillingFlags];
        [self setFrame:beforeFullScreen display:NO];
        fullScreen = NO;
	if([self fixedAspect])
	    [self resizeToAspectRatio];
	[self hideNotifier];
    }
    [theMovieView drawMovieFrame];
    [theOverlayTitleBar orderFront:self];
    [theOverlayVolume orderFront:self];
    [theOverlayWindow orderFront:self];
	[self setOverLaySubtitleLocation];
	[theOverlaySubTitleWindow orderFront:self];
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
    [self setHasShadow:NO];
}

-(void)unPresentMultiple
{
    presentScreen = NO;
    [self setLevel:oldWindowLevel];
    [self setHasShadow:YES];
}

/**
* The next two methods set whether the window floats above the others. Behavior changes depending on
 * whether floating is occuring.
 */

-(void)floatWindow
{
    if(![self isFullScreen]){
        [self setLevel:NSFloatingWindowLevel];
    }else{
        oldWindowLevel = NSFloatingWindowLevel;
    }
    theWindowIsFloating = YES;
}

-(void)unfloatWindow
{
    
    if(![self isFullScreen]){
        [self setLevel:NSNormalWindowLevel];
    }else{
        oldWindowLevel = NSNormalWindowLevel;
    }
    theWindowIsFloating = NO;
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
    
    while((object = [enumerator nextObject])){
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
#warning Fix this when Apple fixes setFrame:display:animate:
    [self setFrame:[self calcResizeSize:aSize] display:YES animate:(animate ? [theMovieView canAnimateResize] : NO)];
}

-(NSRect)calcResizeSize:(NSSize)aSize
{
    float newHeight = aSize.height;
    float newWidth = aSize.width;
    
    if(newHeight <= [self minSize].height || newWidth <= [self minSize].width) {
        newHeight = [self frame].size.height;
        newWidth = [self frame].size.width;

    }
    
    switch([[Preferences mainPrefs] scrollResizePin]){
        case PIN_LEFT_TOP:
            return NSMakeRect([self frame].origin.x,
			      [self frame].origin.y + ([self frame].size.height - newHeight),
			      newWidth, newHeight);
            break;
        case PIN_CENTER:
            return NSMakeRect([self frame].origin.x+(([self frame].size.width-newWidth)/2),
			      [self frame].origin.y+(([self frame].size.height-newHeight)/2),
			      newWidth, newHeight);
            break;
	case PIN_SMART:
	{
	    NSRect screenFrame = [[self screen] visibleFrame];
	    NSRect centerRect = NSMakeRect([self frame].origin.x+(([self frame].size.width-newWidth)/2),
					[self frame].origin.y+(([self frame].size.height-newHeight)/2),
					newWidth, newHeight);
	    NSRect newRect = centerRect;

	    if(([self frame].origin.x < screenFrame.origin.x)
	       || ([self frame].origin.y < screenFrame.origin.y)
	       || (([self frame].origin.x + [self frame].size.width) > (screenFrame.origin.x + screenFrame.size.width))
	       || (([self frame].origin.y + [self frame].size.height) > (screenFrame.origin.y + screenFrame.size.height))){
		   return centerRect;
	    }
	    
	    if(newRect.origin.x < screenFrame.origin.x)
		newRect.origin.x = screenFrame.origin.x;
		
	    if(newRect.origin.y < screenFrame.origin.y)
		newRect.origin.y = screenFrame.origin.y;
		
	    if((screenFrame.origin.x + screenFrame.size.width) < (newRect.origin.x + newRect.size.width))
		newRect.origin.x -= (newRect.origin.x + newRect.size.width) - (screenFrame.origin.x + screenFrame.size.width);

	    if((screenFrame.origin.y + screenFrame.size.height) < (newRect.origin.y + newRect.size.height))
		newRect.origin.y -= (newRect.origin.y + newRect.size.height) - (screenFrame.origin.y + screenFrame.size.height);
	    
	    if(newRect.origin.x < screenFrame.origin.x)
		newRect.origin.x = centerRect.origin.x;

	    if(newRect.origin.y < screenFrame.origin.y)
	       newRect.origin.y = centerRect.origin.y;
	    return newRect;
	}
    }
    
    return NSMakeRect(0, 0, 100, 100);
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

-(void)_JTRefitFills
{
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

-(void)setNotificationText:(NSString *)aString
{
    [theOverlayNotifier setText:aString];
    [self setNotifierLocation];
    [theOverlayNotifier setAlphaValue:1.0];
    id notifierFade = [NSMutableSet setWithObjects:theOverlayNotifier, nil];
    NSDictionary *fadeDict = [NSDictionary dictionaryWithObjects:
        [NSArray arrayWithObjects:self,	notifierFade, @"clearNotifierTimer",	nil]
                                                         forKeys:
	[NSArray arrayWithObjects:@"Window", @"Fade", @"Selector",  nil]];
    if(notifierTimer)
		[notifierTimer invalidate];
    notifierTimer = [[FadeOut fadeOut] notifierFadeForDict:fadeDict];
}

-(void)setNotifierLocation
{
    NSRect currentFrame;
    if(!fullScreen)
	currentFrame = [self frame];
    else {
	currentFrame = [[NSScreen mainScreen] frame];
	currentFrame.origin.y -= 48;
    }
    
    [theOverlayNotifier setFrame:NSMakeRect(currentFrame.origin.x,
                                currentFrame.origin.y + currentFrame.size.height
				- [theOverlayTitleBar frame].size.height - [theOverlayNotifier frame].size.height,
                                currentFrame.size.width,
                                [theOverlayNotifier frame].size.height)
      display:YES];
}

-(void)hideNotifier
{
    [theOverlayNotifier setAlphaValue:0.0];
    if(notifierTimer)
	[notifierTimer invalidate];
    notifierTimer = nil;
    [[FadeOut fadeOut] removeWindow:theOverlayNotifier];
}

-(void)clearNotifierTimer
{
    notifierTimer = nil;
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
    [self fillScreenSizeOnScreen:[self screen]];
}

-(void)fillScreenSizeOnScreen:(NSScreen*)aScreen{
    [self resetFillingFlags];
    isFilling=YES;
    
    NSSize aSize = [self getResizeAspectRatioSizeOnScreen:aScreen];
    NSRect newRect = [self calcResizeSize:aSize];
    newRect.origin.x = 0;
    newRect = [self centerRect:newRect onScreen:aScreen];
    [self setFrame:newRect display:YES];
    [self centerOnScreen:aScreen];
}


-(IBAction)fillWidthSize:(id)sender
{
    [self fillWidthSizeWithScreen:[self screen]];
}

-(void)fillWidthSizeWithScreen:(NSScreen*)aScreen
{
    [self resetFillingFlags];
    isWidthFilling = YES;
    NSRect tempRect  = [aScreen frame];
    float tempVertAmount = tempRect.size.width
        *([self aspectRatio].height/[self aspectRatio].width)
        -[self frame].size.height;
    
    [self resize:tempVertAmount animate:NO];
    [self centerOnScreen:aScreen];
}

/**
* Sets the internally stored aspect ratio size.
 */
- (void)setAspectRatio:(NSSize)ratio
{   
    if((ratio.width == 0) || (ratio.height == 0)){
	ratio.width = 1;
	ratio.height = 1;
    }
    aspectRatio = ratio;
    [super setAspectRatio:ratio];
    [self setMinSize:NSMakeSize(([self aspectRatio].width/[self aspectRatio].height) *[self minSize].height,[self minSize].height)];
    fixedAspectRatio = YES;
}

-(void)setResizeIncrements:(NSSize)increments
{
    [super setResizeIncrements:increments];
    fixedAspectRatio = NO;
}

- (NSSize)aspectRatio
{
    if(fixedAspectRatio)
	return [super aspectRatio];
    else{
        return NSMakeSize( ([self frame].size.width / [self frame].size.height) * aspectRatio.height, aspectRatio.height);
    }

}

/**
* Get the size given the aspect ratio and current size. This returns a size that has the same height
 * as the current window, but with the width adjusted wrt to the aspect ratio. Or if the window is
 * full screen, it returns a size that has the width stretched out to fit the screen,
 * assuming the current video is also screen filling.
 */

-(NSSize)getResizeAspectRatioSize
{

    return [self getResizeAspectRatioSizeOnScreen:[self screen]];
}

-(NSSize)getResizeAspectRatioSizeOnScreen:(NSScreen*) aScreen
{
    NSSize ratio = [self aspectRatio];
    float newWidth = (([self frame].size.height / ratio.height) * ratio.width);
    if(isFilling | isWidthFilling){
        float width = [aScreen frame].size.width;
        
        float height = [aScreen frame].size.height;
        float calcHeigth =(width / ratio.width) * ratio.height;
        if(calcHeigth >height){
            return NSMakeSize((height / ratio.height) * ratio.width, height);
        }else{
            return NSMakeSize(width, (width / ratio.width) * ratio.height);
        }
    }

    return NSMakeSize(newWidth, [self frame].size.height);
}

/**
* Resize the window so no scaling occurs -- the resolution given by the aspect ratio.
 */
-(void)initialDefaultSize
{
    [self resizeWithSize:NSMakeSize([self aspectRatio].width,[self aspectRatio].height) animate:YES];
    if (fullScreen)
        [self center];	
}

/**
* Resize the window to the size returned by getResizeAspectRatioSize
 */
-(void)resizeToAspectRatio
{
    [self setAspectRatio:[theMovieView naturalSize]];
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
    [self centerOnScreen:[self screen]];
}

- (void)centerOnScreen:(NSScreen*)aScreen{
	if(fullScreen){
	    [self removeChildWindow:theOverlayTitleBar];
		[self removeChildWindow:theOverlaySubTitleWindow];
		}

    [self setFrame:[self centerRect:[self frame] onScreen:aScreen]
           display:YES];
		   	if(fullScreen){
	    [self addChildWindow:theOverlayTitleBar ordered:NSWindowAbove];
		[self addChildWindow:theOverlaySubTitleWindow ordered:NSWindowAbove];
		}
		
    
}

-(NSRect)centerRect:(NSRect)aRect
{
    return [self centerRect:aRect onScreen:[self screen]];
}

-(NSRect)centerRect:(NSRect)aRect onScreen:(NSScreen*)aScreen
{
    NSRect screenRect;
    if (!fullScreen)
        screenRect = [aScreen visibleFrame];
    else
        screenRect = [aScreen frame];
    return NSOffsetRect(aRect, NSMidX(screenRect)-NSMidX(aRect),
                        NSMidY(screenRect)-NSMidY(aRect));
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
    if(resizeDrag){
        if(fixedAspectRatio)
	    [self resize:[anEvent deltaY] animate:NO];
	else {
	    float newHeight = [self frame].size.height + [anEvent deltaY];
	    float newWidth = [self frame].size.width + [anEvent deltaX];
	    
	    [self resizeWithSize:NSMakeSize(newWidth, newHeight) animate:NO];
	}
    } else {
        if(fullScreen && !NSEqualRects([[[NSDocumentController sharedDocumentController] backgroundWindow] frame],[[NSScreen mainScreen]frame])){
            [[[NSDocumentController sharedDocumentController] backgroundWindow] setFrame:[[NSScreen mainScreen]frame] 
                                                                                 display:YES];
            if([[NSScreen mainScreen] isEqualTo:[[NSScreen screens] objectAtIndex:0]])
                SetSystemUIMode(kUIModeAllHidden, kUIOptionAutoShowMenuBar);
            dropScreen = YES;
        }
	[self showOverLayTitle];

	/* If we don't do a remove, the child window gets automatically placed when the parent window moves, even if we try
	to set the location manually. */
	if(fullScreen){
	    [self removeChildWindow:theOverlayTitleBar];
		[self removeChildWindow:theOverlaySubTitleWindow];
		}
	[self setFrameOrigin:NSMakePoint([self frame].origin.x+[anEvent deltaX],[self frame].origin.y-[anEvent deltaY])];
	if(fullScreen){
	    [self addChildWindow:theOverlayTitleBar ordered:NSWindowAbove];
		[self addChildWindow:theOverlaySubTitleWindow ordered:NSWindowAbove];
		}
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

-(void)scrollWheel:(NSEvent *)anEvent
{
	[theMovieView scrollWheel:anEvent];
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
			NSArray *sortedArray = [files sortedArrayUsingSelector:@selector(caseInsensitiveNumericCompareSublist:)];
            for(i = 0; i < [sortedArray count]; i++){
                filename = [sortedArray objectAtIndex:i];
                [[[self windowController] document] addURLToPlaylist:[NSURL fileURLWithPath:filename]];
            }
            [[[self windowController] document] openPlaylistDrawerConditional:self];
        }	
    }
    return YES;
}

-(void)concludeDragOperation:(id <NSDraggingInfo>)sender
{
}

-(NSArray *)acceptableDragTypes
{
    return [NSArray arrayWithObjects:NSFilenamesPboardType,nil];
}

@end
