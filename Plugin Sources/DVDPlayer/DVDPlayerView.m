/**
 * DVDPlayerView.m
 * NicePlayer
 *
 * An implementation of a view for the DVDPlayback API provided by Apple.
 */

#import <DVDPlayback/DVDPlayback.h>
#import <QuickTime/QuickTime.h>
#import <objc/objc-runtime.h>
#import "DVDPlayerView.h"
#import "NiceWindow.h"
#import "NPPluginView.h"
#import "DVDPrefController.h"
#import "NSBookmarkCreateButton.h"
#import <unistd.h>
#import "DVDDispose.h"
#define MAX_DISPLAYS (16)

Rect convertCGRectToQDRect(CGRect inRect) {
	Rect outRect;
	outRect.left = inRect.origin.x;
	outRect.bottom = inRect.origin.y;
	outRect.right = (outRect.left + inRect.size.width);
	outRect.top = (outRect.bottom + inRect.size.height);
	return outRect;
}

Point convertNSPointToQDPoint(NSPoint inPoint, NSRect windowRect){
	Point outPoint;
	outPoint.v = windowRect.size.height - (short)inPoint.y;
	outPoint.h = (short)inPoint.x;
	return outPoint;
}

NSString *stringForLanguageCode(DVDLanguageCode language);
void fatalError(DVDErrorCode inError, UInt32 inRefCon);
void aspectChange(DVDEventCode inEventCode, UInt32 inEventValue1, UInt32 inEventValue2, UInt32 inRefCon);

@implementation DVDPlayerView

/**
 * Each plugin must return a dictionary with the specified attributes. These are displayed in the preferences
 * for the user to see when choosing plugin order and which plugins are enabled.
 */
+(NSDictionary *)plugInfo
{
	NSArray *extensions = [NSArray arrayWithObjects:@"public.folder",@"vdvd", nil];
	return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"DVD Player",	extensions,			nil]
									   forKeys:[NSArray arrayWithObjects:@"Name",		@"FileExtensions",	nil]];	
}

+(BOOL)hasConfigurableNib
{
	return YES;
}

+(id)dvdPrefController
{
	static id prefController = nil;
	if(!prefController)
		prefController = [[DVDPrefController alloc] init];
	
	return prefController;
}

+(id)configureNibView
{
	static id myNib = nil;
	NSArray *tmpArray;
	
	if(!myNib)
		myNib = [[NSNib alloc] initWithNibNamed:@"DVDPrefs" bundle:[NSBundle bundleForClass:[self class]]];
	[myNib instantiateNibWithOwner:[self dvdPrefController] topLevelObjects:&tmpArray];
	id anObject, e;
	e = [tmpArray objectEnumerator];
	while(anObject = [e nextObject]){
		if([anObject isKindOfClass:[NSView class]])
			return anObject;
	}
	return nil;
}



/**
 * Initialize the window, testing to see if the DVD framework is loadable (or has already been loaded by another
 * window or application).
 */
-(id)initWithFrame:(NSRect)frame
{
    static BOOL initialized = NO;
	static id dvdDisposer= nil;
    if(!initialized){
		if(DVDInitialize() < 0)
			return nil;
		initialized = YES;
		dvdDisposer = [[DVDDisposer alloc] init];
		[[NSNotificationCenter defaultCenter] addObserver:dvdDisposer selector:@selector(applicationWillTerminate:) name:NSApplicationWillTerminateNotification object:NSApp];
	}
    if(self = [super initWithFrame:frame]){
	[self setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];			
	[[NSNotificationCenter defaultCenter] addObserver:self 
						 selector:@selector(windowDidMove:) 
						     name:NSWindowDidMoveNotification 
						   object:NULL];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(frameDidChange:) 
												 name:NSViewFrameDidChangeNotification 
											   object:NULL];
	
	[[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self 
														   selector:@selector(systemWillSleep:) 
															   name:NSWorkspaceWillSleepNotification 
															 object:nil];
	
	[[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self 
														   selector:@selector(systemDidWakeUp:) 
															   name:NSWorkspaceDidWakeNotification 
															 object:nil];
	}
    return self;
}

/**
* Update the bounds of the DVD. This generally happens on resize or window move.
 */
-(void)updateBounds
{
    NSRect content = [[[self window] contentView] bounds];
    NSRect frame = [[self window] frame];
    
    /* create an equivalent QuickDraw rectangle with window local coordinates */
    Rect qdRect;
    qdRect.left = 0;
    qdRect.right = content.size.width - 1;
    qdRect.bottom = frame.size.height - 1;
    qdRect.top = frame.size.height - content.size.height;
    
    /* set the video area */
    OSStatus result = DVDSetVideoBounds (&qdRect);
    NSAssert1 (!result, @"DVDSetVideoBounds returned %d", result);
}

-(void)resizeToAspect
{
    [[self window] disableFlushWindow];
    [[self window] setAspectRatio:[self naturalSize]];
    [(NiceWindow *)[self window] resizeToAspectRatio];
    [[self window] enableFlushWindow];

}

/**
 * The aspect ratio has changed, signal the change to the application and resize things properly.
 * isAspectRatioChanging allows our view to detect a resize in progress so that we can make sure that
 * the DVD view is properly sized so as not to allow white patches from showing through during a
 * resize event.
 */
-(void)aspectRatioChanged
{
    [self resizeToAspect];
    [self drawMovieFrame];
}

-(BOOL)canAnimateResize
{
    return NO;
}

/**
* Close the movie by deallocating and disposing the DVD framework.
 */
-(void)close
{
	[updateChapterTimer invalidate];
	DVDUnregisterEventCallBack(cid);
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	DVDStop();
	/* Now DVD player is broken so that we must call close volume, even on a file. */
//	if(openedVolume){
		DVDCloseMediaVolume();
//	} else {
//		DVDCloseMediaFile();
//	}
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self];
	if(myURL)
		[myURL release];
	[super dealloc];
}

/**
* precacheing not availble for dvd;
*/
-(void)precacheURL:(NSURL*)url{}
/**
 * This gets called on open of a file. It returns TRUE if we think that we can open the file.
 */
-(BOOL)openURL:(NSURL *)url
{

	if(([[[[url path] pathExtension] uppercaseString] isEqualToString:@"VOB"])
	 || ([[[url path] lastPathComponent] isEqualToString:@"VIDEO_TS"])){
		myURL = url;
	} else {
		NSString *sub_videots = [[url path] stringByAppendingPathComponent:@"VIDEO_TS"];
		BOOL isDir;
		if([[NSFileManager defaultManager] fileExistsAtPath:sub_videots isDirectory:&isDir] && isDir)
			myURL = [NSURL fileURLWithPath:sub_videots];
		else {
			return NO;
		}
	}
	
	[myURL retain];
	return YES;
}

/**
 * Set up all of the proper DVD playback stuff.
 */
-(BOOL)loadMovie
{
	DVDSetVideoWindowID([[self window] windowNumber]);	
	
	[self setVideoDisplay];
	[self updateBounds];
	
	DVDSetFatalErrorCallBack(fatalError, (UInt32)self);
	DVDEventCode eventCodes[] = { kDVDEventDisplayMode, kDVDEventTitle, kDVDEventVideoStandard };
	DVDRegisterEventCallBack(aspectChange, eventCodes, sizeof(eventCodes)/sizeof(DVDEventCode), (UInt32)self, &cid);
	FSRef fsref;
	CFURLGetFSRef((CFURLRef)myURL, &fsref);

	DVDOpenMediaFile(&fsref);
	
	updateChapterTimer = [NSTimer scheduledTimerWithTimeInterval:30
							      target:self
							    selector:@selector(rebuildMenuTimer)
							    userInfo:nil
							     repeats:YES];
	return YES;
}

/**
 * All key down events with shift being pressed are passed down to us, as well as all other non 
 * handled key commands. It's not reliable to assume that a key press is going to be passed down to us,
 * since the host program is allowed by protocol to use any key command EXCEPT those that have the
 * shift key being pressed down.
 */
-(void)keyDown:(NSEvent *)anEvent
{
	NSString *s = [anEvent charactersIgnoringModifiers];
	unichar c = [s characterAtIndex:0];
	Boolean onMenu;
	DVDMenu whichMenu;
	DVDIsOnMenu(&onMenu, &whichMenu);
	/* This handles keyboard nav for DVD Menu support and such */
	if(onMenu && ([anEvent modifierFlags] & NSShiftKeyMask)){
		DVDUserNavigation inNavigation;
		switch (c) {
			case NSUpArrowFunctionKey:
				inNavigation = kDVDUserNavigationMoveUp;
				break;
			case NSDownArrowFunctionKey:
				inNavigation = kDVDUserNavigationMoveDown;
				break;
			case NSLeftArrowFunctionKey:
				inNavigation = kDVDUserNavigationMoveLeft;
				break;
			case NSRightArrowFunctionKey:
				inNavigation = kDVDUserNavigationMoveRight;
				break;
			case 0x3: case 0xD:
				inNavigation = kDVDUserNavigationEnter;
				break;
			case 0x4D:
				inNavigation = 0;
				[self gotoMainMenu];
				break;
			default:
				return;
		}
		DVDDoUserNavigation(inNavigation);
		return;
	}
	
	if(!onMenu && ([anEvent modifierFlags] & NSShiftKeyMask)){
		switch (c) {
			case NSLeftArrowFunctionKey:
			case 0x3: case 0xD:
				[self previousChapter];
				return;
			case NSRightArrowFunctionKey:
				[self nextChapter];
				return;
			default:
				break;
		}
	}
}

-(void)keyUp:(NSEvent *)anEvent
{
}

-(void)mouseDown:(NSEvent *)anEvent
{
	SInt32 pointIndex;
	if([anEvent type] == NSLeftMouseDown){
		Point point = convertNSPointToQDPoint([anEvent locationInWindow], [self frame]);
		DVDDoMenuClick(point, &pointIndex);
	}
}

-(void)mouseMoved:(NSEvent *)anEvent
{
	SInt32 pointIndex;
	Point point = convertNSPointToQDPoint([anEvent locationInWindow], [self frame]);
	DVDDoMenuMouseOver(point, &pointIndex);
}

-(void)drawMovieFrame
{
    DVDUpdateVideo();
}

- (float) titleAspectRatio
{
    const float kStandardRatio = 4.0 / 3.0;
    const float kWideRatio = 16.0 / 9.0;
    float ratio = kStandardRatio;
    
    DVDAspectRatio format = kDVDAspectRatioUninitialized;
    DVDGetAspectRatio (&format);
    
    switch (format) {
	case kDVDAspectRatio4x3:
	case kDVDAspectRatio4x3PanAndScan:
	case kDVDAspectRatioUninitialized:
	    ratio = kStandardRatio;
	    break;
	case kDVDAspectRatio16x9:
	case kDVDAspectRatioLetterBox:
	    ratio = kWideRatio;
	    break;
    }
    
    return ratio;
}

/**
 * Returns the aspect ratio.
 */
-(NSSize)naturalSize
{
    /* get the native height and width of the media */
    UInt16 width = 720, height = 480;
    DVDGetNativeVideoSize(&width, &height);
    
    NSSize size;
    size.height = height;
    /* adjust the width using the current aspect ratio */
    size.width = size.height * [self titleAspectRatio];
    
    return size;
}

-(void)setLoopMode:(NSQTMovieLoopMode)flag
{
}

#pragma mark Volume

-(BOOL)muted
{
	Boolean isp;
	DVDIsMuted(&isp);
	return isp;
}

-(void)setMuted:(BOOL)aBOOL
{
	DVDMute(aBOOL);
}

-(float)volume
{
	UInt16 vol;
	DVDGetAudioVolume(&vol);
	return (((float)vol) / 255.0) * 2.0;
}

-(void)setVolume:(float)aVolume
{
	DVDSetAudioVolume((UInt16)((aVolume/2.0) * 255.0));
}

-(void)drawRect:(NSRect)aRect
{
}

#pragma mark -
#pragma mark Controls

-(BOOL)isPlaying
{
	Boolean isp;
	DVDIsPlaying(&isp);
	if(isp){
		DVDIsPaused(&isp);
		if(!isp)
			return YES;
	}
	return NO;
}

-(void)start
{
	Boolean isp;
	DVDIsPaused(&isp);
	if(isp)
		DVDResume();
	else {
		DVDPlay();
		[[NSNotificationCenter defaultCenter] postNotificationName:@"RebuildAllMenus" object:self];
	}
}

-(void)stop
{
	DVDPause();
}

-(void)previousChapter
{
	BOOL wasPlaying = [self isPlaying];
    DVDPreviousChapter();
	if(wasPlaying)
		DVDPlay();
	else
		[self drawMovieFrame];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RebuildAllMenus" object:self];
}

-(void)nextChapter
{
    DVDNextChapter();
	[self drawMovieFrame];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RebuildAllMenus" object:self];
}

/**
 * The fast-forward/rewind set of methods looks overly complicated, but is in fact perfect for allowing
 * various types of fast forward and rewind approaches to be handled: ones that toggle, ones that operate
 * on a per invocation basis, etc. It also allows views to pause play back on initiation of fast-forward
 * and rewind and to unpause on finishing, in case the decoding cannot happen fast enough to allow for
 * playback during fast-forward and rewind.
 */
-(void)ffStart:(int)seconds
{
	[super ffStart:seconds];
	DVDScan(seconds, kDVDScanDirectionForward);
}

-(void)ffDo:(int)seconds
{
}

-(void)ffEnd
{
	[super ffEnd];
}

-(void)rrStart:(int)seconds
{
	[super ffStart:seconds];
	DVDScan(seconds, kDVDScanDirectionBackward);
}

-(void)rrDo:(int)seconds
{
}

-(void)rrEnd
{
	[super rrEnd];
}

-(void)stepBackward
{
	//DVDStepFrame(kDVDScanDirectionBackward);
}

-(void)stepForward
{
	DVDStepFrame(kDVDScanDirectionForward);
}

-(BOOL)hasEnded:(id)sender
{
	return NO;
}

#pragma mark -
#pragma mark Calculations


-(double)currentMovieFrameRate{
    DVDFormat outFormat;
    DVDGetFormatStandard(&outFormat);
    if(outFormat == kDVDFormatPAL)
        return 25.0;
    else
        return 29.97;
}

-(double)totalTime
{
    DVDTimePosition outTime;
	UInt16 outFrames;
	
	DVDGetTime(kDVDTimeCodeTitleDurationSeconds, &outTime, &outFrames);
	return (double)outTime + (outFrames/[self currentMovieFrameRate]);
}

-(double)currentMovieTime
{
	DVDTimePosition outTime;
	UInt16 outFrames;
	
	DVDGetTime(kDVDTimeCodeElapsedSeconds, &outTime, &outFrames);
	return (double)outTime + (outFrames/[self currentMovieFrameRate]);
}

-(void)setCurrentMovieTime:(double)newMovieTime
{
	Boolean isp;
	DVDIsPaused(&isp);
	DVDSetTime(kDVDTimeCodeElapsedSeconds, (long)newMovieTime, 0);
	if(isp)
		DVDPause();
	else
		DVDResume();
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RebuildAllMenus" object:self];
}

-(void)hideSubPictures
{
	DVDDisplaySubPicture(NO);
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RebuildAllMenus" object:self];
}

#pragma mark -
#pragma mark Menus

-(id)menuPrefix
{
	return @"DVD";
}

-(id)menuTitle
{
	NSString *file = [[[[myURL absoluteString] stringByDeletingLastPathComponent] lastPathComponent] stringByDeletingPathExtension];
	file = (NSString *)CFURLCreateStringByReplacingPercentEscapes(NULL, (CFStringRef)file, (CFStringRef)@"");
	return [file autorelease];
}

-(id)pluginMenu
{
	id pluginMenu = [[NSMutableArray array] retain];
	id newItem;
	Boolean isp;
	
	newItem = [[[NSMenuItem alloc] initWithTitle:@"Main Menu"
										  action:@selector(gotoMainMenu)
								   keyEquivalent:@""] autorelease];
	[newItem setTarget:self];
	[pluginMenu addObject:newItem];
	
	newItem = [[[NSMenuItem alloc] initWithTitle:@"Audio Menu"
										  action:@selector(gotoAudioMenu)
								   keyEquivalent:@""] autorelease];
	[newItem setTarget:self];
	[pluginMenu addObject:newItem];

	newItem = [[[NSMenuItem alloc] initWithTitle:@"Return to Title"
										  action:@selector(returnToTitle)
								   keyEquivalent:@""] autorelease];
	DVDMenu tmp;
	DVDIsOnMenu(&isp, &tmp);
	if(isp)
		[newItem setEnabled:YES];
	else
		[newItem setEnabled:NO];
	[newItem setTarget:self];
	[pluginMenu addObject:newItem];
	
	newItem = [[[NSMenuItem alloc] initWithTitle:@"Title"
										  action:nil
								   keyEquivalent:@""] autorelease];
	[newItem setSubmenu:[self titleMenu]];
	[pluginMenu addObject:newItem];
	
	newItem = [[[NSMenuItem alloc] initWithTitle:@"Chapter"
										  action:nil
								   keyEquivalent:@""] autorelease];
	[newItem setSubmenu:[self chapterMenu]];	
	[pluginMenu addObject:newItem];
	
	newItem = [[[NSMenuItem alloc] initWithTitle:@"Audio"
										  action:nil
								   keyEquivalent:@""] autorelease];
	[newItem setSubmenu:[self audioMenu]];	
	[pluginMenu addObject:newItem];

	newItem = [[[NSMenuItem alloc] initWithTitle:@"Subtitles"
										  action:nil
								   keyEquivalent:@""] autorelease];
	[newItem setSubmenu:[self subPictureMenu]];	
	[pluginMenu addObject:newItem];

	newItem = [[[NSMenuItem alloc] initWithTitle:@"Angle"
										  action:nil
								   keyEquivalent:@""] autorelease];
	[newItem setSubmenu:[self angleMenu]];
	
	[pluginMenu addObject:[NSMenuItem separatorItem]];
	
/*	newItem = [[[NSMenuItem alloc] initWithTitle:@"Bookmarks"
										  action:nil
								   keyEquivalent:@""] autorelease];
	[newItem setSubmenu:[self bookmarksMenu]];*/
	[pluginMenu addObject:newItem];
	
	return [pluginMenu autorelease];
}

-(id)titleMenu
{
	id titleMenu = [[NSMenu alloc] initWithTitle:@"Title Menu"];
	id newItem;
	unsigned short i;
	unsigned short current;
	unsigned short titles;
	
	DVDGetNumTitles(&titles);
	DVDGetTitle(&current);
	for(i = 1; i < (titles + 1); i++){
		newItem = [[[NSMenuItem alloc] initWithTitle:[[NSNumber numberWithUnsignedInt:i] stringValue]
											  action:@selector(gotoTitle:)
									   keyEquivalent:@""] autorelease];
		[newItem setTarget:self];
		[newItem setTag:i];
		if(i == current)
			[newItem setState:NSOnState];
		else
			[newItem setState:NSOffState];
		[titleMenu addItem:newItem];
	}
	
	return [titleMenu autorelease];
}



-(NSArray*)_chapters{
	unsigned short titleNum;
	unsigned short chapters;
		unsigned short i;

	DVDGetTitle(&titleNum);
	DVDGetNumChapters(titleNum, &chapters);

	NSMutableArray* tMutArray = [NSMutableArray array];
	for(i = 1; i < (chapters + 1); i++){
		[tMutArray addObject:[NSString stringWithFormat:@"Chapter %@",[NSNumber numberWithUnsignedInt:i],nil]];
	}
	return tMutArray;
}
-(NSString*)_currentChapter{
	unsigned short current;

	DVDGetChapter(&current);
	return [[self _chapters] objectAtIndex:current];
}

-(id)chapterMenu
{
	id chapterMenu = [[NSMenu alloc] initWithTitle:@"Chapter Menu"];
	id newItem;
	unsigned short titleNum;
	unsigned short chapters;
	unsigned short current;
	unsigned short i;
	
	DVDGetTitle(&titleNum);
	DVDGetNumChapters(titleNum, &chapters);
	DVDGetChapter(&current);
	for(i = 1; i < (chapters + 1); i++){
		newItem = [[[NSMenuItem alloc] initWithTitle:[[NSNumber numberWithUnsignedInt:i] stringValue]
											  action:@selector(gotoChapter:)
									   keyEquivalent:@""] autorelease];
		[newItem setTarget:self];
		[newItem setTag:i];
		if(i == current)
			[newItem setState:NSOnState];
		else
			[newItem setState:NSOffState];
		[chapterMenu addItem:newItem];
	}
		
	return [chapterMenu autorelease];
}
-(id)audioMenu
{
	id audioMenu = [[NSMenu alloc] initWithTitle:@"Audio Menu"];
	id newItem;
	unsigned short audios;
	unsigned short current;
	unsigned short i;
	
	DVDGetNumAudioStreams(&audios);
	DVDGetAudioStream(&current);
	for(i = 1; i < (audios + 1); i++){
		NSString *label;
		DVDLanguageCode lCode;
		DVDSubpictureExtensionCode eCode;
		DVDGetAudioLanguageCodeByStream(i, &lCode, &eCode);
		label = stringForLanguageCode(lCode);
		switch(eCode){
			case kDVDAudioExtensionCodeDirectorsComment1:
			    label = [label stringByAppendingString:@" / Director's Commentary"];
			    break;
			case kDVDAudioExtensionCodeDirectorsComment2:
			    label = [label stringByAppendingString:@" / Director's Second Commentary"];
			    break;
		}
		newItem = [[[NSMenuItem alloc] initWithTitle:label
											  action:@selector(selectAudio:)
									   keyEquivalent:@""] autorelease];
		[newItem setTarget:self];
		[newItem setTag:i];
		if(i == current)
			[newItem setState:NSOnState];
		else
			[newItem setState:NSOffState];
		[audioMenu addItem:newItem];
	}
	
	return [audioMenu autorelease];
}

-(id)angleMenu
{
	id angleMenu = [[NSMenu alloc] initWithTitle:@"Angle Menu"];
	id newItem;
	unsigned short angles;
	unsigned short current;
	unsigned short i;
	
	DVDGetNumAngles(&angles);
	DVDGetAngle(&current);
	for(i = 1; i < (angles + 1); i++){
		newItem = [[[NSMenuItem alloc] initWithTitle:[[NSNumber numberWithUnsignedInt:i] stringValue]
											  action:@selector(selectAngle:)
									   keyEquivalent:@""] autorelease];
		[newItem setTarget:self];
		[newItem setTag:i];
		if(i == current)
			[newItem setState:NSOnState];
		else
			[newItem setState:NSOffState];
		[angleMenu addItem:newItem];
	}
	
	return [angleMenu autorelease];
}

-(id)subPictureMenu
{
	id subPicturesMenu = [[NSMenu alloc] initWithTitle:@"Subtitles Menu"];
	id newItem;
	unsigned short subs;
	unsigned short current;
	unsigned short i;
	Boolean isp;
	
	DVDGetNumSubPictureStreams(&subs);
	DVDGetSubPictureStream(&current);
	
	newItem = [[[NSMenuItem alloc] initWithTitle:@"Hide Subtitles"
										  action:@selector(hideSubPictures)
								   keyEquivalent:@""] autorelease];
	DVDIsDisplayingSubPicture(&isp);
	if(isp)
		[newItem setState:NSOffState];
	else
		[newItem setState:NSOnState];
	[newItem setTarget:self];
	[subPicturesMenu addItem:newItem];
	[subPicturesMenu addItem:[NSMenuItem separatorItem]];
	
	for(i = 1; i < (subs + 1); i++){
		NSString *label;
		DVDLanguageCode lCode;
		DVDSubpictureExtensionCode eCode;
		DVDGetSubPictureLanguageCodeByStream(i, &lCode, &eCode);
		label = stringForLanguageCode(lCode);
		newItem = [[[NSMenuItem alloc] initWithTitle:label
											  action:@selector(selectSubPicture:)
									   keyEquivalent:@""] autorelease];
		[newItem setTarget:self];
		[newItem setTag:i];
		DVDIsDisplayingSubPicture(&isp);
		if((i == current) && isp)
			[newItem setState:NSOnState];
		else
			[newItem setState:NSOffState];
		[subPicturesMenu addItem:newItem];
	}
	
	return [subPicturesMenu autorelease];
}

#pragma mark -
#pragma mark Wrapper Methods

-(void)gotoMainMenu
{
	Boolean isOnMenu;
	DVDMenu onThisMenu;

	DVDIsOnMenu(&isOnMenu, &onThisMenu);
	if(!(isOnMenu && (onThisMenu == kDVDMenuRoot)))
		DVDGoToMenu(kDVDMenuRoot);				
}

-(void)gotoAudioMenu
{
	Boolean isOnMenu;
	DVDMenu onThisMenu;
	
	DVDIsOnMenu(&isOnMenu, &onThisMenu);
	if(!(isOnMenu && (onThisMenu == kDVDMenuAudio)))
		DVDGoToMenu(kDVDMenuAudio);				
}

-(void)returnToTitle
{
	DVDReturnToTitle();
}

-(void)gotoTitle:(id)anObject
{
	Boolean isp;
	DVDIsPaused(&isp);
	DVDSetTitle([anObject tag]);
	if(isp)
		DVDPause();
	else
		DVDResume();
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RebuildAllMenus" object:self];
}



-(void)_gotoChapter:(NSNumber*)anIndex{
		Boolean isp;
	DVDIsPaused(&isp);
	DVDSetChapter([anIndex unsignedShortValue]);
	if(isp)
		DVDPause();
	else
		DVDResume();
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RebuildAllMenus" object:self];
}



-(void)gotoChapter:(id)anObject
{
	[self _gotoChapter:[NSNumber numberWithInt:[anObject tag]]];
}

-(void)selectAudio:(id)anObject
{
	Boolean isp;
	DVDIsPaused(&isp);
	DVDSetAudioStream([anObject tag]);
	if(isp)
		DVDPause();
	else
		DVDResume();
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RebuildAllMenus" object:self];
}

-(void)DVDSetAngle:(id)anObject
{
	Boolean isp;
	DVDIsPaused(&isp);
	DVDSetAngle([anObject tag]);
	if(isp)
		DVDPause();
	else
		DVDResume();
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RebuildAllMenus" object:self];
}

-(void)selectSubPicture:(id)anObject
{
	Boolean isp;
	DVDIsPaused(&isp);
	DVDDisplaySubPicture(YES);
	DVDSetSubPictureStream([anObject tag]);
	if(isp)
		DVDPause();
	else
		DVDResume();
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RebuildAllMenus" object:self];
}

-(void)rebuildMenuTimer
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RebuildAllMenus" object:self];
}

#pragma mark -
#pragma mark Bookmarks

-(id)bookmarksMenu
{
	id bookmarksMenu = [[NSMenu alloc] initWithTitle:@"Bookmarks Menu"];
	id newItem;
	NSArray *bookmarks = [self bookmarksForCurrentDisc];
	unsigned short i = 0;
	
	newItem = [[[NSMenuItem alloc] initWithTitle:@"Add Bookmark"
										  action:@selector(setBookmarkForCurrentDisc:)
								   keyEquivalent:@""] autorelease];
	[newItem setTarget:self];
	[newItem setTag:i];
	[bookmarksMenu addItem:newItem];
	newItem = [[[NSMenuItem alloc] initWithTitle:@"Remove Bookmark..."
										  action:@selector(setBookmarkForCurrentDisc:)
								   keyEquivalent:@""] autorelease];
	[newItem setTarget:self];
	[newItem setTag:i];
	[bookmarksMenu addItem:newItem];
	[bookmarksMenu addItem:[NSMenuItem separatorItem]];

	for(i = 0; i < [bookmarks count]; i++){
		newItem = [[[NSMenuItem alloc] initWithTitle:[bookmarks objectAtIndex:i]
											  action:@selector(bookmarksForCurrentDiscAndName:)
									   keyEquivalent:@""] autorelease];
		[newItem setTarget:self];
		[newItem setTag:i];
		[bookmarksMenu addItem:newItem];
	}
	
	return [bookmarksMenu autorelease];
}

-(id)bookmarksForCurrentDisc
{
	DVDDiscID outDiscID;
	DVDGetMediaUniqueID(outDiscID);
	return [[[self class] dvdPrefController] bookmarksForDisc:[NSString stringWithCharacters:(unichar *)&outDiscID length:8]];
}

-(id)bookmarksForCurrentDiscAndName:(id)sender
{
	DVDDiscID outDiscID;
	DVDGetMediaUniqueID(outDiscID);
	[[[self class] dvdPrefController] bookmarkDataFromName:[sender stringValue]
						       forDisc:[NSString stringWithCharacters:(unichar *)outDiscID length:8]];
	return nil;
}

-(void)setBookmarkForCurrentDisc:(id)sender
{
	static id myNib = nil;
	NSArray *tmpArray;

	if(!myNib)
		myNib = [[NSNib alloc] initWithNibNamed:@"BookmarkEntry" bundle:[NSBundle bundleForClass:[self class]]];
	[myNib instantiateNibWithOwner:self topLevelObjects:&tmpArray];
	id anObject, e;
	e = [tmpArray objectEnumerator];
	while(anObject = [e nextObject]){
		if([anObject isKindOfClass:[NSWindow class]]){
			[anObject makeKeyAndOrderFront:self];
			[anObject setLevel:NSFloatingWindowLevel + 5];
		}
	}
}

-(IBAction)setBookmarkForCurrentDiscWithNameField:(NSBookmarkCreateButton *)sender
{
	[[sender window] close];

	DVDDiscID outDiscID;
	DVDGetMediaUniqueID(outDiscID);

	void *data = nil;
	UInt32 length;
	
	DVDGetBookmark(data, &length);
		
	[[[self class] dvdPrefController] setBookmark:[NSData dataWithBytes:data length:length]
					     withName:[sender entryText]
					      forDisc:[NSString stringWithCharacters:(unichar *)outDiscID length:8]];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RebuildAllMenus" object:self];
}

- (void) setVideoDisplay 
{
    static CGDirectDisplayID curDisplay = 0;
    
    /* get the ID of the display that contains the largest part of the window */
    CGDirectDisplayID newDisplay = (CGDirectDisplayID) 
	[[[[[self window] screen] deviceDescription] valueForKey:@"NSScreenNumber"] intValue];
    
    /* if the display has changed, set the new display */
    if (newDisplay != curDisplay) {
	Boolean isSupported = FALSE;
	OSStatus result = DVDSwitchToDisplay (newDisplay, &isSupported);
	NSAssert1 (!result, @"DVDSwitchToDisplay returned %d", result);
	
	if (isSupported) { 
	    curDisplay = newDisplay;
	}
	else {
	    NSLog(@"video display %d not supported", newDisplay);
	}
    }
}

#pragma mark NSWindow notifications

- (void) frameDidChange:(NSNotification *)notification 
{
    if ([notification object] == [self superview]) {
	[self updateBounds];
    }
}

- (void) windowDidMove:(NSNotification *)notification 
{
    if ([notification object] == [self window]) 
	[self setVideoDisplay];
}

-(void)systemWillSleep:(NSNotification *)notification
{
	DVDPause();
	DVDSleep();
}

-(void)systemDidWakeUp:(NSNotification *)notification
{
	DVDWakeUp();
}

@end


NSString *stringForLanguageCodeTenThree(DVDLanguageCode language)
{
    switch(language){
	case kDVDLanguageCodeNone:
	    return [NSString stringWithUTF8String:"None"];
	case kDVDLanguageCodeAfar:
	    return [NSString stringWithUTF8String:"Afar"];
	case kDVDLanguageCodeAbkhazian:
	    return [NSString stringWithUTF8String:"Абхазо"];
	case kDVDLanguageCodeAfrikaans:
	    return [NSString stringWithUTF8String:"Afrikaans"];
	case kDVDLanguageCodeAmharic:
	    return [NSString stringWithUTF8String:"አማርኛ"];
	case kDVDLanguageCodeArabic:
	    return [NSString stringWithUTF8String:"العربية"];
	case kDVDLanguageCodeAssamese:
	    return [NSString stringWithUTF8String:"অসিময়া"];
	case kDVDLanguageCodeAymara:
	    return [NSString stringWithUTF8String:"Aymará"];
	case kDVDLanguageCodeAzerbaijani:
	    return [NSString stringWithUTF8String:"Azərbaycani"];
	case kDVDLanguageCodeBashkir:
	    return [NSString stringWithUTF8String:"башҡортса"];
	case kDVDLanguageCodeByelorussian:
	    return [NSString stringWithUTF8String:"Беларуски"];
	case kDVDLanguageCodeBulgarian:
	    return [NSString stringWithUTF8String:"Български"];
	case kDVDLanguageCodeBihari:
	    return [NSString stringWithUTF8String:"Bihari"];
	case kDVDLanguageCodeBislama:
	    return [NSString stringWithUTF8String:"Bislama"];
	case kDVDLanguageCodeBengali:
	    return [NSString stringWithUTF8String:"বাংলা"];
	case kDVDLanguageCodeTibetan:
	    return [NSString stringWithUTF8String:"བོད་སྐད་"];
	case kDVDLanguageCodeBreton:
	    return [NSString stringWithUTF8String:"Brezhoneg"];
	case kDVDLanguageCodeCatalan:
	    return [NSString stringWithUTF8String:"Català"];
	case kDVDLanguageCodeCorsican:
	    return [NSString stringWithUTF8String:"Corsu"];
	case kDVDLanguageCodeCzech:
	    return [NSString stringWithUTF8String:"Čeština"];
	case kDVDLanguageCodeWelsh:
	    return [NSString stringWithUTF8String:"Cymraeg"];
	case kDVDLanguageCodeDanish:
	    return [NSString stringWithUTF8String:"Dansk"];
	case kDVDLanguageCodeGerman:
	    return [NSString stringWithUTF8String:"Deutsch"];
	case kDVDLanguageCodeBhutani:
	    return [NSString stringWithUTF8String:"Bhutani"];
	case kDVDLanguageCodeGreek:
	    return [NSString stringWithUTF8String:"Ελληνικά"];
	case kDVDLanguageCodeEnglish:
	    return [NSString stringWithUTF8String:"English"];
	case kDVDLanguageCodeEsperanto:
	    return [NSString stringWithUTF8String:"Esperanto"];
	case kDVDLanguageCodeSpanish:
	    return [NSString stringWithUTF8String:"Español"];
	case kDVDLanguageCodeEstonian:
	    return [NSString stringWithUTF8String:"Eesti"];
	case kDVDLanguageCodeBasque:
	    return [NSString stringWithUTF8String:"Euskara"];
	case kDVDLanguageCodePersian:
	    return [NSString stringWithUTF8String:"دری"];
	case kDVDLanguageCodeFinnish:
	    return [NSString stringWithUTF8String:"Suomi"];
	case kDVDLanguageCodeFiji:
	    return [NSString stringWithUTF8String:"Vakaviti"];
	case kDVDLanguageCodeFaeroese:
	    return [NSString stringWithUTF8String:"Føroyskt"];
	case kDVDLanguageCodeFrench:
	    return [NSString stringWithUTF8String:"Français"];
	case kDVDLanguageCodeFrisian:
	    return [NSString stringWithUTF8String:"Frysk"];
	case kDVDLanguageCodeIrish:
	    return [NSString stringWithUTF8String:"Gaeilge"];
	case kDVDLanguageCodeScotsGaelic:
	    return [NSString stringWithUTF8String:"Gàidhlig"];
	case kDVDLanguageCodeGalician:
	    return [NSString stringWithUTF8String:"Galego"];
	case kDVDLanguageCodeGuarani:
	    return [NSString stringWithUTF8String:"Ava ñe'ê"];
	case kDVDLanguageCodeGujarati:
	    return [NSString stringWithUTF8String:"ગુજરાતી"];
	case kDVDLanguageCodeHausa:
	    return [NSString stringWithUTF8String:"هَوُسَ"];
	case kDVDLanguageCodeHindi:
	    return [NSString stringWithUTF8String:"हिनदी"];
	case kDVDLanguageCodeCroatian:
	    return [NSString stringWithUTF8String:"Hrvatski"];
	case kDVDLanguageCodeHungarian:
	    return [NSString stringWithUTF8String:"Magyar"];
	case kDVDLanguageCodeArmenian:
	    return [NSString stringWithUTF8String:"Հայերէն"];
	case kDVDLanguageCodeInterlingua:
	    return [NSString stringWithUTF8String:"Interlingua"];
	case kDVDLanguageCodeInterlingue:
	    return [NSString stringWithUTF8String:"Interlingue"];
	case kDVDLanguageCodeInupiak:
	    return [NSString stringWithUTF8String:"Ieupiatun"];
	case kDVDLanguageCodeIndonesian:
	    return [NSString stringWithUTF8String:"Bahasa Indonesia"];
	case kDVDLanguageCodeIcelandic:
	    return [NSString stringWithUTF8String:"Íslenska"];
	case kDVDLanguageCodeItalian:
	    return [NSString stringWithUTF8String:"Italiano"];
	case kDVDLanguageCodeHebrew:
	    return [NSString stringWithUTF8String:"עברית"];
	case kDVDLanguageCodeJapanese:
	    return [NSString stringWithUTF8String:"日本語"];
	case kDVDLanguageCodeYiddish:
	    return [NSString stringWithUTF8String:"ייִדיש"];
	case kDVDLanguageCodeJavanese:
	    return [NSString stringWithUTF8String:"Javanese"];
	case kDVDLanguageCodeGeorgian:
	    return [NSString stringWithUTF8String:"ქართული"];
	case kDVDLanguageCodeKazakh:
	    return [NSString stringWithUTF8String:"Қазақ"];
	case kDVDLanguageCodeGreenlandic:
	    return [NSString stringWithUTF8String:"Greenlandic"];
	case kDVDLanguageCodeCambodian:
	    return [NSString stringWithUTF8String:"Cambodian"];
	case kDVDLanguageCodeKannada:
	    return [NSString stringWithUTF8String:"^ನ^ಡ"];
	case kDVDLanguageCodeKorean:
	    return [NSString stringWithUTF8String:"한국어"];
	case kDVDLanguageCodeKashmiri:
	    return [NSString stringWithUTF8String:"कश्मीरी"];
	case kDVDLanguageCodeKurdish:
	    return [NSString stringWithUTF8String:"kurmancî"];
	case kDVDLanguageCodeKirghiz:
	    return [NSString stringWithUTF8String:"Кыргыз"];
	case kDVDLanguageCodeLatin:
	    return [NSString stringWithUTF8String:"Lingua Latina"];
	case kDVDLanguageCodeLingala:
	    return [NSString stringWithUTF8String:"Lingala"];
	case kDVDLanguageCodeLaothian:
	    return [NSString stringWithUTF8String:"ລາວ"];
	case kDVDLanguageCodeLithuanian:
	    return [NSString stringWithUTF8String:"Lietuviškai"];
	case kDVDLanguageCodeLatvian:
	    return [NSString stringWithUTF8String:"Latviešu"];
	case kDVDLanguageCodeMalagasy:
	    return [NSString stringWithUTF8String:"Malagasy"];
	case kDVDLanguageCodeMaori:
	    return [NSString stringWithUTF8String:"te reo Māori"];
	case kDVDLanguageCodeMacedonian:
	    return [NSString stringWithUTF8String:"Македонски"];
	case kDVDLanguageCodeMalayalam:
	    return [NSString stringWithUTF8String:"മലയാളം"];
	case kDVDLanguageCodeMongolian:
	    return [NSString stringWithUTF8String:"ᠮᠣᠨᠬᠣᠣᠷ"];
	case kDVDLanguageCodeMoldavian:
	    return [NSString stringWithUTF8String:"Moldoveneşte"];
	case kDVDLanguageCodeMarathi:
	    return [NSString stringWithUTF8String:"मराठी"];
	case kDVDLanguageCodeMalay:
	    return [NSString stringWithUTF8String:"Bahasa Melayu"];
	case kDVDLanguageCodeMaltese:
	    return [NSString stringWithUTF8String:"bil-Malti"];
	case kDVDLanguageCodeBurmese:
	    return [NSString stringWithUTF8String:"မ္ရန္မာ"];
	case kDVDLanguageCodeNauru:
	    return [NSString stringWithUTF8String:"Nauru"];
	case kDVDLanguageCodeNepali:
	    return [NSString stringWithUTF8String:"नेपाली"];
	case kDVDLanguageCodeDutch:
	    return [NSString stringWithUTF8String:"Nederlands"];
	case kDVDLanguageCodeNorwegian:
	    return [NSString stringWithUTF8String:"Nynorsk"];
	case kDVDLanguageCodeOccitan:
	    return [NSString stringWithUTF8String:"Occitan"];
	case kDVDLanguageCodeOromo:
	    return [NSString stringWithUTF8String:"Oromoo"];
	case kDVDLanguageCodeOriya:
	    return [NSString stringWithUTF8String:"ଓଡ଼ିଆ"];
	case kDVDLanguageCodePunjabi:
	    return [NSString stringWithUTF8String:"ਪੰਜਾਬੀ"];
	case kDVDLanguageCodePolish:
	    return [NSString stringWithUTF8String:"Polski"];
	case kDVDLanguageCodePashto:
	    return [NSString stringWithUTF8String:"پښتو"];
	case kDVDLanguageCodePortugese:
	    return [NSString stringWithUTF8String:"Português"];
	case kDVDLanguageCodeQuechua:
	    return [NSString stringWithUTF8String:"Quechua"];
	case kDVDLanguageCodeRhaetoRomance:
	    return [NSString stringWithUTF8String:"Rumantsch"];
	case kDVDLanguageCodeKirundi:
	    return [NSString stringWithUTF8String:"kiRundi"];
	case kDVDLanguageCodeRomanian:
	    return [NSString stringWithUTF8String:"Româneşte"];
	case kDVDLanguageCodeRussian:
	    return [NSString stringWithUTF8String:"Русский"];
	case kDVDLanguageCodeKinyarwanda:
	    return [NSString stringWithUTF8String:"kinyaRwanda"];
	case kDVDLanguageCodeSanskrit:
	    return [NSString stringWithUTF8String:"संस्कृत"];
	case kDVDLanguageCodeSindhi:
	    return [NSString stringWithUTF8String:"سنڗي"];
	case kDVDLanguageCodeSangro:
	    return [NSString stringWithUTF8String:"Sangro"];
	case kDVDLanguageCodeSerboCroatian:
	    return [NSString stringWithUTF8String:"Hrvatski"];
	case kDVDLanguageCodeSinghalese:
	    return [NSString stringWithUTF8String:"ම඿඲ඹල"];
	case kDVDLanguageCodeSlovak:
	    return [NSString stringWithUTF8String:"Slovenčina"];
	case kDVDLanguageCodeSlovenian:
	    return [NSString stringWithUTF8String:"Slovenščina"];
	case kDVDLanguageCodeSamoan:
	    return [NSString stringWithUTF8String:"le gagana Samoa"];
	case kDVDLanguageCodeShona:
	    return [NSString stringWithUTF8String:"chiShona"];
	case kDVDLanguageCodeSomali:
	    return [NSString stringWithUTF8String:"Soomaali"];
	case kDVDLanguageCodeAlbanian:
	    return [NSString stringWithUTF8String:"Shqipe"];
	case kDVDLanguageCodeSerbian:
	    return [NSString stringWithUTF8String:"Српски"];
	case kDVDLanguageCodeSiswati:
	    return [NSString stringWithUTF8String:"siSwati"];
	case kDVDLanguageCodeSesotho:
	    return [NSString stringWithUTF8String:"seSotho"];
	case kDVDLanguageCodeSudanese:
	    return [NSString stringWithUTF8String:"Sudanese"];
	case kDVDLanguageCodeSwedish:
	    return [NSString stringWithUTF8String:"Svenska"];
	case kDVDLanguageCodeSwahili:
	    return [NSString stringWithUTF8String:"kiSwahili"];
	case kDVDLanguageCodeTamil:
	    return [NSString stringWithUTF8String:"தமிழ்"];
	case kDVDLanguageCodeTelugu:
	    return [NSString stringWithUTF8String:"తెలుగు"];
	case kDVDLanguageCodeTajik:
	    return [NSString stringWithUTF8String:"Таҷикй"];
	case kDVDLanguageCodeThai:
	    return [NSString stringWithUTF8String:"ไทย"];
	case kDVDLanguageCodeTigrinya:
	    return [NSString stringWithUTF8String:"ትግርኛ"];
	case kDVDLanguageCodeTurkmen:
	    return [NSString stringWithUTF8String:"türkmençe"];
	case kDVDLanguageCodeTagalog:
	    return [NSString stringWithUTF8String:"Tagalog"];
	case kDVDLanguageCodeSetswana:
	    return [NSString stringWithUTF8String:"seTswana"];
	case kDVDLanguageCodeTonga:
	    return [NSString stringWithUTF8String:"chiTonga"];
	case kDVDLanguageCodeTurkish:
	    return [NSString stringWithUTF8String:"Türkçe"];
	case kDVDLanguageCodeTsonga:
	    return [NSString stringWithUTF8String:"xiTsonga"];
	case kDVDLanguageCodeTatar:
	    return [NSString stringWithUTF8String:"татарча"];
	case kDVDLanguageCodeTwi:
	    return [NSString stringWithUTF8String:"Twi"];
	case kDVDLanguageCodeUkranian:
	    return [NSString stringWithUTF8String:"Українська"];
	case kDVDLanguageCodeUrdu:
	    return [NSString stringWithUTF8String:"اُردو"];
	case kDVDLanguageCodeUzbek:
	    return [NSString stringWithUTF8String:"Ўзбек"];
	case kDVDLanguageCodeVietnamese:
	    return [NSString stringWithUTF8String:"Tiếng Việt"];
	case kDVDLanguageCodeVolapuk:
	    return [NSString stringWithUTF8String:"Volapük"];
	case kDVDLanguageCodeWolof:
	    return [NSString stringWithUTF8String:"Wollof"];
	case kDVDLanguageCodeXhosa:
	    return [NSString stringWithUTF8String:"isiXhosa"];
	case kDVDLanguageCodeYoruba:
	    return [NSString stringWithUTF8String:"Yorùbá"];
	case kDVDLanguageCodeChinese:
	    return [NSString stringWithUTF8String:"中文"];
	case kDVDLanguageCodeZulu:
	    return [NSString stringWithUTF8String:"isiZulu"];
	default:
	    return [[NSNumber numberWithUnsignedInt:language] stringValue];
    }
}

FOUNDATION_EXPORT NSString * const NSLocaleLanguageCode __attribute__((weak_import)); 

NSString *stringForLanguageCode(DVDLanguageCode language){
    Class tClass =NSClassFromString(@"NSLocale");
    if(tClass == nil){
        return stringForLanguageCodeTenThree(language);
    }
    
    
    NSString* tString;
    NSString* tName;
    switch(language){
	case kDVDLanguageCodeNone:
	    return [NSString stringWithUTF8String:"None"];
        default:
            tString =(NSString*) [UTCreateStringForOSType(language) autorelease];
            tString = [tString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            tName = [[tClass currentLocale] displayNameForKey:NSLocaleLanguageCode value:tString];
           // NSLog(@"%@ ?= %@",tString,tName);
            return tName;
            
    }
}


void fatalError(DVDErrorCode inError, UInt32 inRefCon)
{
    NSLog(@"Fatal Error in DVD Framework");
}

void aspectChange(DVDEventCode inEventCode, UInt32 inEventValue1, UInt32 inEventValue2, UInt32 inRefCon)
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [(id)inRefCon performSelectorOnMainThread:@selector(aspectRatioChanged)
				   withObject:nil
				waitUntilDone:NO];
    [pool release];
}
