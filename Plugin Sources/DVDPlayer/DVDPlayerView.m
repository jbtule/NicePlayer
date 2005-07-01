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
	outPoint.v = (short)inPoint.y;
	outPoint.h = (short)inPoint.x;
	return outPoint;
}

void fatalError(DVDErrorCode inError, UInt32 inRefCon);
void aspectChange(DVDEventCode inEventCode, UInt32 inEventValue1, UInt32 inEventValue2, UInt32 inRefCon);

@implementation DVDPlayerView

+(void)initialize
{
	DVDInitialize();
}

/**
 * Each plugin must return a dictionary with the specified attributes. These are displayed in the preferences
 * for the user to see when choosing plugin order and which plugins are enabled.
 */
+(NSDictionary *)plugInfo
{
	NSArray *extensions = [NSArray arrayWithObjects:nil];
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
	if(self = [super initWithFrame:frame]){
		[self setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];			
		isAspectRatioChanging = NO;
	}
	return self;
}

/**
 * Update the bounds of the DVD. This generally happens on resize or window move.
 */
-(void)updateBounds:(NSRect)frame
{
	CGRect cgr = {{NSMinX(frame), NSMinY(frame)}, {NSWidth(frame), NSHeight(frame)}};

	Rect nr = convertCGRectToQDRect(cgr);
	DVDSetVideoBounds(&nr);
}

/**
 * The aspect ratio has changed, signal the change to the application and resize things properly.
 * isAspectRatioChanging allows our view to detect a resize in progress so that we can make sure that
 * the DVD view is properly sized so as not to allow white patches from showing through during a
 * resize event.
 */
-(void)aspectRatioChanged
{
	[[self window] setAspectRatio:[self naturalSize]];
	NSSize windowSize = [(NiceWindow *)[self window] getResizeAspectRatioSize];
	/* Make sure that bounds get resized first so we don't get white background showing through. */
	[self updateBounds:NSMakeRect(0, 0, windowSize.width, windowSize.height)];
	isAspectRatioChanging = YES;
	[(NiceWindow *)[self window] resizeToAspectRatio];
	isAspectRatioChanging = NO;
}

/**
 * Close the movie by deallocating and disposing the DVD framework.
 */
-(void)close
{
	[updateChapterTimer invalidate];
	DVDUnregisterEventCallBack(cid);
	DVDStop();
	if([[[myURL path] lastPathComponent] isEqualToString:@"VIDEO_TS"])
		DVDCloseMediaFile();
	else
		DVDCloseMediaVolume();
//	DVDDispose();
}

-(void)dealloc
{
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
	BOOL removableFlag;
	BOOL writableFlag;
	BOOL unmountableFlag;
	NSString *description;
	NSString *fileSystemType;
	
	BOOL isMountPoint = [[NSWorkspace sharedWorkspace] getFileSystemInfoForPath:[url path] 
																	isRemovable:&removableFlag
																	 isWritable:&writableFlag
																  isUnmountable:&unmountableFlag
																	description:&description
																		   type:&fileSystemType];
	if((isMountPoint & removableFlag) || ([[[url path] lastPathComponent] isEqualToString:@"VIDEO_TS"])){
		myURL = url;
	} else {
		NSString *sub_videots = [[url path] stringByAppendingPathComponent:@"VIDEO_TS"];
		BOOL isDir;
		if([[NSFileManager defaultManager] fileExistsAtPath:sub_videots isDirectory:&isDir] && isDir)
			myURL = [NSURL fileURLWithPath:sub_videots];
		else {
			NSLog(@"NO");
			return NO;
		}
	}
	
	FSRef fsref;
	CFURLGetFSRef((CFURLRef)myURL, &fsref);

	Boolean isValid;
	DVDIsValidMediaRef(&fsref, &isValid);
	if(isValid){
		[myURL retain];
		NSLog(@"YES");
		return YES;
	}
	
	NSLog(@"NO2");
	myURL = nil;
	return NO;
}

/**
 * Set up all of the proper DVD playback stuff.
 */
-(BOOL)loadMovie
{
	CGDirectDisplayID displays[MAX_DISPLAYS];
	CGDisplayCount displayCount;
	NSRect frame = [[NSScreen mainScreen] frame];
	DVDSetVideoWindowID([[self window] windowNumber]);	
	
	CGRect cgr = {{NSMinX(frame), NSMinY(frame)}, {NSWidth(frame), NSHeight(frame)}};
	CGGetDisplaysWithRect(cgr, MAX_DISPLAYS, displays, &displayCount);
	DVDSetVideoDisplay(displays[0]);
	[self updateBounds:[self frame]];

	DVDSetFatalErrorCallBack(fatalError, (UInt32)self);
	DVDEventCode inCode = kDVDEventDisplayMode;
	DVDRegisterEventCallBack(aspectChange, &inCode, 1, (UInt32)self, &cid);
	
	FSRef fsref;
	CFURLGetFSRef((CFURLRef)myURL, &fsref);
	NSLog(@"%@", [myURL path]);
	if([[[myURL path] lastPathComponent] isEqualToString:@"VIDEO_TS"])
		DVDOpenMediaFile(&fsref);
	else
		DVDOpenMediaVolume(&fsref);
	
	[self aspectRatioChanged];
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

/**
 * Returns the aspect ratio.
 */
-(NSSize)naturalSize
{
	DVDAspectRatio ratio;
	DVDGetAspectRatio(&ratio);
	NSSize anAspectRatio;
	/* Choose among preset DVD aspect ratios */
	switch(ratio){
		case kDVDAspectRatio4x3: case kDVDAspectRatio4x3PanAndScan:
			anAspectRatio = NSMakeSize(720, 3.0/4.0*720);
			break;			
		case kDVDAspectRatio16x9: case kDVDAspectRatioLetterBox:
			anAspectRatio = NSMakeSize(720, 9.0/16.0*720);
			break;
		case kDVDAspectRatioUninitialized:
			anAspectRatio = NSMakeSize(1, 1);
			break;
	}
	
	return anAspectRatio;
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
	if(!isAspectRatioChanging)
		[self updateBounds:[self frame]];
	DVDUpdateVideo();
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
	DVDUpdateVideo();
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
	
	newItem = [[[NSMenuItem alloc] initWithTitle:@"Bookmarks"
										  action:nil
								   keyEquivalent:@""] autorelease];
	[newItem setSubmenu:[self bookmarksMenu]];
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
	
	return titleMenu;
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
		
	return chapterMenu;
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
		switch(lCode){
			case kDVDLanguageCodeJapanese:
				label = @"Japanese";
				break;
			case kDVDLanguageCodeEnglish:
				label = @"English";
				break;
			case kDVDLanguageCodeFrench:
				label = @"French";
				break;
			case kDVDLanguageCodeGerman:
				label = @"German";
				break;
			case kDVDLanguageCodeRussian:
				label = @"Russian";
				break;
			default:
				label = [[NSNumber numberWithUnsignedInt:i] stringValue];
		}
		switch(eCode){
			case kDVDAudioExtensionCodeDirectorsComment1:
			case kDVDAudioExtensionCodeDirectorsComment2:
				label = [label stringByAppendingString:@" / Director's Commentary"];
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
	
	return audioMenu;
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
	
	return angleMenu;
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
		switch(lCode){
			case kDVDLanguageCodeJapanese:
				label = @"Japanese";
				break;
			case kDVDLanguageCodeEnglish:
				label = @"English";
				break;
			case kDVDLanguageCodeFrench:
				label = @"French";
				break;
			case kDVDLanguageCodeGerman:
				label = @"German";
				break;
			case kDVDLanguageCodeRussian:
				label = @"Russian";
				break;
			default:
				label = [[NSNumber numberWithUnsignedInt:i] stringValue];
		}
		
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
	
	return subPicturesMenu;
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
	DVDUpdateVideo();
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RebuildAllMenus" object:self];
}

-(void)gotoChapter:(id)anObject
{
	Boolean isp;
	DVDIsPaused(&isp);
	DVDSetChapter([anObject tag]);
	if(isp)
		DVDPause();
	else
		DVDResume();
	DVDUpdateVideo();
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RebuildAllMenus" object:self];
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
	DVDUpdateVideo();
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
	DVDUpdateVideo();
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RebuildAllMenus" object:self];
}

-(void)selectSubPicture:(id)anObject
{
	Boolean isp;
	DVDIsPaused(&isp);
	DVDSetSubPictureStream([anObject tag]);
	if(isp)
		DVDPause();
	else
		DVDResume();
	DVDUpdateVideo();
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RebuildAllMenus" object:self];
}

-(void)rebuildMenuTimer
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RebuildAllMenus" object:self];
}

-(id)bookmarksMenu
{
	id bookmarksMenu = [[NSMenu alloc] initWithTitle:@"Bookmarks Menu"];
	id newItem;
	NSArray *bookmarks = [self bookmarksForCurrentDisc];
	unsigned short i;
	
	for(i = 0; i < [bookmarks count]; i++){
		newItem = [[[NSMenuItem alloc] initWithTitle:[bookmarks objectAtIndex:i]
											  action:@selector(bookmarksForCurrentDiscAndName:)
									   keyEquivalent:@""] autorelease];
		[newItem setTarget:self];
		[newItem setTag:i];
		[bookmarksMenu addItem:newItem];
	}
	
	return bookmarksMenu;
}

-(id)bookmarksForCurrentDisc
{
	DVDDiscID outDiscID;
	DVDGetMediaUniqueID(&outDiscID);
	return [[[self class] dvdPrefController] bookmarksForDisc:[NSData dataWithBytes:&outDiscID length:8]];
}

-(id)bookmarksForCurrentDiscAndName:(id)sender
{
	DVDDiscID outDiscID;
	DVDGetMediaUniqueID(&outDiscID);
	[[[self class] dvdPrefController] bookmarkDataFromName:[sender stringValue]
												   forDisc:[NSData dataWithBytes:&outDiscID length:8]];

}

-(id)setBookmarkForCurrentDisc:(id)sender
{
	static id myNib = nil;
	NSArray *tmpArray;
	
	if(!myNib)
		myNib = [[NSNib alloc] initWithNibNamed:@"BookmarkEntry" bundle:[NSBundle bundleForClass:[self class]]];
	[myNib instantiateNibWithOwner:self topLevelObjects:&tmpArray];	
}

-(IBAction)setBookmarkForCurrentDiscWithNameField:(id)sender
{
	NSLog(@"%@", [sender entryText]);
	return;
	DVDDiscID outDiscID;
	DVDGetMediaUniqueID(&outDiscID);

	void *data;
	int length = 0;
	
	DVDGetBookmark(data, &length);
		
	[[[self class] dvdPrefController] setBookmark:[NSData dataWithBytes:data length:length]
										 withName:[sender entryText]
										  forDisc:[NSData dataWithBytes:&outDiscID length:8]];
}

@end

void fatalError(DVDErrorCode inError, UInt32 inRefCon)
{
	NSLog(@"Fatal Error in DVD Framework");
}

void aspectChange(DVDEventCode inEventCode, UInt32 inEventValue1, UInt32 inEventValue2, UInt32 inRefCon)
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	objc_msgSend((id)inRefCon, @selector(aspectRatioChanged));
	[pool release];
}
