/**
* NiceDocument.m
 * NicePlayer
 *
 * The document subclass containing the NicePlayer document features.
 */

#import "NiceDocument.h"
#import "NiceUtilities.h"
#import "NiceWindow/NiceWindowController.h"
id rowsToFileNames(id obj, void* playList){
    return [[(id)playList objectAtIndex:[obj intValue]] path];
}
#import "NPApplication.h"

@implementation NiceDocument

- (id)init
{
    if(self = [super init]){
        hasRealMovie = NO;
        isRandom = NO;
        theSubtitle = nil;
        asffrrTimer = nil;
        thePlaylist = [[NSMutableArray alloc] init];
        theRepeatMode = [[Preferences mainPrefs] defaultRepeatMode];
        movieMenuItem = nil;
        menuObjects = nil;
        playlistFilename = nil;
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
    [theSubtitle release];
    [theCurrentURL release];
    [thePlaylist release];
    [super dealloc];
}

- (id)initWithContentsOfFile:(NSString *)fileName ofType:(NSString *)docType
{
    if(self = [super initWithContentsOfFile:fileName ofType:docType]){
    }
    return self;
}

- (id)initWithContentsOfURL:(NSURL *)aURL ofType:(NSString *)docType
{
    if(self = [super initWithContentsOfFile:[aURL absoluteString] ofType:docType]){
    }
    return self;
}

#pragma mark -
#pragma mark File Operations

- (NSData *)dataRepresentationOfType:(NSString *)aType
{
    // Insert code here to write your document from the given data.  You can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.
    
    id collectURLToStrings(id each, void*context){
        return [each absoluteString];
    }
    
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
    
    if([[docType lowercaseString] isEqualTo:@"nicelist"]){
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
        /* Didn't load, so set a blank image thing. */
        [theMovieView initWithFrame:NSMakeRect(0, 0, [theWindow frame].size.width, [theWindow frame].size.height)];
        return NO;
    } else
        hasRealMovie = YES;
    
    /* Try to load the subtitles */
    NSString* srtPath = [[[theCurrentURL path] stringByDeletingPathExtension] stringByAppendingPathExtension:@"srt"];
    NSString* subPath = [[[theCurrentURL path] stringByDeletingPathExtension] stringByAppendingPathExtension:@"sub"];
    
    [theSubtitle autorelease];
    if([[NSFileManager defaultManager] fileExistsAtPath:srtPath]){
        theSubtitle = [[Subtitle alloc] initWithFile:srtPath forMovieSeconds:(float)[theMovieView totalTime]];
    }else if ([[NSFileManager defaultManager] fileExistsAtPath:subPath]){
        theSubtitle = [[Subtitle alloc] initWithFile:subPath forMovieSeconds:(float)[theMovieView totalTime]];
    }else{
        theSubtitle = nil;
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

- (void)windowDidDeminiaturize:(NSNotification *)aNotification
{
    [theWindow restoreVolume];
    [theMovieView start];
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];

    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    if(theCurrentURL != nil){
        [self finalOpenURLFirstTime:YES];
    } else {
        [NSApp addWindowsItem:theWindow title:@"NicePlayer" filename:NO];
    }
    
    [self updateAfterLoad];
	[self repositionAfterLoad];
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

}


- (void)repositionAfterLoad{
    
    int tScreenPref = -1;
    
    NSScreen* tScreen = [NSScreen mainScreen];
    NSArray* tScreens = [NSScreen screens];
    
    if(tScreenPref > 0 && (tScreenPref < (int)[tScreens count])){
        tScreen = [tScreens objectAtIndex:tScreenPref];
    }  
        
    NSValue* tPoint = nil;
    
    BOOL rejectSelf(id each,void* context){
        return [each isEqual:[self window]];
    }
    
    NSArray* tMovieWindows = [[NSApp movieWindows] rejectUsingFunction:rejectSelf context:nil];
    
    NSRect tSubScreenRect;
    
    BOOL findOpenPoint(id eachwin, void* context){
        NSRect tWinRect = [eachwin frame];
        NSRect tNewRect = NSMakeRect([tPoint pointValue].x,[tPoint pointValue].y,[[self window] frame].size.width,[[self window] frame].size.height);
        
        return NSIntersectsRect(tWinRect,tNewRect) || !NSContainsRect(tSubScreenRect,tNewRect);
    }
    
    void findSpace(id each, void* context, BOOL* endthis){
        tSubScreenRect = [each visibleFrame];
        for(float j = tSubScreenRect.origin.y + tSubScreenRect.size.height - [[self window] frame].size.height; j >= tSubScreenRect.origin.y; j -= [[self window] frame].size.height){
            for(float i = tSubScreenRect.origin.x; i < tSubScreenRect.origin.x + tSubScreenRect.size.width; i+= [[self window] frame].size.width){
                tPoint= [NSValue valueWithPoint:NSMakePoint(i,j)];
                if(nil == [tMovieWindows detectUsingFunction:findOpenPoint context:nil]){
                    STDoBreak(endthis);
                }
                tPoint = nil;
            }
        }
    }
    
    int sortByMain(id v1, id v2, void* context){
        if([v1 isEqualTo:v2])
            return NSOrderedSame;
        if([[NSScreen mainScreen] isEqualTo: v1]){
            return NSOrderedAscending;
        }
        
        return NSOrderedAscending;
    }
    
    if(tScreenPref < 0){
        id tArray =[[NSScreen screens] sortedArrayUsingFunction:sortByMain context:nil];
        [tArray doUsingFunction:findSpace context:nil];
    }else{
        BOOL tDummy;
        findSpace(tScreen,nil,&tDummy);
    }
    
    if(tPoint == nil){
        BOOL findWindowScreen(id each, void* context){
            return [[each screen] isEqual:tScreen];
        }
        id tWindow = [[NSApp movieWindows] detectUsingFunction:findWindowScreen context:nil];
        [[self window] cascadeTopLeftFromPoint:[tWindow frame].origin];
    }else{
        [[self window] setFrameOrigin:[tPoint pointValue]];
    }
    
    
}

- (void)makeWindowControllers{
    [self addWindowController:[[[NiceWindowController alloc] initWithWindowNibName:@"NiceDocument" owner:self] autorelease]];
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
        if([theMovieView wasPlaying])
            [self playNext];
    }
}

-(id)subTitle
{
    return theSubtitle;
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
        
        
        while(tempURL = [enumerator nextObject]){
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
            NSLog(@"test");
            id tMajorVersion = [plist objectForKey:@"MajorVersion"];
            if(tMajorVersion != nil && [tMajorVersion intValue] == 0 ){
                [playlistFilename release];
                playlistFilename = [aURL retain];
                [self setFileURL:playlistFilename];
                
                id collectStringsToURLs(id each, void* context){
                    return [NSURL URLWithString:each];
                }
                
                
                [thePlaylist release];
                thePlaylist = [[[[plist objectForKey:@"Contents"] objectForKey:@"Playlist"] collectUsingFunction:collectStringsToURLs context:nil]  mutableCopy];
                theRepeatMode = [[[plist objectForKey:@"Contents"] objectForKey:@"Repeat"] intValue];
                isRandom  = [[[plist objectForKey:@"Contents"] objectForKey:@"Random"] intValue];
                [self loadURL:[thePlaylist firstObject] firstTime:YES];
                [self refreshRepeatModeGUI];
                [thePlaylistTable reloadData];

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
            return @"¥";
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
        
        while (object = [enumerator nextObject]) {
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

@end
