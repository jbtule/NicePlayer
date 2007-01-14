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

#import "NiceDocument.h"
#import "NiceUtilities.h"
#import "NiceWindow/NiceWindowController.h"
#import "AppleRemote.h"
#import "ControlPlay.h"

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
    [theCurrentURL release];
    [thePlaylist release];
    [playlistFilename release];
    [theID release];
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
    NSString* srtPath = [[[theCurrentURL path] stringByDeletingPathExtension] stringByAppendingPathExtension:@"srt"];
    NSString* subPath = [[[theCurrentURL path] stringByDeletingPathExtension] stringByAppendingPathExtension:@"sub"];
	NSString* ssaPath = [[[theCurrentURL path] stringByDeletingPathExtension] stringByAppendingPathExtension:@"ssa"];

    [theSubtitle autorelease];
    if([[NSFileManager defaultManager] fileExistsAtPath:srtPath]){
        theSubtitle = [[Subtitle alloc] initWithFile:srtPath forMovieSeconds:(float)[theMovieView totalTime]];
    }else if ([[NSFileManager defaultManager] fileExistsAtPath:subPath]){
        theSubtitle = [[Subtitle alloc] initWithFile:subPath forMovieSeconds:(float)[theMovieView totalTime]];
    }else if ([[NSFileManager defaultManager] fileExistsAtPath:ssaPath]){
        theSubtitle = [[Subtitle alloc] initWithFile:ssaPath forMovieSeconds:(float)[theMovieView totalTime]];
    }else{
        theSubtitle = nil;
    }
	
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
    } else {
		// Why was this here? It's make NP crash.
        //[self finalOpenURLFirstTime:YES];
    }
    
    [self updateAfterLoad];
	[self repositionAfterLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(windowWillClose:)
												 name:NSWindowWillCloseNotification
											   object:[self window]];		
}

-(void)windowWillClose:(NSNotification *)aNotification
{
	if([[Preferences mainPrefs] audioVolumeSimilarToLastWindow]){
		[[Preferences mainPrefs] setDefaultAudioVolume:[theMovieView volume]];
	}
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
    
    [self refreshRepeatModeGUI];
    [self calculateAspectRatio];

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
    return [[theSubtitle retain] autorelease];
}

-(NSMenu *)movieMenu
{
    return [[[NSApp mainMenu] itemWithTitle:@"Movie"] submenu];
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
    
    movieMenuItem = [[NSMenuItem alloc] initWithTitle:[theMovieView menuTitle]
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
        [movieMenuItem setEnabled:YES];
        id mSubMenu = [[NSMenu alloc] initWithTitle:[theMovieView menuTitle]];
        [movieMenuItem setSubmenu:mSubMenu];
        [[self movieMenu] insertItem:movieMenuItem atIndex:[[self movieMenu] numberOfItems]];
        while([mSubMenu numberOfItems] > 0)
            [mSubMenu removeItemAtIndex:0];
        
        for(i = 0; i < (int)[pluginMenu count]; i++)
            [mSubMenu addItem:[pluginMenu objectAtIndex:i]];
    }
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

#pragma mark Interface

-(IBAction)toggleRandomMode:(id)sender
{
    if(isRandom)
        isRandom = NO;
    else
        isRandom = YES;
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



-(unsigned)getNextIndex
{
    int anIndex = [thePlaylist indexOfObject:theCurrentURL];
    
    if([thePlaylist isEmpty])
        return -1;
    
    if(isRandom){
        anIndex = ((float)random()/RAND_MAX)*[thePlaylist count];
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

/**
* Responsible for controlling what to do when a playlist item is changed.
 */
-(void)playAtIndex:(unsigned int)anIndex obeyingPreviousState:(BOOL)aBool
{
    id tempURL = [thePlaylist objectAtIndex:anIndex];
    [theMovieView closeReopen];
    [self loadURL:tempURL firstTime:NO];
    [thePlaylistTable reloadData];
    
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
    [self playAtIndex:[sender selectedRow] obeyingPreviousState:NO];
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
        
        [thePlaylistTable reloadData];
    }
}

-(void)removeURLFromPlaylist:(NSURL*)aURL
{
    int tempIndex = [thePlaylist indexOfObject:aURL];
    [thePlaylist replaceObjectAtIndex:tempIndex withObject:@"URL Placeholder"];
}

-(void)removeURLFromPlaylistAtIndex:(int)anIndex
{
    [thePlaylist replaceObjectAtIndex:anIndex withObject:@"URL Placeholder"];
	[self removeURLPlaceHolders];
}

-(void)removeURLPlaceHolders
{
    [thePlaylist removeObject:@"URL Placeholder"];
    [thePlaylistTable reloadData];
    
    if([thePlaylist isEmpty]){
        [(NPMovieView *)theMovieView stop];
        [theMovieView openURL:[NPMovieView blankImage]];
    }
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
                [self refreshRepeatModeGUI];
                [thePlaylistTable reloadData];
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
#pragma mark Data Views

- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [thePlaylist count];    
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex
{
    if([[aTableColumn identifier] isEqualTo:@"index"])
        return [NSNumber numberWithInt:rowIndex +1];
    else if ([[aTableColumn identifier] isEqualTo:@"name"])
        return [[[thePlaylist objectAtIndex:rowIndex]path] lastPathComponent];
    else if ([[aTableColumn identifier] isEqualTo:@"status"]){
        if ([[thePlaylist objectAtIndex:rowIndex] isEqualTo:theCurrentURL])
            return [NSString stringWithFormat:@"%C", 0x2022];
    else
    return @"";
    }else
    return @"error";
}

- (BOOL)tableView:(NSTableView *)tableView 
       acceptDrop:(id <NSDraggingInfo>)info
              row:(int)row dropOperation:(NSTableViewDropOperation)operation{
    
    NSPasteboard *pboard = [info draggingPasteboard];	// get the paste board
    id tableSource = [[info draggingSource] dataSource];
    
    if([pboard availableTypeFromArray:[NSArray arrayWithObject: NSFilenamesPboardType]]){
        NSArray *urls = [pboard propertyListForType:NSFilenamesPboardType];
        urls = [urls collectUsingFunction:NPConvertFileNamesToURLs context:nil];
        
        NSEnumerator *enumerator = [urls reverseObjectEnumerator];
        id object;
        
        while ((object = [enumerator nextObject])) {
            [tableSource removeURLFromPlaylist:object];
            [self addURLToPlaylist:object atIndex:row];
        }
        
        [tableSource removeURLPlaceHolders];
        
        return YES;
    } 
    
    return NO;
}

- (BOOL)tableView:(NSTableView *)tableView 
        writeRows:(NSArray *)rows 
     toPasteboard:(NSPasteboard *)pboard
{
    id fileArray = [rows collectUsingFunction:rowsToFileNames context:thePlaylist];
    [pboard declareTypes: [NSArray arrayWithObjects: NSFilenamesPboardType, nil] owner: self];
    [pboard setPropertyList:fileArray forType:NSFilenamesPboardType];
    
    return YES;    
}


- (NSDragOperation) tableView: (NSTableView *) view
                 validateDrop: (id <NSDraggingInfo>) info
                  proposedRow: (int) row
        proposedDropOperation: (NSTableViewDropOperation) operation
{
    [view setDropRow: row dropOperation: NSTableViewDropAbove];
    return NSDragOperationGeneric;
}

#pragma mark -
#pragma mark Apple Remote Delegate Method

-(void)appleRemoteButton:(AppleRemoteEventIdentifier)buttonIdentifier pressedDown:(BOOL)pressedDown 
{
#define REMOTE_FIRING_INTERVAL (0.2)
    switch(buttonIdentifier) {
	case kRemoteButtonVolume_Plus:
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
	case kRemoteButtonVolume_Minus:
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
	    [[self window] toggleWindowFullScreen];
	    break;			
	case kRemoteButtonPlay:
	    [[((NiceWindow *)[self window]) playButton] togglePlaying];
	    [((NiceWindow *)[self window]) automaticShowOverLayWindow];
	    [theMovieView smartHideMouseOverOverlays];
	    break;			
	case kRemoteButtonRight:
	    [theMovieView playNextMovie];
	    [theMovieView smartHideMouseOverOverlays];
	    break;			
	case kRemoteButtonLeft:
	    [theMovieView playPrevMovie];
	    [theMovieView smartHideMouseOverOverlays];
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
	case kRemoteButtonPlay_Sleep:
	    [theMovieView cancelPreviousPerformRequestsWithSelector:@"hideOverLayVolume"];
	    [theMovieView toggleMute];
	    [theMovieView showOverLayVolume];
	    [theMovieView timedHideOverlayWithSelector:@"hideOverLayVolume"];
	    break;			
	case kRemoteButtonMenu_Hold:
	    [[self window] unFullScreen];
	    [[self window] performMiniaturize:self];
	    break;
	case kRemoteControl_Switched:
	    break;
	default:
	    NSLog(@"Unmapped event for button %d", buttonIdentifier); 
	    break;
    }
}

@end
