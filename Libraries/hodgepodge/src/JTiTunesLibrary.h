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
//  JTiTunesLibrary.h
//  iEatBrainz
//
//  Created by James Tuley on Thu Feb 19 2004.
//  Copyright (c) 2004 James Tuley. All rights reserved.
//


#import <AppKit/AppKit.h>
#import <HodgePodge/NSString-JTAdditions.h>
#import <HodgePodge/NSImage-JTAdditions.h>

enum JTLoadStatus{JTNotLoaded, JTLoaded,JTLoading};

@interface JTiTunesLibrary : NSObject {
    @private
        double _iTunesVersion;
        NSString* _libraryPath;
        NSDate* _lastModification;
        NSDictionary* _theLibrary;
        NSMutableArray* _observers;
        NSMutableDictionary* _iTunesImages;
        NSTimer* _checkTimer;
        NSMutableDictionary* _HashCache;
        NSMutableDictionary* _AliasCache;
        NSNumber* _LoadStatus;
        id _reserved4;
}
#pragma mark -
#pragma mark Complete Creation
+(id)defaultLibrary;

#pragma mark -
#pragma mark Providers

-(double)iTunesVersion;
-(id)libraryDictionary;
-(int)libaryLoadingStatus;
-(NSImage*)iTunesImageForName:(NSString*)aName;
-(NSArray*)iTunesImageRSRCMappings;

#pragma mark -
#pragma mark Database operations
-(void)setAutoCheckTimeInterval:(NSTimeInterval)aTimeInterval;
-(void)checkForUpdates:(id)sender;
-(void)reloadDatabase;
-(void)addObserver:(id)anObserver performSelectorOnChamge:(SEL) aSelector;
-(void)removeObserver:(id)anObserver;

#pragma mark -
#pragma mark Track & Playlist operations
-(NSSound*)soundForTrackID:(NSString*)aTrackID;
-(id)trackForTrackID:(NSString*)aTrackID;

-(NSArray*)playlists;
-(NSArray*)prettyPlaylists;

-(NSArray*)tracksForPlaylist:(id)aPlaylist;
-(NSArray*)tracksForLibraryPlaylist;
-(NSArray*)tracks;


#pragma mark -
#pragma mark HashingTracks
-(BOOL)hashMatchedForTrack:(id)track;
-(id)trackUpdatedByHashFromTrack:(id)track;
-(id)trackUpdatedByHash:(id)aHash;
@end

NSString* hashForTrack(NSDictionary* aTrack);
