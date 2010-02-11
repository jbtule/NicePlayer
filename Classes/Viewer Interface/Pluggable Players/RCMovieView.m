/**
 * RCMovieView.m
 * NicePlayer
 *
 * An implementation of a QTKit movie view for NicePlayer.
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



#import "RCMovieView.h"


@interface QTMovie(ChapterAdditions)
-(BOOL)hasChapters;
-(NSArray*)chapterList;
-(int)currentChapterIndex;
@end

@interface QTMovie(IdlingAdditions)
-(BOOL)idling;
-(QTTime)maxTimeLoaded;
@end

@implementation RCMovieView

+(NSDictionary *)plugInfo
{
    NSArray *extensions = [NSArray arrayWithObjects:
        /* File extensions */
        @"avi", @"mov", @"qt", @"mpg", @"mpeg", @"m15", @"m75", @"m2v", @"3gpp", @"mpg4", @"mp4",@"mkv",@"flv",@"divx",@"m4v",
        //Commenting out image types as this view isn't design well for them,even though it will display them
        // @"png", @"gif", @"bmp", @"tif", @"pic", @"pct", @"pict", @"jpg", @"jpeg", @"qtif",
        @"swf", @"fli", @"flc", @"dv", @"wmv",@"asf",@"ogg",
        /* Finder types */
        @"VfW", @"MooV", @"MPEG", @"m2v ", @"mpg4", @"SWFL", @"FLI ", @"dvc!",@"ASF_", 
        //@"PNG ", @"GIF ", @"GiFf", @"BMP ", @"TIFF", @"PICT",@"JPEG", @"qtif",
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
	[film release];
	film = [[QTMovie movieWithURL:url error:nil] retain];
    return (film) ? YES : NO;
}

-(NSArray*)_chapters{
	NSArray* tArray =[film chapterList];
	NSMutableArray* tMutArray = [NSMutableArray array];
	for(uint i=1; i<=[tArray count];i++){
		NSString* tName =[[tArray objectAtIndex:i-1] objectForKey:@"Name"];
		if(tName == nil){
			[tMutArray addObject:[NSString stringWithFormat:@"Chapter %d",i,nil]];
		}else{
			[tMutArray addObject:tName];
		}
	}

	return tMutArray;
}


-(void)_gotoChapter:(NSNumber*)anIndex{
	
	id tObj = [[film chapterList] objectAtIndex:[anIndex intValue]];
	[self setCurrentMovieTimePrecise:[[tObj objectForKey:@"StartTime"] longValue
	]];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"RebuildAllMenus" object:self];
}

-(NSString*)_currentChapter{
	return [[self _chapters] objectAtIndex:[film currentChapterIndex] -1];
}

-(id)initWithFrame:(NSRect)frame
{
    if (floor(NSAppKitVersionNumber) <= NSAppKitVersionNumber10_3) /* QTKit won't load on anything less than 10.4 Tiger. */
	return nil;

    if((self = [super initWithFrame:frame])){
		
	qtView = [[QTMovieView alloc] initWithFrame:frame];
	[self addSubview:qtView];
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
	[self close];
    [super dealloc];
}

-(void)close
{
	[film release];
	film =nil;
	[qtView setMovie:nil];
	[qtView release];
	[qtView removeFromSuperviewWithoutNeedingDisplay];
	qtView = nil;
}

-(BOOL)loadMovie
{
    [qtView setMovie:film];
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
    NSSize tSize = NSMakeSize((float)(aRect.right - aRect.left),
                              (float)(aRect.bottom - aRect.top));
    SampleDescriptionHandle anImageDesc = NULL;
    
    @try{
        NSArray* tArray = [film tracksOfMediaType:QTMediaTypeVideo];
	QTTrack* tTrack = nil;
	if([tArray count] > 0)
	    tTrack = [tArray objectAtIndex:0];
        
        if(tTrack != nil ){
            anImageDesc = (SampleDescriptionHandle)NewHandle(sizeof(SampleDescription));
            GetMediaSampleDescription([[tTrack media] quickTimeMedia], 1, anImageDesc);    
            
            
            NSString* tName = (NSString *)CFStringCreateWithPascalString(NULL,
		(*(ImageDescriptionHandle)anImageDesc)->name, kCFStringEncodingMacRoman);

            if([tName hasPrefix:@"DV/DVCPRO"]){
                PixelAspectRatioImageDescriptionExtension pixelAspectRatio;
                OSStatus status;
                
                status = ICMImageDescriptionGetProperty((ImageDescriptionHandle)anImageDesc, // image description
                                                        kQTPropertyClass_ImageDescription, // class
                                                                                           // 'pasp' image description extention property
                                                        kICMImageDescriptionPropertyID_PixelAspectRatio,
                                                        sizeof(pixelAspectRatio), // size
                                                        &pixelAspectRatio,        // returned value
                                                        NULL);                    // byte count
                float tRatio = ((float)(pixelAspectRatio.hSpacing)) / pixelAspectRatio.vSpacing;
                    tSize = NSMakeSize(tRatio* tSize.width,tSize.height);
            }
			[tName release];
        }
    }@catch(NSException *exception) {}
    @finally{
	if(anImageDesc)
	    DisposeHandle((Handle)anImageDesc);
        return tSize;
    }
    
}

//-(void)setLoopMode:
//This looping code is probably not a good idea as niceplayer has code that loops exteriorly to this. But that's just me noticing it, I haven't seen any actually problems use wise yet. It probably should just be a variable. -Jay
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


//until re do the plugin interface
//this is a quick hack to allow percent loading
//for plugins
-(NSNumber*)_percentLoaded{
				
			NSTimeInterval tMaxLoaded;
			NSTimeInterval tDuration;
			
			QTGetTimeInterval([film duration], &tDuration);
			QTGetTimeInterval([film maxTimeLoaded], &tMaxLoaded);
			


	return [NSNumber numberWithDouble: (double) tMaxLoaded/tDuration];
}

-(double)currentMovieFrameRate{
    int sampleSize =5;
    OSType myTypes[1];
    Movie tempMovie = [film quickTimeMovie];
    TimeValue newTime=1;
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
	
	if([film hasChapters]){
		newItem = [[[NSMenuItem alloc] initWithTitle:@"Chapter"
											  action:NULL
									   keyEquivalent:@""] autorelease];
		[newItem setTarget:self];
		
		[newItem setSubmenu:[self chapterTrackMenu]];
		
		[pluginMenu addObject:newItem];
	}
	
	
		newItem = [[[NSMenuItem alloc] initWithTitle:@"Video Tracks"
                                          action:NULL
                                   keyEquivalent:@""] autorelease];
    [newItem setTarget:self];
	
	[newItem setSubmenu:[self videoTrackMenu]];
	
    [pluginMenu addObject:newItem];
	
		newItem = [[[NSMenuItem alloc] initWithTitle:@"Audio Tracks"
                                          action:NULL
                                   keyEquivalent:@""] autorelease];
    [newItem setTarget:self];
	
	[newItem setSubmenu:[self audioTrackMenu]];
	
    [pluginMenu addObject:newItem];
	
    
   /* newItem = [[[NSMenuItem alloc] initWithTitle:@"Play Movie Preview"
                                          action:@selector(playMoviePreview)
                                   keyEquivalent:@""] autorelease];
    [newItem setTarget:self];
    [pluginMenu addObject:newItem];
    
    newItem = [[[NSMenuItem alloc] initWithTitle:@"Go to Movie Poster Frame"
                                          action:@selector(gotoMoviePosterFrame)
                                   keyEquivalent:@""] autorelease];
    [newItem setTarget:self];
    [pluginMenu addObject:newItem];
	
	*/
    
    return [pluginMenu autorelease];
}

-(NSMenu*)audioTrackMenu{
		NSMenu* tReturnMenu =[[[NSMenu alloc]init] autorelease];
		NSArray* tArray = [film tracksOfMediaType:@"soun"];
		for(unsigned int i=0;i<[tArray count];i++){
			QTTrack* tTrack =[tArray objectAtIndex:i];
			NSDictionary* tDict = [tTrack trackAttributes];
			NSMenuItem* tItem =[[[NSMenuItem alloc] initWithTitle:[tDict objectForKey:@"QTTrackDisplayNameAttribute"]
			action:@selector(toggleTrack:)
			keyEquivalent:@""] autorelease];
			[tItem setRepresentedObject:tTrack];
			[tItem setTarget:self];
			if([tTrack isEnabled]){
				[tItem setState:NSOnState]; 
			}
			
			[tReturnMenu addItem:tItem];
		}

return tReturnMenu;
}

-(NSMenu*)videoTrackMenu{
		NSMenu* tReturnMenu =[[[NSMenu alloc]init] autorelease];
		NSArray* tArray = [film tracksOfMediaType:@"vide"];
		for(unsigned int i=0;i<[tArray count];i++){
			QTTrack* tTrack =[tArray objectAtIndex:i];
			NSDictionary* tDict = [tTrack trackAttributes];
			NSMenuItem* tItem =[[[NSMenuItem alloc] initWithTitle:[tDict objectForKey:@"QTTrackDisplayNameAttribute"]
			action:@selector(toggleTrack:)
			keyEquivalent:@""] autorelease];
			[tItem setRepresentedObject:tTrack];
			[tItem setTarget:self];
			if([tTrack isEnabled]){
				[tItem setState:NSOnState]; 
			}
			
			
			[tReturnMenu addItem:tItem];
		}

return tReturnMenu;
}

-(IBAction)toggleTrack:(id)sender{
	[[sender representedObject] setEnabled:![[sender representedObject] isEnabled]];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RebuildAllMenus" object:self];
}

-(IBAction)goToChapter:(id)sender{
	[self setCurrentMovieTimePrecise:[[[sender representedObject] objectForKey:@"StartTime"] longValue
	]];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"RebuildAllMenus" object:self];

}

-(NSMenu*)chapterTrackMenu{
	NSMenu* tReturnMenu =[[[NSMenu alloc]init] autorelease];
		NSArray* tArray = [film chapterList];
		for(unsigned int i=0;i<[tArray count];i++){
			NSDictionary* tDict = [tArray objectAtIndex:i];
			NSString* tString=[tDict objectForKey:@"Name"];
			if(tString==nil)
				tString= [NSString stringWithFormat:@"Chapter %d",i+1];
			
			NSMenuItem* tItem =[[[NSMenuItem alloc] initWithTitle:tString
			action:@selector(goToChapter:)
			keyEquivalent:@""] autorelease];
			[tItem setRepresentedObject:tDict];
			[tItem setTarget:self];
			if(i+1 == (unsigned int)[film currentChapterIndex]){
				[tItem setState:NSOnState]; 
			}
			
			[tReturnMenu addItem:tItem];
		}

return tReturnMenu;
}

-(void)playMoviePreview
{
}

-(void)gotoMoviePosterFrame
{
}

@end