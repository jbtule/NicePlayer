/*
 iEatBrainz
 Copyright (c) 2004, James Tuley
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 
 * Neither the name of James Tuley nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */

//
//  JTiTunesLibrary.m
//  iEatBrainz
//
//  Created by James Tuley on Thu Feb 19 2004.
//  Copyright (c) 2004 James Tuley. All rights reserved.
//
// This class in need of some refactoring, especially in light of quick fixes to solve 4.5 itunes issues.

#import "JTiTunesLibrary.h"
#import "JTiTunesLibrary-Private.h"

NSString* hashForTrack(NSDictionary* aTrack){

    return [NSString stringWithFormat:@"%@&%@&%@",[aTrack objectForKey:@"Size"],[aTrack objectForKey:@"Total Time"],[aTrack objectForKey:@"Date Added"], nil];
}

id _JTiTunesLibrary = nil;
BOOL _JTiTunesLibraryLoaded = NO;
static NSString* _JTLoadLock = @"jt.indy.itunes.loadlock";

@interface JTiTunesLibrary(Initialization)
-(int)lazyInitLibrary;
-(void)lazyInitLibraryNow:(id)sender;
@end

#pragma mark -
#pragma mark Complete Creation

@implementation JTiTunesLibrary

+(id)defaultLibrary{
    _JTiTunesLibraryLoaded = YES;
    if(_JTiTunesLibrary ==nil){
        _JTiTunesLibrary = [[self alloc] init];
    }
    
    return _JTiTunesLibrary;
}

#pragma mark -
#pragma mark Initialization
-(id)init{
    
    NSAssert((_JTiTunesLibrary == nil) && _JTiTunesLibraryLoaded, @"There can only be one instance of JTiTunesLibrary and you must call defaultLibrary to get it and not init yourself");
    
    if (self = [super init]){
        id tempObj=[[NSWorkspace sharedWorkspace] fullPathForApplication:@"iTunes.app"];
        if (tempObj != nil)
            tempObj=[NSBundle bundleWithPath:tempObj];
        if (tempObj != nil)
            tempObj=[tempObj infoDictionary];
        if (tempObj != nil)
            _iTunesVersion = [[tempObj objectForKey:@"CFBundleVersion"] doubleValue];
        else 
            _iTunesVersion =0;
        
        _theLibrary = nil;
        _iTunesImages = nil;
        _HashCache = nil;
        _LoadStatus = [[NSNumber numberWithInt:JTNotLoaded] retain];
        
        _checkTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(checkForUpdates:) userInfo:nil repeats:YES];
        
        _observers = [[NSMutableArray alloc] init];
        
    }
    return self;
    
}

-(void)lazyInitImages{
    
    if (_iTunesImages == nil){
        
        id tempArray =[self iTunesImageRSRCMappings];
        
        if (![self _loadiTunesImages:[self iTunesImageRSRCMappings]]){
            int i,j;
            _iTunesImages = [[NSMutableDictionary alloc] init];
            for(i =0;i<[tempArray count];i++){
                id keys =[[[tempArray objectAtIndex:i] objectForKey:@"Images"] allKeys];
                for(j =0;j<[keys count];j++){
                    [_iTunesImages setObject:[NSImage imageNamed:[keys objectAtIndex:j]] forKey:[keys objectAtIndex:j]];
                    
                }
            }
        }
        
    }
}

-(int)lazyInitLibrary{
        if([_LoadStatus intValue] == JTNotLoaded){
            [_LoadStatus autorelease];
            _LoadStatus = [[NSNumber numberWithInt:JTLoading] retain];
            [NSThread detachNewThreadSelector:@selector(lazyInitLibraryNow:) toTarget:self withObject:self];
        }
    
    return [_LoadStatus intValue];
}


-(void)lazyInitLibraryNow:(id)sender{
    @synchronized(_JTLoadLock){

        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

        if( _theLibrary == nil){
            
            _libraryPath =[@"~/Music/iTunes/iTunes Music Library.xml" stringByResolvingAliasInPath];
            
            _theLibrary = [[NSDictionary alloc] initWithContentsOfFile:_libraryPath];
            
            if (_theLibrary == nil){//check secondary location
                _libraryPath =[@"~/Documents/iTunes/iTunes Music Library.xml" stringByResolvingAliasInPath];
                _theLibrary = [[NSDictionary alloc] initWithContentsOfFile:_libraryPath];
            }
            
            if (_theLibrary == nil && nil != [[NSUserDefaults standardUserDefaults] stringForKey:@"Custom iTunes Music Path"]){//check secondary location
                _libraryPath =[[NSUserDefaults standardUserDefaults] stringForKey:@"Custom iTunes Music Path"];
                _theLibrary = [[NSDictionary alloc] initWithContentsOfFile:_libraryPath];
            }

            if(_theLibrary ==nil){
                return;
            }

            //[self _createAliasCache];
            
            _lastModification = [[[[NSFileManager defaultManager] fileAttributesAtPath:_libraryPath traverseLink:YES] fileModificationDate] retain];
            [_libraryPath retain];

                [_LoadStatus autorelease];
                _LoadStatus = [[NSNumber numberWithInt:JTLoaded] retain];


            
        }
        


        [pool release];
    }
    

}

-(void)_JTCheckiTunesVersionMatch:(id)sender{
    
    if([self iTunesVersion] != [[[self libraryDictionary] valueForKey:@"Application Version"]doubleValue])
        NSRunAlertPanel(@"iTunes Version Numbers Don't Match", @"Your iTunes Library and iTunes Application numbers don't match up. This software is supposed to choose correctly, so please report this bug to jtuley@gmail.com, along with the hard drive locations of multiple copies of a file called 'iTunes Music Library.xml' the file has the application version at the top if opened.", @"Close this message", nil, nil);
}


#pragma mark -
#pragma mark Providers

-(double)iTunesVersion{

    return _iTunesVersion;
}

-(int)libaryLoadingStatus{
    
    return [self lazyInitLibrary];
}


-(id)libraryDictionary{    
    [self lazyInitLibraryNow:self];
    
    if(_theLibrary ==nil){
        int tempButton;
        id tempOpen =[NSOpenPanel openPanel];   
        [tempOpen setResolvesAliases:YES];
        [tempOpen setCanChooseDirectories:NO];
        [tempOpen setAllowsMultipleSelection:NO];
        [tempOpen setPrompt:@"Choose"];
        [tempOpen setMessage:@"Please find and choose your iTunes Music Library.xml file"];
        tempButton=[tempOpen runModalForDirectory:[@"~/" stringByExpandingTildeInPath] file:nil types:[NSArray arrayWithObject:@"xml"]];
        if (tempButton == NSOKButton){
            _libraryPath=[[[tempOpen URLs] objectAtIndex:0] path];
            _theLibrary = [[NSDictionary alloc] initWithContentsOfFile:_libraryPath];
            
            [[NSUserDefaults standardUserDefaults] setObject:_libraryPath forKey:@"Custom iTunes Music Path"];
            
        }
        [self lazyInitLibraryNow:self];

    }

    return _theLibrary;
    
    
}



-(NSImage*)iTunesImageForName:(NSString*)aName{
    [self lazyInitImages];

    return [_iTunesImages objectForKey:aName];

}

-(NSArray*)iTunesImageRSRCMappings{
    
    id  tempDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle bundleForClass:[JTiTunesLibrary self]] pathForResource:@"Image Mappings" ofType:@"plist"]];
    
    if ([self iTunesVersion] >= 7.0)
        return  [tempDict objectForKey:@"7.0"];
    else if ([self iTunesVersion] >= 4.5)
        return  [tempDict objectForKey:@"4.5"];
    else
        return  [tempDict objectForKey:@"4.0"];
    
}

#pragma mark -
#pragma mark Database operations

-(void)setAutoCheckTimeInterval:(NSTimeInterval)aTimeInterval{
    [_checkTimer invalidate];
   if(aTimeInterval > 0)
    _checkTimer = [[NSTimer scheduledTimerWithTimeInterval:aTimeInterval target:self selector:@selector(checkForUpdates:) userInfo:nil repeats:YES] retain];
}


-(void)checkForUpdates:(id)sender{
    if([self libaryLoadingStatus] == JTLoaded){
        id tempDate =[[[NSFileManager defaultManager] fileAttributesAtPath:_libraryPath traverseLink:YES] fileModificationDate];
        NSComparisonResult tempComp =[_lastModification compare:tempDate];
        if (tempComp != NSOrderedSame){
            NSLog(@"iTunes Database has changed, Reloading...");
            [self reloadDatabase];
            [_lastModification release];
            _lastModification = [tempDate retain];
        }
    }
    
}

-(void)reloadDatabase{
    if([self libaryLoadingStatus] == JTLoaded){
    [_theLibrary release];
    _theLibrary = nil;
    [_HashCache release];
    _HashCache = nil;
    [self _databaseChanged];
    [self _JTCheckiTunesVersionMatch:self];
    }
}

-(void)addObserver:(id)anObserver performSelectorOnChamge:(SEL) aSelector{
    [_observers addObject:[NSArray arrayWithObjects:anObserver,NSStringFromSelector(aSelector),nil]];
}

-(void)removeObserver:(id)anObserver{
    NSEnumerator *enumerator = [_observers objectEnumerator];
    id object;
    
    while (object = [enumerator nextObject]) {
        if ([[object objectAtIndex:0] isEqualTo:anObserver]){
            [_observers removeObject:object];
            break;
        }
    }
}


#pragma mark -
#pragma mark Track & Playlist operations

-(NSSound*)soundForTrackID:(NSString*)aTrackID{
    NSSound* theSong =[[NSSound alloc]initWithContentsOfURL:[NSURL URLWithString:[[[[self libraryDictionary] objectForKey:@"Tracks"] objectForKey:aTrackID] objectForKey:@"Location"]] byReference:YES];

    return [theSong autorelease];

}

-(id)trackForTrackID:(NSString*)aTrackID{
    
    return [[[self libraryDictionary] objectForKey:@"Tracks"] objectForKey:aTrackID];
    
}

-(NSArray*)playlists{
    return [[self libraryDictionary] objectForKey:@"Playlists"];
}

-(NSArray*)prettyPlaylists{
    int i;
    id tempPlaylists = [self playlists];
    id tempTotal = [NSMutableArray array];
    id tempSmart =[NSMutableArray array];
    id tempNormal =[NSMutableArray array];
    id tempMaster = [NSMutableArray array];
    id tempPurchased = [NSMutableArray array];
    id tempParty = [NSMutableArray array];
    id tempSwitch = nil;
    id nameDescriptor=[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"Name" 
                                                                  ascending:YES] autorelease]];
    for (i=0; i < [tempPlaylists count];i++){
        id tempPlaylist = [tempPlaylists objectAtIndex:i];
        id tempType = nil;
        if ([[tempPlaylist objectForKey:@"Name"] isEqualTo:@"Party Shuffle"]){
            tempSwitch = tempParty;
            tempType = @"Party";
        }else if ([tempPlaylist objectForKey:@"Master"] != nil){
            tempSwitch = tempMaster;
            tempType = @"Master";
        }else if ([tempPlaylist objectForKey:@"Purchased Music"] != nil){
            tempSwitch = tempPurchased;
             tempType = @"Purchased";
        }else if ([tempPlaylist objectForKey:@"Smart Info"] != nil){
            tempSwitch = tempSmart;
            tempType = @"Smart";
        } else {
            tempSwitch = tempNormal;
             tempType = @"Normal";
        }
        id tempDictionary = [[tempPlaylist mutableCopy] autorelease];
        
        [tempDictionary setObject:tempType forKey:@"Type"];
        
        [tempSwitch addObject:tempDictionary];
    }

    [tempTotal addObjectsFromArray:[tempMaster sortedArrayUsingDescriptors:nameDescriptor]];
    [tempTotal addObjectsFromArray:[tempParty sortedArrayUsingDescriptors:nameDescriptor]];
    [tempTotal addObjectsFromArray:[tempPurchased sortedArrayUsingDescriptors:nameDescriptor]];
    [tempTotal addObjectsFromArray:[tempSmart sortedArrayUsingDescriptors:nameDescriptor]];
    [tempTotal addObjectsFromArray:[tempNormal sortedArrayUsingDescriptors:nameDescriptor]];
     
     return tempTotal;
    
}


-(NSArray*)tracksForPlaylist:(id)aPlaylist{
    NSMutableArray* returnArray = [NSMutableArray array];
    NSArray* tempArray  =[aPlaylist objectForKey:@"Playlist Items"];
    int i;
    if (tempArray != nil){
        for (i=0; i <[tempArray count];i++){
            id keyValue = [[[tempArray objectAtIndex:i] objectForKey:@"Track ID"] stringValue];
            id tempObj = [self trackForTrackID:keyValue];
            if (tempObj !=nil){
                if(_AliasCache !=nil){
                    id tAlias =[[_AliasCache objectForKey:[tempObj objectForKey:@"Location"]] data];
                    if(tAlias != nil)
                        [tempObj setObject:tAlias forKey:@"Alias"];
                }
                [returnArray addObject:tempObj];
            }
        }
    }
    //NSLog(@"%@", returnArray);
    
    return returnArray;
}


-(NSArray*)tracksForLibraryPlaylist{
      return [self tracksForPlaylist:[[self playlists] objectAtIndex:0]];
}

-(NSArray*)tracks{
    return [[[self libraryDictionary] objectForKey:@"Tracks"] allValues];
}

#pragma mark -
#pragma mark Hashes

-(BOOL)hashMatchedForTrack:(id)track{
    return [hashForTrack(track) isEqualTo:hashForTrack([self trackForTrackID:[[track objectForKey:@"Track ID"] stringValue]])];
}




-(id)trackUpdatedByHashFromTrack:(id)track{
    return [self trackUpdatedByHash:hashForTrack(track)];
}


-(void)generateHashTableLazily{
    if(_HashCache == nil){
        id tempArray =[self tracksForLibraryPlaylist];
        _HashCache = [[NSMutableDictionary alloc]initWithCapacity:[tempArray count]];
        NSEnumerator *enumerator = [tempArray objectEnumerator];
        id object;
        while (object = [enumerator nextObject]) {
            [_HashCache setObject:object forKey:hashForTrack(object)];
        }
    }
        
}


-(id)trackUpdatedByHash:(id)aHash{
    [self generateHashTableLazily];
        
    return [_HashCache objectForKey:aHash];
    
}



@end
