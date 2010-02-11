/**
* NiceDocument.m
 * NicePlayer
 *
 * The document subclass containing the NicePlayer document features.
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

#import "NiceDocument.h"
#import "NiceUtilities.h"
#import "NiceWindow/NiceWindowController.h"
#import "AppleRemote.h"
#import "ControlPlay.h"
#import "JTTextFittingView.h"
#import <STEnum/STEnum.h>

#define PLAYLIST_ITEM -42
#define VOLUME_ITEM -43

id rowsToFileNames(id obj, void* playList){
    return [[(id)playList objectAtIndex:[obj intValue]] path];
}




id collectURLToStrings(id each, void*context){
    return [each absoluteString];
}


BOOL rejectSelf(id each,void* context){
    return [each isEqual:[(NiceDocument*)context window]];
}

int sortByMain(id v1, id v2, void* context){
    if([v1 isEqualTo:v2])
        return NSOrderedSame;
    if([[NSScreen mainScreen] isEqualTo: v1]){
        return NSOrderedAscending;
    }
    
    return NSOrderedAscending;
}

BOOL findWindowScreen(id each, void* context){
    return [[each screen] isEqual:(NSScreen*)context];
}

id collectStringsToURLs(id each, void* context){
    return [NSURL URLWithString:each];
}

BOOL findOpenPoint(id eachwin, void* context){
    
    NSMutableDictionary* tContext =(NSMutableDictionary*) context;
    
    NSValue* tPoint =[tContext objectForKey:@"tPoint"];
    NiceDocument* tSelf =[tContext objectForKey:@"self"];
    NSRect tWinRect = [eachwin frame];
    NSRect tNewRect = NSMakeRect([tPoint pointValue].x,[tPoint pointValue].y,[[tSelf window] frame].size.width,[[tSelf window] frame].size.height);
    NSRect tSubScreenRect =[[tContext objectForKey:@"tSubScreenRect"] rectValue];
    
    return NSIntersectsRect(tWinRect,tNewRect) || !NSContainsRect(tSubScreenRect,tNewRect);
}

void findSpace(id each, void* context, BOOL* endthis){
    NSMutableDictionary* tContext =(NSMutableDictionary*) context;
    NSRect tSubScreenRect = [each visibleFrame];
    [tContext setObject:[NSValue valueWithRect:tSubScreenRect] forKey:@"tSubScreenRect"];
    NiceDocument* tSelf = [tContext objectForKey:@"self"];

    
    for(float j = tSubScreenRect.origin.y + tSubScreenRect.size.height - [[tSelf window] frame].size.height; j >= tSubScreenRect.origin.y; j -= [[tSelf window] frame].size.height){
        for(float i = tSubScreenRect.origin.x; i < tSubScreenRect.origin.x + tSubScreenRect.size.width; i+= [[tSelf window] frame].size.width){
            NSValue* tPoint= [NSValue valueWithPoint:NSMakePoint(i,j)];
            [tContext setObject:tPoint forKey:@"tPoint"];
            if(nil == [[tContext objectForKey:@"tMovieWindows"] detectUsingFunction:findOpenPoint context:(void*)tContext]){
                STDoBreak(endthis);
            }
            tPoint = nil;
        }
    }
}

#import "NPApplication.h"

@interface NiceDocument(Private)



@end


@implementation NiceDocument

- (id)init
{
    self = [super init];
    if(self){
        hasRealMovie = NO;
        isRandom = NO;
        theSubtitle = nil;
        asffrrTimer = nil;
        thePlaylist = [[NSMutableArray alloc] init];
		theDataSourceCache  = [[NSMutableArray alloc] init];
                theMainItemCache = [[NSMutableDictionary alloc] init];
		_randomList = [[NSMutableArray alloc] init];
        theRepeatMode = [[Preferences mainPrefs] defaultRepeatMode];
        movieMenuItem = nil;
        menuObjects = nil;
        playlistFilename = nil;
        theID = [[[NSProcessInfo processInfo] globallyUniqueString] retain];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(rebuildMenu)
                                                     name:@"RebuildAllMenus"
                                                   object:nil];		
												   
    }
    
    return self;
}

-(void)dealloc
{
    int i;
    
    if(movieMenuItem != nil && ([[self movieMenu] indexOfItem:movieMenuItem] != -1))
        [[self movieMenu] removeItem:movieMenuItem];
    
    if(menuObjects != nil){
        for(i = 0; i < (int)[menuObjects count]; i++)
            [[self movieMenu] removeItem:[menuObjects objectAtIndex:i]];
        [menuObjects release];
    }
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [theSubtitle release];
	theSubtitle = nil;
    [theCurrentURL release];
    [thePlaylist release];
    [playlistFilename release];
	
    [theID release];
	[theDataSourceCache release];
        [theMainItemCache release];
	[_randomList release];
    [super dealloc];
}

-(NSString*)identifier{
    return theID;
}

- (id)initWithContentsOfFile:(NSString *)fileName ofType:(NSString *)docType
{
    if((self = [super initWithContentsOfFile:fileName ofType:docType])){
    }
    return self;
}

- (id)initWithContentsOfURL:(NSURL *)aURL ofType:(NSString *)docType
{
    if((self = [super initWithContentsOfFile:[aURL absoluteString] ofType:docType])){
    }
    return self;
}

#pragma mark -
#pragma mark File Operations

- (NSData *)dataRepresentationOfType:(NSString *)aType
{
    // Insert code here to write your document from the given data.  You can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.
    

    
    id tDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"MajorVersion",
                                                        [NSNumber numberWithInt:1],@"MinorVersion",
                                                        [NSDictionary dictionaryWithObjectsAndKeys:[thePlaylist collectUsingFunction:collectURLToStrings context:nil],@"Playlist",
                                                                                        [NSNumber numberWithFloat:[theMovieView volume]],@"Volume",
                                                                        [NSNumber numberWithInt:theRepeatMode],@"Repeat",
                                                                        [NSNumber numberWithBool:isRandom],@"Random",nil],@"Contents",nil];
    NSString* tErrror = nil;
    NSData* tData = [NSPropertyListSerialization dataFromPropertyList:tDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&tErrror];
    
    if(tData == nil)
        NSLog(tErrror);
    
    return  tData;

}

- (BOOL)writeToFile:(NSString*)aPath ofType:(NSString *)docType{
        [playlistFilename release];
    playlistFilename = [[NSURL fileURLWithPath:aPath] retain];
      return  [super writeToFile:aPath ofType:docType];
    
}

/**
* This gets called automatically when a user attempts to open a document via the open menu.
 */
- (BOOL)readFromFile:(NSString *)fileName ofType:(NSString *)docType
{
    return [self readFromURL:[NSURL fileURLWithPath:fileName] ofType:docType];
}


/**
* Things to do for a new file passed in. This gets called by the document controller automatically when
 * files are dropped onto the app icon.
 */
- (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)docType
{
    // Insert code here to read your document from the given data.  You can also choose to override -loadFileWrapperRepresentation:ofType: or -readFromFile:ofType: instead.
    
    if([[docType lowercaseString] isEqualTo:@"nicelist"] || [[docType lowercaseString] isEqualTo:[@"Nice Playlist" lowercaseString]]){
        return [self loadPlaylistFromURL:url];
    }
    
    if(theCurrentURL)
        [theCurrentURL release];
    theCurrentURL = [url retain];
    if(![thePlaylist containsObject:theCurrentURL]){
        [self addURLToPlaylist:theCurrentURL];
    }
    
    return YES;
}

/**
* Try to load a URL.
 * TODO: Actually check for errors.
 */
-(void)loadURL:(NSURL *)url firstTime:(BOOL)isFirst
{
	if([[NSURL URLWithString:@"placeholder://URL_Placeholder"] isEqualTo:url])
		return;
    [self readFromURL:url ofType:nil];
    [self finalOpenURLFirstTime:isFirst];
    [self updateAfterLoad];
}

/**
* Try to open a URL. If it fails, load a blank window image. If it succeeds, set up the proper aspect ratio,
 * and title information.
 */
-(BOOL)finalOpenURLFirstTime:(BOOL)isFirst
{   
    /* Try to load the movie */
    if(![theMovieView openURL:theCurrentURL]){
        hasRealMovie = NO;
        return NO;
    } else
        hasRealMovie = YES;
    
    /* Try to load the subtitles */
 /*   NSString* srtPath = [[[theCurrentURL path] stringByDeletingPathExtension] stringByAppendingPathExtension:@"srt"];
    NSString* subPath = [[[theCurrentURL path] stringByDeletingPathExtension] stringByAppendingPathExtension:@"sub"];
	NSString* ssaPath = [[[theCurrentURL path] stringByDeletingPathExtension] stringByAppendingPathExtension:@"ssa"];*/

    [theSubtitle release];
   /* disabled until subtitles are rewriten
	if([[NSFileManager defaultManager] fileExistsAtPath:srtPath]){
        theSubtitle = [[Subtitle alloc] initWithFile:srtPath forMovieSeconds:(float)[theMovieView totalTime]];
    }else if ([[NSFileManager defaultManager] fileExistsAtPath:subPath]){
        theSubtitle = [[Subtitle alloc] initWithFile:subPath forMovieSeconds:(float)[theMovieView totalTime]];
    }else if ([[NSFileManager defaultManager] fileExistsAtPath:ssaPath]){
        theSubtitle = [[Subtitle alloc] initWithFile:ssaPath forMovieSeconds:(float)[theMovieView totalTime]];
    }else{*/
        theSubtitle = nil;
    //}
	
	if(theSubtitle != nil){
		[[theWindow subtitleView] setMaxText:[theSubtitle longestText]];
	}
	
	
    if(![self hasPlaylist]){
        [self setFileName:[[[[theCurrentURL path] lastPathComponent] stringByDeletingPathExtension] stringByAppendingPathExtension:@"nicelist"]];
        [self setFileType:@"nicelist"];
    }
    
    /* Initialize the window stuff for movie playback. */
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RebuildAllMenus" object:nil];
    [theWindow restoreVolume];
    [self calculateAspectRatio];
    if(isFirst)
        [theWindow initialDefaultSize];
    else
        [theWindow resizeToAspectRatio];
    [theWindow setTitleWithRepresentedFilename:[theCurrentURL path]];
    [theWindow setTitle:[theWindow title]];
    [NSApp changeWindowsItem:theWindow title:[theWindow title] filename:YES];
    [NSApp updateWindowsItem:theWindow];
    
    return YES;
}

#pragma mark Window Information

-(BOOL)isActive
{
    return hasRealMovie;
}

-(BOOL)isPlaying
{
    return [theMovieView isPlaying];
}

- (void)windowDidMiniaturize:(NSNotification *)aNotification
{
    wasPlayingBeforeMini = [(NPMovieView *)theMovieView isPlaying];
    [(NPMovieView *)theMovieView stop];
}

- (void)windowDidDeminiaturize:(NSNotification *)aNotification
{
    [theWindow restoreVolume];
    if(wasPlayingBeforeMini)
	[theMovieView start];
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];

    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    if(theCurrentURL == nil){
        [NSApp addWindowsItem:theWindow title:@"NicePlayer" filename:NO];
    } 
    
    [self updateAfterLoad];
	[self repositionAfterLoad];
	[[self window] orderFront:aController];
}

/**
* Update the UI after loading a movie by doing things such as scaling to the proper aspect ratio and
 * refreshing GUI items.
 */
-(void)updateAfterLoad
{
    [NSApp updateWindowsItem:theWindow];
    
    [thePlaylistTable setDoubleAction:@selector(choosePlaylistItem:)];
    [thePlaylistTable registerForDraggedTypes: [NSArray arrayWithObjects: NSFilenamesPboardType, nil]];
	[thePlaylistTable setDraggingSourceOperationMask:NSDragOperationEvery forLocal:YES];
    [thePlaylistTable setDraggingSourceOperationMask:NSDragOperationEvery forLocal:NO];
	
    [self refreshRepeatModeGUI];
    [self calculateAspectRatio];
					[[NSNotificationCenter defaultCenter] postNotificationName:@"RebuildAllMenus" object:nil];
	if([[Preferences mainPrefs] audioVolumeSimilarToLastWindow]){
		NiceDocument *doc = [[NSDocumentController sharedDocumentController] currentDocument];
		if(doc)
			[theMovieView setVolume:[doc volume]];
		else
			[theMovieView setVolume:[[Preferences mainPrefs] defaultAudioVolume]];
	}
	
	[[self window] updateVolume];
}


- (void)repositionAfterLoad{
    
	NSString* tPosition =[[Preferences mainPrefs] windowPosition];
	if([[NSApp movieWindows] count] == 1 && tPosition != nil){
		[[self window] setFrameOrigin:NSPointFromString(tPosition)];
		return;
	}
	
    int tScreenPref = -1;
    
    NSScreen* tScreen = [NSScreen mainScreen];
    NSArray* tScreens = [NSScreen screens];
    
    if(tScreenPref > 0 && (tScreenPref < (int)[tScreens count])){
        tScreen = [tScreens objectAtIndex:tScreenPref];
    }  
        
    NSValue* tPoint = nil;
      
    NSArray* tMovieWindows = [[NSApp movieWindows] rejectUsingFunction:rejectSelf context:(void*)self];
    
    
    NSMutableDictionary* tContext = [NSMutableDictionary dictionaryWithObjectsAndKeys:self,@"self",tMovieWindows,@"tMovieWindows", nil];

    
    if(tScreenPref < 0){
        id tArray =[[NSScreen screens] sortedArrayUsingFunction:sortByMain context:nil];
        [tArray doUsingFunction:findSpace context:(void*)tContext];
    }else{
        BOOL tDummy;
        findSpace(tScreen,(void*)tContext,&tDummy);
    }
    
    tPoint = [tContext objectForKey:@"tPoint"];
    
    
    if(tPoint == nil){

        id tWindow = [[NSApp movieWindows] detectUsingFunction:findWindowScreen context:(void*)tScreen];
        [[self window] cascadeTopLeftFromPoint:[tWindow frame].origin];
    }else{
        [[self window] setFrameOrigin:[tPoint pointValue]];
    }
}

- (void)makeWindowControllers{
	NiceWindowController *controller = [[NiceWindowController alloc] initWithWindowNibName:@"NiceDocument" owner:self];
    [self addWindowController:controller];
	[controller release];
}

- (void)showWindows
{
    [super showWindows];
    [(NiceWindow *)[self window] setupOverlays];
}

/**
* If movie has ended, then set the proper images for the controls and play the next movie.
 */
-(void)movieHasEnded
{
    if( (theRepeatMode == REPEAT_LIST) || (theRepeatMode == REPEAT_NONE)){
        [[theWindow playButton] setImage:[NSImage imageNamed:@"play"]];
        [[theWindow playButton] setAlternateImage:[NSImage imageNamed:@"playClick"]];
        if([theMovieView wasPlaying] && ![(NiceWindow*)[self window] scrubberInUse])
            [self playNext];
    }
}

-(id)subTitle
{
    return theSubtitle;
}

-(NSMenu *)movieMenu
{
    return [[[NSApp mainMenu] itemWithTitle:NSLocalizedString(@"Movie",@"Movie")] submenu];
}

-(NSMenu *)playlistMenu
{
    return [[[NSApp mainMenu] itemWithTitle:NSLocalizedString(@"Playlist",@"Playlist Menu Title")] submenu];
}


-(IBAction)switchPlaylistItem:(NSMenuItem*)sender{
	[self playAtIndex:[[sender representedObject] unsignedIntValue] obeyingPreviousState:YES];
}

-(IBAction)switchRepeatMode:(NSMenuItem*)sender{
	theRepeatMode =[[sender representedObject] intValue];
	[self refreshRepeatModeGUI];
	
}

-(NSArray*)playlistMenuItems{
	NSMutableArray* tArray = [NSMutableArray array];
	for(unsigned int i =0; i <  [thePlaylist count];i++){
			id tObj = [thePlaylist objectAtIndex:i];
			NSMenuItem* tItem = [[[NSMenuItem alloc ]init] autorelease];
			NSString* tNumber =[NSString stringWithFormat:@"%d",i+1];
			
			while([tNumber length] < 4){
				tNumber = [@" " stringByAppendingString:tNumber];
			}
			
			[tItem setTitle: [NSString stringWithFormat:@"%@.  %@",tNumber,[[tObj path] lastPathComponent]]];
			[tItem setRepresentedObject:[NSNumber numberWithInt:i]];
			[tItem setState:(int)[tObj isEqualTo:theCurrentURL]];
			[tItem setTarget:self];
			[tItem setTag:PLAYLIST_ITEM];
			[tItem setAction:@selector(switchPlaylistItem:)];
			[tArray addObject: tItem];
		}
	return tArray;
}

-(NSArray*)BasicPlaylistMenuItems{
		NSMutableArray* tArray = [NSMutableArray array];

	[tArray addObject:[self playOrderMenu]];

	NSMenuItem* tItem = [[[NSMenuItem alloc] init] autorelease];
	[tItem setTitle:NSLocalizedString(@"Previous",@"Previous menu item")];
	[tItem setKeyEquivalent:@"["];
	[tItem setKeyEquivalentModifierMask:0];
	[tItem setTarget:self];
	[tItem setAction:@selector(playPrev:)];
	[tArray addObject:tItem];
	
	tItem = [[[NSMenuItem alloc] init] autorelease];
	[tItem setTitle:NSLocalizedString(@"Next",@"Next menu item")];
	[tItem setKeyEquivalent:@"]"];
		[tItem setKeyEquivalentModifierMask:0];

	[tItem setTarget:self];
	[tItem setAction:@selector(playNext:)];
	[tArray addObject:tItem];
	
	[tArray addObjectsFromArray:[self playlistMenuItems]];
	
	return tArray;
}

-(NSArray*)FullPlaylistMenuItems{
		NSMutableArray* tArray = [NSMutableArray array];

	[tArray addObject:[self volumeMenu]];
	
		[tArray addObject:[NSMenuItem separatorItem]];


	[tArray addObject:[self playOrderMenu]];

	NSMenuItem* tItem = [[[NSMenuItem alloc] init] autorelease];
	[tItem setTitle:NSLocalizedString(@"Previous",@"Previous menu item")];
	[tItem setKeyEquivalent:@"["];
		[tItem setKeyEquivalentModifierMask:0];

	[tItem setTarget:self];
	[tItem setAction:@selector(playPrev:)];
	[tArray addObject:tItem];
	
	 tItem = [[[NSMenuItem alloc] init] autorelease];
	[tItem setTitle:NSLocalizedString(@"Next",@"Next menu item")];
	[tItem setKeyEquivalent:@"]"];
		[tItem setKeyEquivalentModifierMask:0];

	[tItem setTarget:self];
	[tItem setAction:@selector(playNext:)];
	[tArray addObject:tItem];
	
	[tArray addObjectsFromArray:[self playlistMenuItems]];
	
	
	
	return tArray;
}

-(NSMenuItem*)playOrderMenu{
	NSMenuItem* tHeading = [[[NSMenuItem alloc] init] autorelease];
	[tHeading setTitle:NSLocalizedString(@"Play Order",@"Play Order Menu item")];

	NSMenu* tMenu = [[[NSMenu alloc] init] autorelease];
	
	
	NSMenuItem* tItem = [[[NSMenuItem alloc] init] autorelease];
	[tItem setTitle:NSLocalizedString(@"Randomized",@"Randomized menu item")];
	[tItem setState:isRandom];
	[tItem setTarget:self];
	[tItem setAction:@selector(toggleRandomMode:)];
	[tMenu addItem:tItem];
	
	[tMenu addItem:[NSMenuItem separatorItem]];

	
	tItem = [[[NSMenuItem alloc] init] autorelease];
	[tItem setTitle:NSLocalizedString(@"No Repeat Volume",@"No Repeat Volume menu item")];
	[tItem setState:theRepeatMode == REPEAT_NONE];
	[tItem setTarget:self];
	[tItem setRepresentedObject:[NSNumber numberWithInt:REPEAT_NONE]];
	[tItem setAction:@selector(switchRepeatMode:)];
	[tMenu addItem:tItem];
	
	tItem = [[[NSMenuItem alloc] init] autorelease];
	[tItem setTitle:NSLocalizedString(@"Repeat One",@"Repeat One Volume menu item")];
		[tItem setState:theRepeatMode == REPEAT_ONE];

	[tItem setTarget:self];
		[tItem setRepresentedObject:[NSNumber numberWithInt:REPEAT_ONE]];

	[tItem setAction:@selector(switchRepeatMode:)];
	[tMenu addItem:tItem];
	
		tItem = [[[NSMenuItem alloc] init] autorelease];
	[tItem setTitle:NSLocalizedString(@"Repeat All",@"Repeat All Volume menu item")];
	[tItem setTarget:self];
			[tItem setRepresentedObject:[NSNumber numberWithInt:REPEAT_LIST]];
					[tItem setState:theRepeatMode == REPEAT_LIST];


	[tItem setAction:@selector(switchRepeatMode:)];
	[tMenu addItem:tItem];
	

	[tHeading setSubmenu:tMenu];

	return tHeading;
}

-(IBAction)switchVolume:(NSMenuItem*)sender{
	[theMovieView setVolume:[[sender representedObject] intValue]/100.0];
}
-(IBAction)mute:(id)sender{
	[theMovieView setMuted:![theMovieView muted]];
}
-(IBAction)increaseVolume:(id)sender{
	[theMovieView incrementVolume];
}
-(IBAction)decreaseVolume:(id)sender{
	[theMovieView decrementVolume];
}

-(NSMenuItem*)volumeMenu{
	NSMenuItem* tHeading = [[[NSMenuItem alloc] init] autorelease];
	[tHeading setTitle:NSLocalizedString(@"Volume",@"Volume Menu item")];

	NSMenu* tMenu = [[[NSMenu alloc]init] autorelease];
	
	NSMenuItem* tItem = [[[NSMenuItem alloc] init] autorelease];
	[tItem setTitle:NSLocalizedString(@"Mute",@"Mute menu item")];
	[tItem setKeyEquivalent:@"del"];
	[tItem setState: [theMovieView muted] ? NSOnState: NSOffState];
	[tItem setTarget:self];
	[tItem setAction:@selector(mute:)];
	[tMenu addItem:tItem];
	
	tItem = [[[NSMenuItem alloc] init] autorelease];
	[tItem setTitle:NSLocalizedString(@"Increase Volume",@"Increase Volume menu item")];
	[tItem setKeyEquivalent:@"="];
	[tItem setTarget:self];
		[tItem setKeyEquivalentModifierMask:0];

	[tItem setAction:@selector(increaseVolume:)];
	[tMenu addItem:tItem];
	
	tItem = [[[NSMenuItem alloc] init] autorelease];
	[tItem setTitle:NSLocalizedString(@"Decrease Volume",@"Increase Volume menu item")];
	[tItem setKeyEquivalent:@"-"];
		[tItem setKeyEquivalentModifierMask:0];

	[tItem setTarget:self];
	[tItem setAction:@selector(decreaseVolume:)];
	[tMenu addItem:tItem];
	
	[tMenu addItem:[NSMenuItem separatorItem]];



	for(int i= 200; i>=0;i-=20){
			tItem = [[[NSMenuItem alloc] init] autorelease];
			[tItem setTitle:[NSString stringWithFormat:@"%d%%",i]];
			
			int tInt =(int)(fabsf([theMovieView volumeWithMute]) * 10);
			
			if(tInt == i /10)
				[tItem setState:NSOnState];
			else if(tInt > i /10
					&& tInt < (i /10) +2 )
				[tItem setState:NSMixedState];
			else
				[tItem setState:NSOffState];

			[tItem setTag:VOLUME_ITEM];
			[tItem setRepresentedObject:[NSNumber numberWithInt:i]];
			[tItem setTarget:self];
			[tItem setAction:@selector(switchVolume:)];
			[tMenu addItem:tItem];
	}
	
	[tHeading setSubmenu:tMenu];
	
	return tHeading;
}

-(void)rebuildPlaylistMenu{
    if([[self window] isKeyWindow]){

    NSMenu* playlistMenu = [self playlistMenu];
	NSArray* tArray =[playlistMenu itemArray];
	for(int i = [tArray count]-1; i > 2; i--){
		[playlistMenu removeItem:[tArray objectAtIndex:i]];
	}
	tArray= [self FullPlaylistMenuItems];
	for(unsigned int i=0; i < [tArray count]; i++){
		[playlistMenu addItem:[tArray objectAtIndex:i]];
	}
	}
	
} 


/* Always call this method by raising the notification "RebuildAllMenus" otherwise
stuff won't work properly! */
-(void)rebuildMenu
{

    int i;
    id pluginMenu = [theMovieView pluginMenu];
    if(!pluginMenu)
		pluginMenu = [NSMutableArray array];

    if(movieMenuItem != nil && ([[self movieMenu] indexOfItem:movieMenuItem] != -1)){
        [[self movieMenu] removeItem:movieMenuItem];
        movieMenuItem = nil;
    }
    
    if(menuObjects != nil){
        for(i = 0; i < (int)[menuObjects count]; i++)
            [[self movieMenu] removeItem:[menuObjects objectAtIndex:i]];
        [menuObjects release];
        menuObjects = nil;
    }
    
	id tMenuTitle =[theMovieView menuTitle];
	if(tMenuTitle == nil)
		tMenuTitle = @"Untitled Movie";
    movieMenuItem = [[NSMenuItem alloc] initWithTitle:tMenuTitle
                                               action:nil
                                        keyEquivalent:@""];
    
    if([[self window] isKeyWindow]){
        menuObjects = [[NSMutableArray array] retain];
        [movieMenuItem setEnabled:NO];
        [[self movieMenu] insertItem:movieMenuItem atIndex:0];
        for(i = ((int)[pluginMenu count] - 1); i >= 0; i--){	// Reverse iteration for easier addition
            [[self movieMenu] insertItem:[pluginMenu objectAtIndex:i] atIndex:1];
            [menuObjects addObject:[pluginMenu objectAtIndex:i]];
        }
    } else {
        /*[movieMenuItem setEnabled:YES];
        id mSubMenu = [[NSMenu alloc] initWithTitle:[theMovieView menuTitle]];
        [movieMenuItem setSubmenu:mSubMenu];
        [[self movieMenu] insertItem:movieMenuItem atIndex:[[self movieMenu] numberOfItems]];
        while([mSubMenu numberOfItems] > 0)
            [mSubMenu removeItemAtIndex:0];
        
        for(i = 0; i < (int)[pluginMenu count]; i++)
            [mSubMenu addItem:[pluginMenu objectAtIndex:i]];*/
    }[self rebuildPlaylistMenu];
		[self reloadPlaylist];

}

-(id)window
{
    return theWindow;
}

- (NSSize)calculateAspectRatio
{
    NSSize aSize = [theMovieView naturalSize];
		[theWindow setAspectRatio:aSize];
		[theWindow setMinSize:NSMakeSize((aSize.width/aSize.height)*150,150)];
	return aSize;
}

-(void)resetRandom{
	if( [thePlaylist count] <= 1)
		return;
	[_randomList removeAllObjects];
	id tArray = [NSMutableArray arrayWithNumbersForRange:NSMakeRange(0, [thePlaylist count])];	
	NSUInteger tCurrent =[thePlaylist indexOfObject:theCurrentURL];
	[tArray removeObjectAtIndex:tCurrent];
	[_randomList addObject:[NSNumber numberWithInt:tCurrent]];
	_randomIndex =0;
	while([tArray count]>1){
		int i = ((float)random()/RAND_MAX) * [tArray count]; 
		id tItem = [tArray objectAtIndex:i];
		[_randomList addObject:tItem];
		[tArray removeObjectAtIndex:i];
	}
	 [_randomList addObject:[tArray lastObject]];

}

#pragma mark Interface

-(IBAction)toggleRandomMode:(id)sender
{
	
    if(isRandom)
        isRandom = NO;
    else{
        isRandom = YES;
		[self resetRandom];
	}
		
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RebuildAllMenus" object:nil];

}


-(IBAction)toggleRepeatMode:(id)sender
{
    theRepeatMode = (theRepeatMode + 1) % [Preferences defaultRepeatModeValuesNum];
    
    [self refreshRepeatModeGUI];
}

/**
* Sets the image for the current repeat mode.
 */
-(void)refreshRepeatModeGUI
{
    switch(theRepeatMode){
        case REPEAT_LIST:
            [theRepeatButton setImage:[NSImage imageNamed:@"repeat_list"]];
            [theMovieView setLoopMode: NSQTMovieNormalPlayback];
            break;
        case REPEAT_ONE:
            [theRepeatButton setImage:[NSImage imageNamed:@"repeat_one"]];
            [theMovieView setLoopMode: NSQTMovieLoopingPlayback];
            break;
        case REPEAT_NONE:
            [theRepeatButton setImage:[NSImage imageNamed:@"repeat_none"]];
            [theMovieView setLoopMode: NSQTMovieNormalPlayback];
            break;
    }
	
	[theRandomButton setState:isRandom ? NSOnState : NSOffState];

	
			[[NSNotificationCenter defaultCenter] postNotificationName:@"RebuildAllMenus" object:nil];

}

-(void)play:(id)sender
{
    [theMovieView start];
}

-(void)pause:(id)sender
{
    [theMovieView stop];
}

-(void)playNext:(id)sender
{
    [self playNext];
}

-(void)playPrev:(id)sender
{
    [self playPrev];
}


-(unsigned)getNextIndex
{
    unsigned int anIndex = [thePlaylist indexOfObject:theCurrentURL];
    
    if([thePlaylist isEmpty])
        return -1;
    
    if(isRandom){
		if(!(_randomIndex < [_randomList count] -1)){
			if (REPEAT_LIST == theRepeatMode){
				[self resetRandom];
			}else {
			    return -1;
			}
		}
		_randomIndex++;

		anIndex = [[_randomList objectAtIndex:_randomIndex] unsignedIntValue];
    }else{
        anIndex++;
    }
    
    return anIndex;
}


-(void)playNext
{	
    int anIndex = [self getNextIndex];
    
    if(anIndex >= (int)[thePlaylist count]){
        if(REPEAT_LIST == theRepeatMode){
            anIndex = 0;
        } else {
            if([[Preferences mainPrefs] windowLeaveFullScreen] && [[self window] isFullScreen])
                [[self window] unFullScreen];
        }
    }
    
    if( (anIndex >= 0) && (anIndex < (int)[thePlaylist count])){
        [self playAtIndex:anIndex obeyingPreviousState:YES];
    }
}


/**
* Chooses the proper playlist item and calls playAtIndex:
 */

-(unsigned)getPrevIndex
{
    int anIndex = [thePlaylist indexOfObject:theCurrentURL];
    
	if(isRandom && [_randomList count] !=0){
		if(_randomIndex == 0){
			if (REPEAT_LIST == theRepeatMode){
				_randomIndex = [_randomList count];
			}else {
			    return -1;
			}
		}
		_randomIndex--;
		anIndex = [[_randomList objectAtIndex:_randomIndex] unsignedIntValue];
	
		return anIndex;
    }
	
	
    if(anIndex ==0){
        if ([thePlaylist isEmpty])
            return -1;
        anIndex = [thePlaylist count];   
    }
    
    return anIndex -1;
}

-(void)playPrev
{
    int anIndex =  [self getPrevIndex];
    
    if((anIndex >= 0) && (anIndex < (int)[thePlaylist count])){
        [self playAtIndex:anIndex obeyingPreviousState:YES];
    }
}

-(void)playPrevWithChapter
{
    int anIndex =  [self getPrevIndex];
    
    if((anIndex >= 0) && (anIndex < (int)[thePlaylist count])){
        [self playAtIndex:anIndex obeyingPreviousState:YES];
		if([[theMovieView chapters] count] > 0){
				[theMovieView gotoChapter:((int)[[theMovieView chapters] count])-1];
		}
    }
}



-(void)reloadPlaylist{
	[theDataSourceCache autorelease];
	theDataSourceCache = [[NSMutableArray alloc]init];
	[theMainItemCache autorelease];
       theMainItemCache = [[NSMutableDictionary  alloc] init];
    [thePlaylistTable reloadData];
	
	for(int i=0;i<[thePlaylistTable numberOfRows];i++){
		[thePlaylistTable expandItem:[thePlaylistTable itemAtRow:i]];
	}

}

/**
* Responsible for controlling what to do when a playlist item is changed.
 */
-(void)playAtIndex:(unsigned int)anIndex obeyingPreviousState:(BOOL)aBool
{
    id tempURL = [thePlaylist objectAtIndex:anIndex];
    [theMovieView closeReopen];
    [self loadURL:tempURL firstTime:NO];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RebuildAllMenus" object:nil];

	if(aBool){
		if([theMovieView wasPlaying])
			[theMovieView start];
		else
			[theMovieView stop];
	} else
		[theMovieView start];
}

#pragma mark -
#pragma  mark Playlist

-(IBAction)openPlaylistDrawerConditional:(id)sender
{
    if([thePlaylist count] > 1)
        [thePlaylistDrawer open];
}

-(IBAction)togglePlaylistDrawer:(id)sender
{
    [thePlaylistDrawer toggle:sender];
}

-(IBAction)openPlaylistDrawer:(id)sender
{
    [thePlaylistDrawer open];
}

-(IBAction)closePlaylistDrawer:(id)sender
{
    [thePlaylistDrawer close:sender];
}

-(IBAction)choosePlaylistItem:(id)sender
{
    if([sender selectedRow] == -1)
		return;
		
	id tItem =[sender itemAtRow:[sender selectedRow]];
	
	if([[tItem objectForKey:@"type"] isEqualTo:@"chapter"]){
		if(![[[tItem objectForKey:@"parent"] objectForKey:@"url"] isEqualTo:theCurrentURL]){
			[self playAtIndex:[[[tItem objectForKey:@"parent"] objectForKey:@"index"] intValue]-1 obeyingPreviousState:NO];
		}
		[theMovieView gotoChapter:[[tItem objectForKey:@"index"] intValue]-1];
	}else{
		[self playAtIndex:[[tItem objectForKey:@"index"] intValue]-1 obeyingPreviousState:NO];
	}
		
}

-(IBAction)addToPlaylist:(id)sender
{
    id tempOpen = [[NSDocumentController sharedDocumentController] URLsFromRunningOpenPanel];
    if(tempOpen != nil){
        
        tempOpen= NPSortUrls(tempOpen);
        
        NSEnumerator* enumerator =[tempOpen objectEnumerator];
        NSURL* tempURL;
        
        
        while((tempURL = [enumerator nextObject])){
            [self addURLToPlaylist:tempURL];
        }
    }
}

-(void)addURLToPlaylist:(NSURL*)aURL
{
    [self addURLToPlaylist:(NSURL*)aURL atIndex:[thePlaylist count]];
}

-(void)addURLToPlaylist:(NSURL*)aURL atIndex:(int)anIndex
{
    if(anIndex == -1)
        anIndex = 0;
    
    if ([thePlaylist count]==0){
        if(theCurrentURL == nil)
            [self loadURL:aURL firstTime:NO];
        
        theCurrentURL = [aURL retain];
    }
    
    if(![thePlaylist containsObject:aURL]){
        [thePlaylist insertObject:aURL atIndex:anIndex];
        
					[[NSNotificationCenter defaultCenter] postNotificationName:@"RebuildAllMenus" object:nil];

    }
}

-(void)removeURLFromPlaylist:(NSURL*)aURL
{
    int tempIndex = [thePlaylist indexOfObject:aURL];
	if(tempIndex != NSNotFound)
		[self removeURLFromPlaylistHelperAtIndex:[NSIndexSet  indexSetWithIndex:tempIndex]];
}

-(void)removeURLFromPlaylistAtIndex:(int)anIndex
{
	[self removeURLFromPlaylistHelperAtIndex:[NSIndexSet  indexSetWithIndex:anIndex]];
	[self removeURLPlaceHolders];
}


-(void)removeURLFromPlaylistAtIndexSet:(NSIndexSet*)anIndex
{
	[self removeURLFromPlaylistHelperAtIndex:anIndex];
	[self removeURLPlaceHolders];
}

-(void)removeURLFromPlaylistHelperAtIndex:(NSIndexSet*)anIndex
{
	for(unsigned int i=0;i<[thePlaylist count];i++){
		if([anIndex containsIndex:i])
			[thePlaylist replaceObjectAtIndex:i withObject:[NSURL URLWithString:@"placeholder://URL_Placeholder"]];
	}
}

-(void)removeURLPlaceHolders
{
    [thePlaylist removeObject:[NSURL URLWithString:@"placeholder://URL_Placeholder"]];
    
    if([thePlaylist isEmpty]){
        [(NPMovieView *)theMovieView stop];
        [theMovieView closeReopen];
		[theSubtitle autorelease];
		theSubtitle =nil;
		theCurrentURL =nil;
    }
					[[NSNotificationCenter defaultCenter] postNotificationName:@"RebuildAllMenus" object:nil];
	
}

-(BOOL)isPlaylistEmpty
{
    return [thePlaylist isEmpty];
}

-(BOOL)loadPlaylistFromURL:(NSURL *)aURL
{
	NSData *plistData;
	NSString *error;
	NSPropertyListFormat format;
	id plist;
	plistData = [NSData dataWithContentsOfURL:aURL];
	plist = [NSPropertyListSerialization propertyListFromData:plistData
											 mutabilityOption:NSPropertyListImmutable
													   format:&format
											 errorDescription:&error];
	if (plist !=nil){
            id tMajorVersion = [plist objectForKey:@"MajorVersion"];
            if(tMajorVersion != nil && [tMajorVersion intValue] == 0 ){
                [playlistFilename release];
                playlistFilename = [aURL retain];
                [self setFileURL:playlistFilename];
                

                
                
                [thePlaylist release];
                thePlaylist = [[[[plist objectForKey:@"Contents"] objectForKey:@"Playlist"] collectUsingFunction:collectStringsToURLs context:nil]  mutableCopy];
                theRepeatMode = [[[plist objectForKey:@"Contents"] objectForKey:@"Repeat"] intValue];
                isRandom  = [[[plist objectForKey:@"Contents"] objectForKey:@"Random"] intValue];
                [self loadURL:[thePlaylist firstObject] firstTime:YES];
				[self resetRandom];
                [self refreshRepeatModeGUI];
					[[NSNotificationCenter defaultCenter] postNotificationName:@"RebuildAllMenus" object:nil];
                [theMovieView setVolume: [[[plist objectForKey:@"Contents"] objectForKey:@"Volume"] floatValue]];
                [[self window] updateVolume];

                return YES;
            }else{
                [[self window] displayAlertString:@"error opening playlist" withInformation:@"This file format needs a newer version of NicePlayer"];
                return NO;
            }
	} else {
		NSLog(@"Error Loading %@ %@", aURL,error);
            return NO;
	}
}

-(BOOL)hasPlaylist
{
	return (playlistFilename != nil);
}

-(float)volume
{
	return [theMovieView volume];
}


#pragma mark -
#pragma mark New DataSource Methods


- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)aTableColumn byItem:(id)item{
	if([[aTableColumn identifier] isEqualTo:@"index"]){
		if([[item objectForKey:@"type"] isEqualTo:@"chapter"]){
			if( [[item objectForKey:@"url"] isEqualTo:[theMovieView currentChapter]])
						            return [NSString stringWithFormat:@"%C", 0x2022];

			return @"";
			}
        return [item objectForKey:@"index"];
    }else if ([[aTableColumn identifier] isEqualTo:@"name"]){
					if([[item objectForKey:@"type"] isEqualTo:@"chapter"]){
								return [NSString stringWithFormat:@"   %@",[item objectForKey:@"self"],nil] ;

					}
	
			return [item objectForKey:@"self"] ;
    }else if ([[aTableColumn identifier] isEqualTo:@"status"]){
		if	([[item objectForKey:@"url"]  isEqual: theCurrentURL]) 
		            return [NSString stringWithFormat:@"%C", 0x2022];
		else
			return @"";
    }else if ([[aTableColumn identifier] isEqualTo:@"none"]){
			return @"" ;
    }else{
		return @"Error...";
	}

}



- (id)outlineView:(NSOutlineView *)outlineView child:(int)anIndex ofItem:(id)item{
	if(item == nil){
		NSDictionary* tRet =[NSDictionary dictionaryWithObjectsAndKeys:
		@"playlist",@"type",
		[[[thePlaylist objectAtIndex:anIndex] path] lastPathComponent],@"self",
		[NSNumber numberWithInt:anIndex+1],@"index",
		[thePlaylist objectAtIndex:anIndex],@"url",
		nil];
		
		[theDataSourceCache addObject:tRet];
		[theMainItemCache setObject:tRet forKey:[NSNumber numberWithInt:anIndex]];
		return tRet;

	}else if([[item objectForKey:@"url"] isEqualTo: theCurrentURL]){
		NSDictionary* tRet = [NSDictionary dictionaryWithObjectsAndKeys:
		@"chapter",@"type",
		item,@"parent",
		[[theMovieView chapters] objectAtIndex:anIndex],@"self",
		[NSNumber numberWithInt:anIndex+1],@"index",
		[[theMovieView chapters] objectAtIndex:anIndex],@"url",nil];
		[theDataSourceCache addObject:tRet];
		return tRet;

	}else{
		return nil;
	}

}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item{

	if(item == nil){
		return YES;
	}else if([[item objectForKey:@"url"]  isEqual: theCurrentURL]){
		return [[theMovieView chapters] count] > 0;
	}else{
		return NO;
	}

}


- (int)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item{

	if(item == nil){
		return [thePlaylist count];
	}else if([[item objectForKey:@"url"]  isEqual: theCurrentURL]){
		return [[theMovieView chapters] count];
	}else{
		return 0;
	}

}


- (BOOL)outlineView:(NSOutlineView *)outlineView 
acceptDrop:(id <NSDraggingInfo>)info 
item:(id)item childIndex:(int)anIndex{
    
    NSPasteboard *pboard = [info draggingPasteboard];	// get the paste board
	id tableSource = nil;
     tableSource = [info draggingSource] ;
	 if(tableSource !=nil && ![tableSource isKindOfClass:[NiceDocument class]]){
	    tableSource = [tableSource dataSource];
	 }
	 
    if([pboard availableTypeFromArray:[NSArray arrayWithObject: NSFilenamesPboardType]]){
        NSArray *urls = [pboard propertyListForType:NSFilenamesPboardType];
		NSMutableArray* mutUrls= [NSMutableArray array];
		BOOL tVerifyType = NO;
		urls =[urls injectUsingFunction:NPInjectNestedDirectories into:mutUrls context:&tVerifyType];
        urls = [urls collectUsingFunction:NPConvertFileNamesToURLs context:nil];
        
        NSEnumerator *enumerator = [urls reverseObjectEnumerator];
        id object;
        
	//	int tCount =[thePlaylist count];
        while ((object = [enumerator nextObject])) {
            [tableSource removeURLFromPlaylist:object];
			if(item == nil){
				[self addURLToPlaylist:object atIndex:anIndex];
			}else{
				[self addURLToPlaylist:object atIndex:[[item objectForKey:@"index"] intValue] ];
			}
        }
        
        [tableSource removeURLPlaceHolders];
        
		
		
        return YES;
    } 
    
    return NO;
}


- (BOOL)outlineView:(NSOutlineView *)outlineView 
writeItems:(NSArray *)items
 toPasteboard:(NSPasteboard *)pboard{
 
	NSMutableArray* fileArray = [NSMutableArray array];
	
	for(unsigned int i=0;i<[items count];i++){
		if([[[items objectAtIndex:i] objectForKey:@"type"] isEqualTo:@"playlist"]){
			[fileArray addObject:[[[items objectAtIndex:i] objectForKey:@"url"]path]];
		}
	}
	
    [pboard declareTypes: [NSArray arrayWithObjects: NSFilenamesPboardType, nil] owner: self];
    [pboard setPropertyList:fileArray forType:NSFilenamesPboardType];
	

	
    return [fileArray count] > 0;    
 
 }


- (NSArray *)outlineView:(NSOutlineView *)outlineView 
namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropDestination
		 forDraggedItems:(NSArray *)items{
	NSMutableArray* tArray = [NSMutableArray array];
	for(unsigned int i=0; i< [items count]; i++){
		[tArray addObject:[[items objectAtIndex:i] lastPathComponent]];
	}
	return tArray;
}
- (NSDragOperation)outlineView:(NSOutlineView *)tView 
validateDrop:(id <NSDraggingInfo>)info 
proposedItem:(id)tItem
 proposedChildIndex:(int)anIndex{

    if(tItem ==nil){
        id tItemDrop =[theMainItemCache objectForKey:[NSNumber numberWithInt:anIndex]] ;
        if(tItemDrop == nil)
            tItemDrop = [tView itemAtRow:[tView numberOfRows] -1];
        [tView setDropItem:tItemDrop dropChildIndex: 0];
	//	[tView setDropItem:[self outlineView:tView child:anIndex ofItem:tItem] dropChildIndex:0];
	}else if([[tItem objectForKey:@"type"] isEqualTo:@"chapter"]){
		tItem = [tItem objectForKey:@"parent"];
		[tView setDropItem:tItem dropChildIndex:0];
	}else{
		[tView setDropItem:tItem dropChildIndex:0];

    }

	
    return NSDragOperationGeneric;
}



#pragma mark -
#pragma mark Apple Remote Delegate Method

-(void)appleRemoteButton:(RemoteControlEventIdentifier)buttonIdentifier pressedDown:(BOOL)pressedDown 
{
#define REMOTE_FIRING_INTERVAL (0.2)
    switch(buttonIdentifier) {
	case kRemoteButtonPlus:
	    if(pressedDown){
		[theMovieView cancelPreviousPerformRequestsWithSelector:@"hideOverLayVolume"];
		[theMovieView incrementVolume];
		[[self window] automaticShowOverLayVolume];
		remoteEventTimer = [NSTimer scheduledTimerWithTimeInterval:REMOTE_FIRING_INTERVAL
								    target:theMovieView
								  selector:@selector(incrementVolume)
								  userInfo:nil
								   repeats:YES];
		    
	    } else {
		[remoteEventTimer invalidate];
		[theMovieView timedHideOverlayWithSelector:@"hideOverLayVolume"];
	    }
	    break;
	case kRemoteButtonMinus:
	    if(pressedDown){
		[theMovieView cancelPreviousPerformRequestsWithSelector:@"hideOverLayVolume"];
		[theMovieView decrementVolume];
		[[self window] automaticShowOverLayVolume];
		remoteEventTimer = [NSTimer scheduledTimerWithTimeInterval:REMOTE_FIRING_INTERVAL
								    target:theMovieView
								  selector:@selector(decrementVolume)
								  userInfo:nil
								   repeats:YES];
	    } else {
		[remoteEventTimer invalidate];
		[theMovieView timedHideOverlayWithSelector:@"hideOverLayVolume"];
	    }
	    break;			
	case kRemoteButtonMenu:
			if(!pressedDown){

	    [[self window] toggleWindowFullScreen];
			}
	    break;			
	case kRemoteButtonPlay:
			if(!pressedDown){
	    [[((NiceWindow *)[self window]) playButton] togglePlaying];
	    [((NiceWindow *)[self window]) automaticShowOverlayControllerWindow];
	    [theMovieView smartHideMouseOverOverlays];
			}
	    break;			
	case kRemoteButtonRight:
			if(!pressedDown){

	    [theMovieView playNextMovie];
	    [theMovieView smartHideMouseOverOverlays];
			}
	    break;			
	case kRemoteButtonLeft:
			if(!pressedDown){

	    [theMovieView playPrevMovie];
	    [theMovieView smartHideMouseOverOverlays];
			}
	    break;			
	case kRemoteButtonRight_Hold:
	    if(pressedDown){
		[theMovieView ffStart];
		remoteEventTimer = [NSTimer scheduledTimerWithTimeInterval:REMOTE_FIRING_INTERVAL
								    target:theMovieView
								  selector:@selector(ffDo)
								  userInfo:nil
								   repeats:YES];
	    } else {
		[remoteEventTimer invalidate];
		[theMovieView ffEnd];
		[theMovieView smartHideMouseOverOverlays];
	    }
	    break;	
	case kRemoteButtonLeft_Hold:
	    if(pressedDown){
		[theMovieView rrStart];
		remoteEventTimer = [NSTimer scheduledTimerWithTimeInterval:REMOTE_FIRING_INTERVAL
								    target:theMovieView
								  selector:@selector(rrDo)
								  userInfo:nil
								   repeats:YES];
	    } else {
		[remoteEventTimer invalidate];
		[theMovieView rrEnd];
		[theMovieView smartHideMouseOverOverlays];
	    }
	    break;			
	case kRemoteButtonPlay_Hold:
			if(!pressedDown){

	    [theMovieView cancelPreviousPerformRequestsWithSelector:@"hideOverLayVolume"];
	    [theMovieView toggleMute];
	    [theMovieView showOverLayVolume];
	    [theMovieView timedHideOverlayWithSelector:@"hideOverLayVolume"];
			}
	    break;			
	case kRemoteButtonMenu_Hold:
			if(!pressedDown){

	    [[self window] unFullScreen];
	    [[self window] performMiniaturize:self];
			}
	    break;
	case kRemoteControl_Switched:
	    break;
	default:
	    NSLog(@"Unmapped event for button %d", buttonIdentifier); 
	    break;
    }
}

@end
