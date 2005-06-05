/**
* NiceController.m
 * NicePlayer
 *
 * The NicePlayer document controller.
 */

#import "NiceController.h"
#import "Viewer Interface/NPPluginReader.h"
#import "../Other Sources/NiceUtilities.h"
#import "NPApplication.h"

id controller;

@implementation NiceController

#pragma mark Class Methods
+(id)controller
{
    return controller;
}

+(void)setController:(id)aNiceController
{
    controller = aNiceController;
}

#pragma mark Instance Methods
-(id)updateCheckPublicKey{return @"<30480241 00c3b3e5 eae022c2 fc065fe4 417c8edb fb2f6306 74e813ca a9860fe8 c677b735 87a7ad1f ef710ad0 eecabf9e 912487de d61de8d4 75d5dbd7 b42d985a 3810cd75 7f020301 0001>";}

-(void)awakeFromNib
{
    lastMouseLocation = NSMakePoint(0,0);
    fullScreenMode =  NO;
    showingMenubar = NO;
    mouseMoveTimer = [NSTimer scheduledTimerWithTimeInterval:.2
                                                      target:self
                                                    selector:@selector(checkMouseLocation:)
                                                    userInfo:nil repeats:YES]; // Auto-hides mouse.
    lastCursorMoveDate = [[NSDate alloc] init];
    backgroundWindow = [[BlackWindow alloc] init];
    backgroundWindows = nil;
    presentWindow = nil;
    [NiceController setController:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changedWindow:)
                                                 name:@"NSWindowDidBecomeMainNotification"
                                               object:nil];
    antiSleepTimer = [NSTimer scheduledTimerWithTimeInterval:30.0
                                                      target:self
                                                    selector:@selector(preventSleep:)
                                                    userInfo:nil repeats:YES];
    [NSApp setDelegate:self];
}

-(void)dealloc{
    [mouseMoveTimer invalidate];
    [antiSleepTimer invalidate];
    [lastCursorMoveDate release];
    [backgroundWindows release];
    [super dealloc];
}

-(id)mainWindowProxy
{
    return mainWindowProxy;
}

-(int)runModalOpenPanel:(NSOpenPanel *)openPanel forTypes:(NSArray *)openableFileExtensions
{
    [openPanel setAllowsMultipleSelection:YES];
    [openPanel setCanChooseDirectories:YES];
    [openPanel setCanChooseFiles:YES];
    
    return [super runModalOpenPanel:openPanel
                           forTypes:[[NPPluginReader pluginReader] allowedExtensions]];
}

/**
* Takes an array of NSString files, converts them to NSURLs and opens them, adding subsequent files to the
 *	playlist.
 */
-(void)openFiles:(NSArray *)files
{
    files =[files collectUsingFunction:NPConvertFileNamesToURLs context:nil];
    files= NPSortUrls(files);
	[self openURLs:files];
}

-(void)openURLs:(NSArray *)files
{
    id tempDoc = nil;
    unsigned i;
    
    for (i = 0; i < [files count]; i++){
        id tempURL = [files objectAtIndex:i];
        if([[Preferences mainPrefs] defaultOpenMode] || (([[[[tempURL path] pathExtension] lowercaseString] isEqualTo:@"nicelist"]) && i !=0 )){
            [self openDocumentWithContentsOfURL:tempURL display:YES];
            continue;
        }
        if(i==0){
            id docArray = [NSApp orderedDocuments];
            if([docArray count] > 0){
                id document = [docArray objectAtIndex:0];
                if(([document isKindOfClass:[NiceDocument class]]) && ![document isActive])
                    tempDoc = document;
                else
                    tempDoc = [self openDocumentWithContentsOfURL:tempURL display:YES];
            } else
                tempDoc = [self openDocumentWithContentsOfURL:tempURL display:YES];
            
            if(![[[[tempURL path] pathExtension] lowercaseString] isEqualTo:@"nicelist"])
                [tempDoc loadURL:tempURL firstTime:YES];
            else if(![tempDoc isActive])
                [tempDoc readFromURL:tempURL ofType:@"nicelist"];
            
            if([[self mainDocument] isActive]){
                if([[Preferences mainPrefs] movieOpenedFullScreen])
                    [self enterFullScreen];
                if([[Preferences mainPrefs] movieOpenedPlay])
                    [[self mainDocument] play:self];
            }
        } else
            [tempDoc addURLToPlaylist:tempURL];
    }
    

	[tempDoc openPlaylistDrawerConditional:self];
}

-(void)checkMouseLocation:(id)sender
{
    NSRect tempRect =[[[NSScreen screens] objectAtIndex:0] frame];
    NSPoint tempPoint =[NSEvent mouseLocation];
    if(!NSEqualPoints(lastMouseLocation,tempPoint)){
        [lastCursorMoveDate release];
        lastCursorMoveDate = [[NSDate alloc] init];
        lastMouseLocation= tempPoint;
        [NSCursor setHiddenUntilMouseMoves:NO];
    }else{
        if(fullScreenMode && ([lastCursorMoveDate timeIntervalSinceNow] < -3)){
            [NSCursor setHiddenUntilMouseMoves:YES];
        }
    }
    
    tempRect.origin.y=tempRect.size.height -24;
    tempRect.size.height =32;
}

/* As per Technical Q&A QA1160: http://developer.apple.com/qa/qa2004/qa1160.html */
-(void)preventSleep:(id)sender
{

    BOOL detectIsPlaying(id each, void* context){
        return [each isPlaying];
    }

    if([[NSApp orderedDocuments] detectUsingFunction:detectIsPlaying context:nil])
        UpdateSystemActivity(OverallAct);

}

-(id)mainDocument
{
    return [self documentForWindow:[NSApp mainWindow]];
}

-(void)changedWindow:(NSNotification *)notification
{
    if([[NSApp mainWindow] isKindOfClass:[NiceWindow class]]){
        [toggleOnTopMenuItem setState:[((NiceWindow *)[NSApp mainWindow]) windowIsFloating]];
        [toggleFixedAspectMenuItem setState:[((NiceWindow *)[NSApp mainWindow]) windowIsFixedAspect]];
    }
}

#pragma mark Interface

-(IBAction)openDocument:(id)sender
{
    NSArray* tempFiles = [self fileNamesFromRunningOpenPanel];
				
    [self openFiles:tempFiles];
}

-(IBAction)newDocument:(id)sender
{
    [super newDocument:sender];
    id tempWindow =[NSApp mainWindow];
    [NSApp changeWindowsItem:tempWindow title:[tempWindow title] filename:NO];
}

-(IBAction)presentMultiple:(id)sender
{
    
    if(fullScreenMode){
        [self exitFullScreen];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PresentMultiple" object:nil];
        [self presentAllScreeens];
        if([[Preferences mainPrefs] autoplayOnFullScreen]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayAllMovies" object:nil];
        }
    }
}

-(IBAction)playAll:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayAllMovies" object:nil];
}

-(IBAction)stopAll:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StopAllMovies" object:nil];
}


-(IBAction)toggleFullScreen:(id)sender
{
    if(fullScreenMode){
        [self exitFullScreen];
    }else if([[NSApp mainWindow] isKindOfClass:[NiceWindow self]]){
        [self enterFullScreen];
    }
}

-(IBAction)showPreferences:(id)sender
{
    if(prefWindow ==nil)
	prefWindow = [[[NSWindowController alloc] initWithWindowNibName:@"Preferences"] retain];
    [prefWindow showWindow:self];
    if(fullScreenMode)
	[self exitFullScreen];
    [[prefWindow window] setLevel:NSFloatingWindowLevel];
    [[prefWindow window] makeKeyAndOrderFront:self];
}

-(IBAction)toggleAlwaysOnTop:(id)sender
{
    [((NiceWindow *)[NSApp mainWindow]) toggleWindowFloat];
    [toggleOnTopMenuItem setState:[((NiceWindow *)[NSApp mainWindow]) windowIsFloating]];
}

-(IBAction)toggleFixedAspectRatio:(id)sender
{
    [((NiceWindow *)[NSApp mainWindow]) toggleFixedAspectRatio];
    [toggleFixedAspectMenuItem setState:[((NiceWindow *)[NSApp mainWindow]) windowIsFixedAspect]];
}

-(IBAction)openWebURL:(id)sender
{
	NSURL *newURL = [NSURL URLWithString:[openURLField stringValue]];
	[self openURLs:[NSArray arrayWithObjects:newURL, nil]];
	[openURLWindow performClose:self];
}

#pragma mark -
#pragma mark Presentation

-(void)presentScreen
{
    fullScreenMode = YES;
    if([[NSScreen mainScreen] isEqualTo:[[NSScreen screens] objectAtIndex:0]])
        SetSystemUIMode(kUIModeAllHidden, kUIOptionAutoShowMenuBar);
    
    [backgroundWindow setFrame:[[NSScreen mainScreen] frame] display:YES];
    [backgroundWindow orderBack:nil];
}

-(void)presentAllScreeens
{
    id makeBackgrounds(id each, void* context){
        id tBWindow = [[BlackWindow alloc] init];
        [tBWindow setReleasedWhenClosed:YES];
        [tBWindow setFrame:[each frame] display:YES];
        [tBWindow orderBack:nil];
        return tBWindow;
    }
    backgroundWindows = [[[NSScreen screens] collectUsingFunction:makeBackgrounds context:nil] retain];
    
    fullScreenMode = YES;
    
    SetSystemUIMode(kUIModeAllHidden, kUIOptionAutoShowMenuBar);
}


-(void)unpresentAllScreeens
{
    [backgroundWindows makeObjectsPerformSelector:@selector(close)];
    
    [backgroundWindows release];
    backgroundWindows = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"unPresentMultiple" object:nil];
    
}

-(void)unpresentScreen
{
    fullScreenMode = NO;
    showingMenubar = NO;
    SetSystemUIMode(kUIModeNormal, kUIModeNormal);
    [backgroundWindow orderOut:nil];
    [self unpresentAllScreeens];
}

-(void)enterFullScreen
{
    id tempWindow = [NSApp bestMovieWindow];
    [tempWindow makeFullScreen];
    [self presentScreen];
    [backgroundWindow setPresentingWindow:tempWindow];
}

-(void)exitFullScreen
{
    id tempWindow = [NSApp bestMovieWindow];
    if(tempWindow != nil)
        [tempWindow makeNormalScreen];
    [self unpresentScreen];
}

#pragma mark -
#pragma mark Accessor Methods

-(id)backgroundWindow
{
    return backgroundWindow;
}

- (BOOL)respondsToSelector:(SEL)aSelector{
    
    NSString* aString = NSStringFromSelector(aSelector);
    if([aString hasPrefix:@"ALL"]){
        return YES;
    }else{
        return [super respondsToSelector:aSelector];
    }
    
}

-(IBAction)dummyMethod:(id)temp{
    
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    NSString* aString = NSStringFromSelector(aSelector);
    
    id tSig =[super methodSignatureForSelector:aSelector];
    
    if(tSig == nil && [aString hasPrefix:@"ALL"]){
        
        return [super methodSignatureForSelector:@selector(dummyMethod:)];
    }else{
        
        return tSig;
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    
    NSString* aString = NSStringFromSelector([anInvocation selector]);
    if([aString hasPrefix:@"ALL"] ){//&& [[anInvocation methodSignature]numberOfArguments]==3 && *[[anInvocation methodSignature]getArgumentTypeAtIndex:2]==NSObjCObjectType
        NSObject* anArgumet = nil;
        
        [anInvocation getArgument:&anArgumet atIndex:2];
        
        
        id swapForWindows(id each, void* context){
            
            return [each window];
            
        }
        
        aString = [aString substringFromIndex:3];
        
        [[[self documents] collectUsingFunction:swapForWindows context:nil] makeObjectsPerformSelector:NSSelectorFromString(aString) withObject:nil];
    }else{
        [super forwardInvocation:anInvocation];
    }    
}

@end
