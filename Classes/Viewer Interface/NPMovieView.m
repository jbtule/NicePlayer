/**
 * NPMovieView.m
 * NicePlayer
 *
 * Contains the code for the main view that appears in NiceWindow. It is responsible for
 * creating instances of different movie player views (from plugins) that open movies
 * using different APIs (Quicktime, DVDPlayback, etc.) Basically, it acts as a wrapper
 * for the subview that it dynamically creates, processing most of the various clicks
 * and other events that take place.
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
* Portions created by the Initial Developer are Copyright (C) 2004-2005
* the Initial Developer. All Rights Reserved.
*
* Contributor(s):
*           Robert Chin <robert@osiris.laya.com> (NicePlayer Author)
*           James Tuley <jbtule@mac.com> (NicePlayer Author)
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



#import "NPMovieView.h"
#import "../Overlay Widgets/Control Buttons/ControlButton.h"
#import "../Overlay Widgets/Control Buttons/ControlPlay.h"
@class JTMovieView;
@class NPPluginReader;

@implementation NPMovieView

+(id)blankImage
{
	return [JTMovieView blankImage];
}

-(id)initWithFrame:(NSRect)aRect
{
    if ((self = [super initWithFrame:aRect])) {
        NSRect subview = NSMakeRect(0, 0, aRect.size.width, aRect.size.height);
        trueMovieView = [[JTMovieView alloc] initWithFrame:subview];
        contextMenu = [[NSMenu alloc] initWithTitle:@"NicePlayer"];
        wasPlaying = NO;
        [self addSubview:trueMovieView];
        [self setAutoresizesSubviews:YES];
		title = nil;
		fileType = nil;
		fileExtension = nil;
		internalVolume = 1.0;
    }
    return self;
}

-(void)awakeFromNib
{
	[self registerForDraggedTypes:[(NiceWindow *)[self window] acceptableDragTypes]];
	[trueMovieView registerForDraggedTypes:[(NiceWindow *)[self window] acceptableDragTypes]];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(start)
												 name:@"PlayAllMovies"
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(stop)
												 name:@"StopAllMovies"
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(rebuildMenu)
												 name:@"RebuildMenu"
											   object:nil];	
	[[NSNotificationCenter defaultCenter] addObserver:self
						 selector:@selector(rebuildTrackingRects)
						     name:NSViewFrameDidChangeNotification
						   object:self];	
	trackingRect = [self addTrackingRect:[self bounds] owner:self userData:nil assumeInside:NO];
}

-(void)rebuildTrackingRects
{
	[self viewWillMoveToWindow:[self window]];
}

-(void)viewWillMoveToWindow:(NSWindow *)window
{
	if([self window])
		[self removeTrackingRect:trackingRect];
	if(window)
		trackingRect = [self addTrackingRect:[self bounds] owner:window userData:nil assumeInside:NO];
}

-(void)closeReopen
{
	NSRect subview = NSMakeRect(0, 0, [self frame].size.width, [self frame].size.height);
	internalVolume = [self volume];
	[self close];
	[trueMovieView release];
	trueMovieView = [[JTMovieView alloc] initWithFrame:subview];
	[self addSubview:trueMovieView];
	[self finalProxyViewLoad];
}

-(void)close
{
	NSLog(@"Close MovieView");
	[trueMovieView close];
	[trueMovieView removeFromSuperview];
	[trueMovieView unregisterDraggedTypes];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self unregisterDraggedTypes];
}

-(void)dealloc
{
    if(mouseEntered)
		[self mouseExited:nil];
    [title release];
    [trueMovieView release];
    [super dealloc];
}

-(BOOL)openURL:(NSURL *)url
{
    [trueMovieView removeFromSuperview];
    if(title)
		[title release];
    title = [[[[url path] lastPathComponent] stringByDeletingPathExtension] retain];

    if(fileType)
	[fileType release];
    fileType = nil;
    if(fileExtension)
	[fileExtension release];
    fileExtension = nil;
    
    fileExtension = [[[url path] lastPathComponent] pathExtension];
    fileType = NSHFSTypeOfFile([url path]);
    BOOL isDir;
    [[NSFileManager defaultManager] fileExistsAtPath:[url path] isDirectory:&isDir];
    if(isDir){
	fileExtension = [NSString stringWithString:@"public.folder"];
	fileType = nil;
    }
    if((fileType) && ([fileType length] == 0))
	fileType = nil;
    else
	[fileType retain];

    if((fileExtension) && ([fileExtension length] == 0))
	fileExtension = nil;
    else
	[fileExtension retain];
    
    BOOL didOpen = NO;
    unsigned i;
    NSRect subview = NSMakeRect(0, 0, [self frame].size.width, [self frame].size.height);
    id pluginOrder = [[NPPluginReader pluginReader] cachedPluginOrder];
    id pluginDict = [[NPPluginReader pluginReader] prefDictionary];
	NSException *noLoadException = [NSException exceptionWithName:@"NoLoadPlugin"
							       reason:@"CouldntLoad"
							     userInfo:nil];	
    /* Try to choose the proper plugin by finding out first whether the plugin is enabled, and then if it handles the type. */
	@try {
		for(i = 0; (i < [pluginOrder count]) && (didOpen == NO); i++){
			NSDictionary *currentPlugin = [pluginOrder objectAtIndex:i];
			if(![[currentPlugin objectForKey:@"Chosen"] boolValue])
				continue;
			if(trueMovieView)
			    [trueMovieView release];
			trueMovieView = nil;
			id newViewClass = [[pluginDict objectForKey:[currentPlugin objectForKey:@"Name"]] objectForKey:@"Class"];
			/* We should change the line below to be more graceful if a plugin can't load. */
			trueMovieView = [newViewClass alloc];
			if(!trueMovieView)
				@throw noLoadException;
			if([trueMovieView initWithFrame:subview] == nil){   /* This is used by RCMovieView gestalt check for Tiger, fail-safe no-load. */
			    [trueMovieView release];
			    trueMovieView = nil;
			    continue;
			}
			didOpen = [trueMovieView openURL:url];
		}
		if(didOpen){
			[self addSubview:trueMovieView];
			if(![self loadMovie])
				@throw noLoadException;
		} else {
		    if(trueMovieView){
			[trueMovieView release];
			trueMovieView = nil;
		    }
		    @throw noLoadException;
		}
	}
	@catch(NSException *exception) {
		didOpen = NO;
		if(trueMovieView)
		    [trueMovieView release];
		trueMovieView = [[JTMovieView alloc] initWithFrame:subview];
		[self addSubview:trueMovieView];
	}
	@finally {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"RebuildAllMenus" object:nil];
		[self finalProxyViewLoad];
	}
    if(didOpen)
	openedURL = url;
    else
    openedURL = nil;
    return didOpen;
}

-(void)switchToPlugin:(id)sender
{
    [self switchToPluginClass:[sender representedObject]];
}


-(void)switchToPluginClass:(Class)aClass
{
    BOOL didOpen = NO;
    NSRect subview = NSMakeRect(0, 0, [self frame].size.width, [self frame].size.height);
    id oldClass = [trueMovieView class];
    double currentMovieTime = [self currentMovieTime];
    BOOL playingBeforeSwitch = [self isPlaying];
    NSException *noLoadException = [NSException exceptionWithName:@"NoLoadPlugin"
							   reason:@"CouldntLoad"
							 userInfo:nil];	    
    @try {
	[self close];
	[trueMovieView release];
	trueMovieView = nil;
	id newViewClass = aClass;
	/* We should change the line below to be more graceful if a plugin can't load. */
	trueMovieView = [newViewClass alloc];
	if(!trueMovieView)
	    @throw noLoadException;
	/* This is used by RCMovieView gestalt check for Tiger, fail-safe no-load. */
	if([trueMovieView initWithFrame:subview] == nil){
	    [trueMovieView release];
	    @throw noLoadException;
	}
	if([trueMovieView openURL:openedURL])
	    [self addSubview:trueMovieView];
	else
	    @throw noLoadException;
	if(![self loadMovie])
	    @throw noLoadException;
    }
    @catch(NSException *exception) {
	didOpen = NO;
	if(trueMovieView)
	    [trueMovieView release];
	trueMovieView = [[oldClass alloc] initWithFrame:subview];
	[self addSubview:trueMovieView];
    }
    @finally {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RebuildAllMenus" object:nil];
	[self finalProxyViewLoad];
	[self setCurrentMovieTime:currentMovieTime];
	if(playingBeforeSwitch)
	    [self start];
    }
}


-(BOOL)loadMovie
{
	BOOL didLoadMovie = [trueMovieView loadMovie];
	
	if(didLoadMovie){
		[trueMovieView setVolume:internalVolume];
	}
	
	return didLoadMovie;
}

-(void)finalProxyViewLoad
{
	[trueMovieView registerForDraggedTypes:[(NiceWindow *)[self window] acceptableDragTypes]];
}

-(NSView *)hitTest:(NSPoint)aPoint
{
    if(NSMouseInRect(aPoint, [self frame], NO))
        return self;
    return nil;
}

-(BOOL)acceptsFirstResponder
{
	return YES;
}

#pragma mark -
#pragma mark Controls

-(void)start
{
    wasPlaying = YES;
    [trueMovieView start];
    [[((NiceWindow *)[self window]) playButton] changeToProperButton:[trueMovieView isPlaying]];
}

-(void)stop
{
    wasPlaying = NO;
    
    [(<NPMoviePlayer>)trueMovieView stop];
    [[((NiceWindow *)[self window]) playButton] changeToProperButton:[trueMovieView isPlaying]];
}


-(void)ffStart
{
    [[((NiceWindow *)[self window]) ffButton] highlight:YES];
    [((NiceWindow *)[self window]) automaticShowOverLayWindow];
    [trueMovieView ffStart:[[Preferences mainPrefs] ffSpeed]];
    [((NiceWindow *)[self window]) updateByTime:nil];
}

-(void)ffDo
{
    [self ffDo:[[Preferences mainPrefs] ffSpeed]];
}

-(void)ffDo:(int)aSeconds
{
    [((NiceWindow *)[self window]) automaticShowOverLayWindow];
    [trueMovieView ffDo:aSeconds];
    [((NiceWindow *)[self window]) updateByTime:nil];
}

-(void)ffEnd
{
    [[((NiceWindow *)[self window]) ffButton] highlight:NO];
    [trueMovieView ffEnd];
    [((NiceWindow *)[self window]) updateByTime:nil];
    
}

-(void)rrStart
{
    [[((NiceWindow *)[self window]) rrButton] highlight:YES];
    [((NiceWindow *)[self window]) automaticShowOverLayWindow];
    [trueMovieView rrStart:[[Preferences mainPrefs] rrSpeed]];
    [((NiceWindow *)[self window]) updateByTime:nil];
}

-(void)rrDo
{
    [self rrDo:[[Preferences mainPrefs] rrSpeed]];
}

-(void)rrDo:(int)aSeconds{
    [((NiceWindow *)[self window]) automaticShowOverLayWindow];
    [trueMovieView rrDo:aSeconds];
    [((NiceWindow *)[self window]) updateByTime:nil];
}

-(void)rrEnd
{
    [[((NiceWindow *)[self window]) rrButton] highlight:NO];
    [trueMovieView rrEnd];
    [((NiceWindow *)[self window]) updateByTime:nil];
    
}

-(void)toggleMute
{
    [trueMovieView setMuted:![trueMovieView muted]];
    [((NiceWindow *)[self window]) updateVolume];
}

-(void)incrementVolume
{
	[self setVolume:[self volume]+.1];
	[((NiceWindow *)[self window]) updateVolume];
}

-(void)decrementVolume
{
	[self setVolume:[self volume]-.1];
	[((NiceWindow *)[self window]) updateVolume];
}

#pragma mark Widgets

-(IBAction)scrub:(id)sender
{
	[trueMovieView setCurrentMovieTime:([trueMovieView totalTime] * [sender doubleValue])];
    [((NiceWindow *)[self window]) updateByTime:sender];
}

-(double)scrubLocation:(id)sender
{
	return (double)[trueMovieView currentMovieTime] / (double)[trueMovieView totalTime];
}

-(BOOL)isPlaying
{
	return [trueMovieView isPlaying];
}

-(BOOL)wasPlaying
{
    return wasPlaying;
}

-(void)playPrevMovie
{
    if([self currentMovieTime] > 2){
	[trueMovieView setCurrentMovieTime:0];
	[((NiceWindow *)[self window]) setNotificationText:title];
    } else {
	[[[self window] delegate] playPrev];
	[((NiceWindow *)[self window]) setNotificationText:title];
    }
}

-(void)playNextMovie
{
    [[[self window] delegate] playNext];
    [((NiceWindow *)[self window]) setNotificationText:title];
}
#pragma mark -
#pragma mark Keyboard Events

-(void)keyDown:(NSEvent *)anEvent
{
    if(([anEvent modifierFlags] & NSShiftKeyMask)){
		/* Pass down shift flagged keys to trueMovieView */
		[trueMovieView keyDown:anEvent];
		return;
    }
    
    switch([[anEvent characters] characterAtIndex:0]){
		case ' ':
			if(![anEvent isARepeat]){
				[[((NiceWindow *)[self window]) playButton] togglePlaying];
				[((NiceWindow *)[self window]) automaticShowOverLayWindow];
			}
			break;
		case NSRightArrowFunctionKey:
			if([anEvent modifierFlags] & NSCommandKeyMask){
			    [self playNextMovie];
				break;
			}
			if([anEvent modifierFlags] & NSAlternateKeyMask){
				[trueMovieView stepForward];
				break;
			}
			if(![anEvent isARepeat])
				[self ffStart];
			else
				[self ffDo];
			break;
		case NSLeftArrowFunctionKey:
			if([anEvent modifierFlags] & NSCommandKeyMask){
			    [self playPrevMovie];
				break;
			}
			if([anEvent modifierFlags] & NSAlternateKeyMask){
				[trueMovieView stepBackward];
				break;
			}
			if(![anEvent isARepeat])
				[self rrStart];
			else
				[self rrDo];
			break;
		case NSUpArrowFunctionKey:
			[self incrementVolume];
			[self showOverLayVolume];
			break;
		case NSDownArrowFunctionKey:
			[self decrementVolume];
			[self showOverLayVolume];
			break;
		case NSDeleteFunctionKey:
			[self toggleMute];
			[self showOverLayVolume];
			break;
		case 0x1B:
			[((NiceWindow *)[self window]) unFullScreen];
			break;
		default:
			[super keyDown:anEvent];
    }
}

-(void)keyUp:(NSEvent*)anEvent
{
	if(([anEvent modifierFlags] & NSShiftKeyMask)){
		/* Pass down shift flagged keys to trueMovieView */
		[trueMovieView keyUp:anEvent];
		return;
    }
	
	switch([[anEvent characters] characterAtIndex:0]){
		case ' ':
			[self smartHideMouseOverOverlays];
			break;
		case NSRightArrowFunctionKey:
			[self ffEnd];
			[self smartHideMouseOverOverlays];
			break;
		case NSLeftArrowFunctionKey:
			[self rrEnd];
			[self smartHideMouseOverOverlays];
			break;
		case NSUpArrowFunctionKey: case NSDownArrowFunctionKey:
			[self timedHideOverlayWithSelector:@"hideOverLayVolume"];
 			break;
		default:
			[super keyUp:anEvent];
    }
}

-(void)showOverLayVolume
{
	[self cancelPreviousPerformRequestsWithSelector:@"hideOverLayVolume"];
	[((NiceWindow *)[self window])automaticShowOverLayVolume];
	[self timedHideOverlayWithSelector:@"hideOverLayVolume"];
}

-(void)smartHideMouseOverOverlays
{
	/* Simulate and distribute a mouse moved event for the window so that the proper menu stuff gets displayed
	if we're in a zone that's between gui buttons. */
	NSEvent *newEvent = [NSEvent mouseEventWithType:NSMouseMoved
										   location:[((NiceWindow *)[self window]) convertScreenToBase:[NSEvent mouseLocation]]
									  modifierFlags:0
										  timestamp:0
									   windowNumber:0
											context:nil
										eventNumber:0
										 clickCount:0
										   pressure:1.0];
	[((NiceWindow *)[self window]) mouseMoved:newEvent];
}

-(void)timedHideOverlayWithSelector:(NSString *)aStringSelector
{
	[self performSelector:@selector(hideOverlayWithSelector:) withObject:aStringSelector afterDelay:1.0];
}

-(void)cancelPreviousPerformRequestsWithSelector:(NSString *)aStringSelector
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self
											 selector:@selector(hideOverlayWithSelector:)
											   object:aStringSelector];
}

-(void)hideOverlayWithSelector:(NSString *)aStringSelector
{
	[[self window] performSelector:sel_registerName([aStringSelector cString])];
}

#pragma mark Mouse Events

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent
{
	return YES;
}

- (void)mouseDown:(NSEvent *)anEvent
{
	if(([anEvent type] == NSOtherMouseDown)
	   && (([anEvent modifierFlags] & 0x100108) == 0x100108)) /* This is a middle click. */
	   [((NiceWindow *)[self window]) toggleWindowFloat];
	   
	   if([anEvent type] == NSLeftMouseDown){
			  if(([anEvent modifierFlags] & NSControlKeyMask) == NSControlKeyMask){ /* This is a control click. */
				  [self rightMouseDown:anEvent];
				  return;
			  }
		   }
	if(([anEvent clickCount] > 0) && (([anEvent clickCount] % 2) == 0)){
		   [self mouseDoubleClick:anEvent];
	   } else {
		   [trueMovieView mouseDown:anEvent];
		   [((NiceWindow *)[self window]) mouseDown:anEvent];
	   }
}

- (void)mouseUp:(NSEvent *)anEvent
{
    dragButton = NO;
	
	if(([anEvent type] == NSLeftMouseUp)
	   && (([anEvent modifierFlags] & NSControlKeyMask) == NSControlKeyMask)){ /* This is a control click. */
	   [self rightMouseUp:anEvent];
	   return;
	}
	[((NiceWindow *)[self window]) mouseUp:anEvent];
}

- (void)mouseDoubleClick:(NSEvent *)anEvent
{
	switch([[Preferences mainPrefs] doubleClickMoviePref]){
		case MAKE_WINDOW_FULL_SCREEN:
			[((NiceWindow *)[self window]) toggleWindowFullScreen];
			break;
		case PLAY_PAUSE_MOVIE:
			[[((NiceWindow *)[self window]) playButton] togglePlaying];
			break;
	}
}

- (void)mouseMoved:(NSEvent *)anEvent
{
	[trueMovieView mouseMoved:anEvent];
	[self smartHideMouseOverOverlays];
}

/* This is so we can capture the right mouse event. */
-(NSMenu *)menuForEvent:(NSEvent *)event
{
	return nil;
}

-(void)rightMouseDown:(NSEvent *)anEvent
{
	if([[Preferences mainPrefs] rightClickMoviePref] == RIGHT_CLICK_DISPLAY_CONTEXT_MENU)
		[NSMenu popUpContextMenu:[self contextualMenu]
					   withEvent:anEvent
						 forView:self];
}

-(void)rightMouseUp:(NSEvent *)anEvent
{
	switch([[Preferences mainPrefs] rightClickMoviePref]){
		case RIGHT_CLICK_PLAY_PAUSE_MOVIE:
			[[((NiceWindow *)[self window]) playButton] togglePlaying];
			break;
		case RIGHT_CLICK_MAKE_FULL_SCREEN:
			[((NiceWindow *)[self window]) toggleWindowFullScreen];
			break;
		default:
			break;
	}
}

- (void)mouseDragged:(NSEvent *)anEvent
{
    if(!dragButton)
        [((NiceWindow *)[self window]) mouseDragged:anEvent];
}

-(BOOL)canAnimateResize
{
    if([trueMovieView respondsToSelector:@selector(canAnimateResize)])
	return [trueMovieView canAnimateResize];
    return YES;
}

-(void)scrollWheel:(NSEvent *)anEvent
{
	[self performScrollerForPref:[[Preferences mainPrefs] scrollWheelMoviePref]
						   event:anEvent
						   delta:[anEvent deltaY]];
	[self performScrollerForPref:[[Preferences mainPrefs] scrollWheelHorizontalMoviePref]
						   event:anEvent
						   delta:-[anEvent deltaX]];
}

-(void)performScrollerForPref:(enum scrollWheelMoviePrefValues)pref event:(NSEvent *)anEvent delta:(float)delta
{
	if(delta == 0.0)
		return;
	
	switch(pref){
		case SCROLL_WHEEL_ADJUSTS_VOLUME:
			if([anEvent modifierFlags] & NSAlternateKeyMask)
				[self scrollWheelResize:delta];
			else
				[self scrollWheelAdjustVolume:delta];
			break;
		case SCROLL_WHEEL_ADJUSTS_SIZE:
			if([anEvent modifierFlags] & NSAlternateKeyMask)
				[self scrollWheelAdjustVolume:delta];	
			else
				[self scrollWheelResize:delta];
			break;
		case SCROLL_WHEEL_SCRUBS:
		{
			if(delta > 0){
				[self ffStart];
				[self ffDo:[[Preferences mainPrefs] ffSpeed] * fabsf(delta)];
				[self ffEnd];
			} else {
				[self rrStart];
				[self rrDo:[[Preferences mainPrefs] ffSpeed] * fabsf(delta)];
				[self rrEnd];
			}
			break;
		}
		default:
			// SCROLL_WHEEL_ADJUSTS_NONE
			break;
    }
}

-(void)scrollWheelResize:(float)delta
{
    [((NiceWindow *)[self window]) resize:delta*5 animate:NO];
}

-(void)scrollWheelAdjustVolume:(float)delta
{
    SEL volAdj;
    float i, max;
    
    [self showOverLayVolume];
    
    if(delta > 0.0)
	volAdj = @selector(incrementVolume);
    else
	volAdj = @selector(decrementVolume);
    
    max = fabsf(delta);
    for(i = 0.0; i < max; i += 3.0)
	[self performSelector:volAdj];
}

#pragma mark -
#pragma mark Menus

-(id)myMenu
{
	id myMenu = [[NSMutableArray array] retain];
	id newItem;
	
	newItem = [[[NSMenuItem alloc] initWithTitle:@"Play/Pause"
					      action:@selector(togglePlaying)
				       keyEquivalent:@""] autorelease];
	[newItem setTarget:[((NiceWindow *)[self window]) playButton]];
	[myMenu addObject:newItem];
	
	newItem = [[[NSMenuItem alloc] initWithTitle:@"Floats on Top"
					      action:@selector(toggleWindowFloat)
				       keyEquivalent:@""] autorelease];
	[newItem setTarget:[self window]];
	[newItem setState:[((NiceWindow *)[self window]) windowIsFloating]];
	[myMenu addObject:newItem];

	return [myMenu autorelease];
}

-(id)menuTitle
{
	NSMutableString *string = [NSMutableString stringWithString:[trueMovieView menuPrefix]];
	NSString *item = [trueMovieView menuTitle];
	if([item length] > 0){
		[string appendString:@"	("];
		[string appendString:item];
		[string appendString:@")"];
	}
	return string;
}

-(Class)currentPluginClass{
    return [trueMovieView class];
}

-(id)pluginMenu
{
    NSMutableArray *menuArray = [trueMovieView pluginMenu];
    if(!menuArray)
	menuArray = [NSMutableArray array];
    else
	[menuArray addObject:[NSMenuItem separatorItem]];
    
    NSMenu *choiceMenu = [[[NSMenu alloc] init] autorelease];
    NSMenu *allChoiceMenu = [[[NSMenu alloc] init] autorelease];
    id newItem;
    
    id pluginOrder = [[NPPluginReader pluginReader] cachedPluginOrder];
    id pluginDict = [[NPPluginReader pluginReader] prefDictionary];
    
    unsigned i;
    for(i = 0; i < [pluginOrder count]; i++){
	NSDictionary *currentPlugin = [pluginOrder objectAtIndex:i];
	if(![[currentPlugin objectForKey:@"Chosen"] boolValue])
	    continue;
	id pluginClass = [[pluginDict objectForKey:[currentPlugin objectForKey:@"Name"]] objectForKey:@"Class"];
	NSArray *typeArray = [[pluginClass plugInfo] objectForKey:@"FileExtensions"];
	newItem = [[[NSMenuItem alloc] initWithTitle:[currentPlugin objectForKey:@"Name"]
					      action:@selector(switchToPlugin:)
				       keyEquivalent:@""] autorelease];
	[newItem setTarget:self];
	[newItem setRepresentedObject:pluginClass];
	if([pluginClass isEqualTo:[trueMovieView class]])
	    [newItem setState:NSOnState];
	
	if((fileType && [typeArray containsObject:fileType])
	   || (fileExtension && [typeArray containsObject:fileExtension])){
	    [choiceMenu addItem:newItem];
	}
	[allChoiceMenu addItem:[[newItem copy]autorelease]];
    }
    
    if([[[self window]document] subTitle] !=NULL){
       /* NSString* aName =[[[[self window]document] subTitle] path];
        aName = [aName lastPathComponent*/
        
        newItem = [[[NSMenuItem alloc] initWithTitle:@"External Subtitle"
                                              action:@selector(toggleExternaSubtitle:)
                                       keyEquivalent:@""] autorelease];
        [newItem setTarget:self];
        if([(NiceWindow*)[self window] isOverlaySubtitleShowing]){
            [newItem setState:NSOnState];
        }
        [menuArray addObject:newItem];

    }
    
    
    
    /* Create head object. */
    newItem = [[[NSMenuItem alloc] initWithTitle:@"Switch Plugin to..."
					  action:nil
				   keyEquivalent:@""] autorelease];
    [newItem setSubmenu:choiceMenu];
    [menuArray addObject:newItem];
    
    newItem = [[[NSMenuItem alloc] initWithTitle:@"Switch Plugin to (all)..."
					  action:nil
				   keyEquivalent:@""] autorelease];
    [newItem setSubmenu:allChoiceMenu];
    [newItem setAlternate:YES];
    [newItem setKeyEquivalentModifierMask:NSAlternateKeyMask];
    [menuArray addObject:newItem];
    
    return menuArray;
}

-(IBAction)toggleExternaSubtitle:(id)sender{
    
    if([(NiceWindow*)[self window] isOverlaySubtitleShowing]){
        [(NiceWindow*)[self window] hideOverLaySubtitle];
    }else{
        [(NiceWindow*)[self window] showOverLaySubtitle];

    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RebuildAllMenus" object:nil];
}


-(id)contextualMenu
{	
	[self rebuildMenu];
	return contextMenu;
}

-(void)rebuildMenu
{
	unsigned i;

	while([contextMenu numberOfItems] > 0)
		[contextMenu removeItemAtIndex:0];

	id myMenu = [self myMenu];
	id pluginMenu = [self pluginMenu];
	for(i = 0; i < [myMenu count]; i++)
		[contextMenu addItem:[myMenu objectAtIndex:i]];
	if([pluginMenu count] > 0)
		[contextMenu addItem:[NSMenuItem separatorItem]];
	for(i = 0; i < [pluginMenu count]; i++)
		[contextMenu addItem:[pluginMenu objectAtIndex:i]];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RebuildAllMenus" object:nil];
}


#pragma mark -
#pragma mark Pluggables

/* Used to determine the proper size of the window at a given magnification factor. */
-(NSSize)naturalSize
{
    NSSize movieSize = [trueMovieView naturalSize];
    if((movieSize.width == 0) && (movieSize.height == 0))
	return NSMakeSize(320, 240);
    else
	return movieSize;
}

-(double)currentMovieTime
{
	return [trueMovieView currentMovieTime];
}

-(double)currentMovieFrameRate
{
    return [trueMovieView currentMovieFrameRate];
}

-(void)setCurrentMovieTime:(double)aDouble
{
    [trueMovieView setCurrentMovieTime:aDouble];
}

-(BOOL)hasEnded:(id)sender
{
	return [trueMovieView hasEnded:sender];
}

-(BOOL)muted
{
	return [trueMovieView muted];
}

-(void)setMuted:(BOOL)aBool
{
	[trueMovieView setMuted:aBool];
}

-(float)volume
{
	float volume = [trueMovieView volume];
	
	if(volume < 0.0)
		volume = 0.0;
	if(volume > 2.0)
		volume = 2.0;
	
	return volume;
}

-(void)setVolume:(float)aVolume
{
	if(aVolume < 0.0)
		aVolume = 0.0;
	if(aVolume > 2.0)
		aVolume = 2.0;
	internalVolume = aVolume;
	[trueMovieView setVolume:internalVolume];

	if([trueMovieView volume] <= 0.0)
		[trueMovieView setMuted:YES];
	else
		[trueMovieView setMuted:NO];
}

-(double)totalTime
{
	return [trueMovieView totalTime];
}

-(void)drawMovieFrame
{
	[trueMovieView drawMovieFrame];
}

-(void)setLoopMode:(NSQTMovieLoopMode)flag
{
	[trueMovieView setLoopMode:flag];
}

/* Non working code */
#define CROP_STEP1 NSViewMinXMargin | NSViewMaxYMargin
#define CROP_STEP2 NSViewMaxXMargin | NSViewMinYMargin
#define FINAL_SIZING NSViewWidthSizable | NSViewHeightSizable

//crop doesn't work this is more test code
-(IBAction)crop:(id)sender
{
    NSRect newFrame = NSMakeRect(100+20,100+30,100+340,100+270);
    NSRect currentFrame = [((NiceWindow *)[self window]) frame];
    NSRect resizingFrame = currentFrame;
    
    resizingFrame.size.width -= (newFrame.origin.x);
    resizingFrame.size.height -= (newFrame.origin.y);
    [self setAutoresizingMask:CROP_STEP1];
    [((NiceWindow *)[self window]) setFrame:resizingFrame display:YES];
    resizingFrame.size.width -= (currentFrame.size.width - newFrame.size.width);
    resizingFrame.size.height -= (currentFrame.size.height - newFrame.size.height);
    [self setAutoresizingMask:CROP_STEP2];
    [((NiceWindow *)[self window]) setFrame:resizingFrame display:YES];
    [self setAutoresizingMask:FINAL_SIZING];
    [((NiceWindow *)[self window]) setAspectRatio:[((NiceWindow *)[self window]) frame].size];
	
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    [NSApp mouseEntered:theEvent];
    mouseEntered = YES;
}

- (void)mouseExited:(NSEvent *)theEvent
{
    [NSApp mouseExited:theEvent];
    mouseEntered = NO;
}

@end
