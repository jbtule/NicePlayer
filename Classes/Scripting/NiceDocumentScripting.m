//
//  NiceDocumentScripting.m
//  NicePlayer
//
//  Created by Robert Chin on 2/13/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

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
#import "NiceMovie.h"
#import "NiceDocumentScripting.h"
#import "NicePlugin.h"
#import <STEnum/STEnum.h>

id collectMovies(id each, void* context){
    return [NiceMovie movieWithURL:each andPlaylist:(NiceDocument*)context];
}

@implementation NiceDocument (NiceDocumentScripting)

-(double)currentMovieDuration
{
    return [theMovieView totalTime];
}

-(double)currentMovieFrameRate
{
    return [theMovieView currentMovieFrameRate];
}

-(double)currentMovieTime
{
    return [theMovieView currentMovieTime];

}
-(void)setCurrentMovieTime:(double)aTime
{
    [theMovieView setCurrentMovieTime:aTime];
}

-(NSArray *)niceMovies
{

    return [thePlaylist collectUsingFunction:collectMovies context:(void*)self];
    
}

-(NicePlugin*)currentPlugin{
    return [NicePlugin pluginForClass:[theMovieView currentPluginClass]];
}

-(void)setCurrentPlugin:(NicePlugin*)aPlugin{
    [theMovieView switchToPluginClass:[aPlugin classRep]];
}

-(NiceMovie*)currentMovie
{
    if(theCurrentURL !=nil){
        return [NiceMovie movieWithURL:theCurrentURL andPlaylist:self];
    }else{
        return nil;
    }
}

-(NiceMovie*)prevMovie
{
    unsigned anIndex =  [self getPrevIndex];
    
    if((anIndex >= 0) && (anIndex < [thePlaylist count])){
        return [NiceMovie movieWithURL:[thePlaylist objectAtIndex:anIndex] andPlaylist:self];
    }else{
        return nil;
    }
}

-(NiceMovie*)nextMovie
{
    unsigned anIndex =  [self getNextIndex];
    if(anIndex >= [thePlaylist count] && REPEAT_LIST == theRepeatMode)
        anIndex = 0;
    
    if((anIndex >= 0) && (anIndex < [thePlaylist count])){
        return [NiceMovie movieWithURL:[thePlaylist objectAtIndex:anIndex] andPlaylist:self];
    }else{
        return nil;
    }
}

-(int)indexForMovie:(NiceMovie*)aMovie
{
    
    return [thePlaylist indexOfObject:[aMovie URL]] + 1;
    
}


+(BOOL)accessInstanceVariablesDirectly
{
    return NO;
}

-(void)handlePlayPauseCommand:(id)sender
{
    if([theMovieView isPlaying])
        [theMovieView stop];
    else
        [theMovieView start];
}

-(void)stopExistingTimer
{
    if(asffrrTimer){
        SEL stopSel = NSSelectorFromString([[asffrrTimer userInfo] objectForKey:@"StopSelector"]);
        [asffrrTimer invalidate];
        asffrrTimer = nil;
        [self performSelector:stopSel];
    }
}

-(void)stopExistingTimerIfEqualsSelector:(SEL)aSelector
{
    if(asffrrTimer){
        SEL stopSel = NSSelectorFromString([[asffrrTimer userInfo] objectForKey:@"StopSelector"]);
        if(aSelector == stopSel){
            [asffrrTimer invalidate];
            asffrrTimer = nil;
        }
    }
}

-(void)startTimerWithDoSelector:(SEL)doSelector
           finishSelectorString:(id)finishSelectorString
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:finishSelectorString
                                                         forKey:@"StopSelector"];
    asffrrTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                   target:theMovieView
                                                 selector:doSelector
                                                 userInfo:userInfo
                                                  repeats:YES];
}

-(void)handleSkipForwardCommand:(id)sender
{
    NSDictionary *tEArgs = [sender evaluatedArguments];
    NSNumber *amount =[tEArgs objectForKey:@"by"];
    if(amount ==nil){
        [theMovieView ffDo];
    }else{
        [theMovieView ffDo:[amount intValue]];
    }
}

-(void)handleSkipBackwardCommand:(id)sender
{
    NSDictionary *tEArgs = [sender evaluatedArguments];
    NSNumber *amount =[tEArgs objectForKey:@"by"];
    if(amount ==nil){
        [theMovieView rrDo];
    }else{
        [theMovieView rrDo:[amount intValue]];
    }
}


-(void)handleFFStartCommand:(id)sender
{
    [self stopExistingTimer];
    [self startTimerWithDoSelector:@selector(ffDo)
              finishSelectorString:@"handleFFStopCommand:"];
    [theMovieView ffStart];
}

-(void)handleFFStopCommand:(id)sender
{
    [self stopExistingTimerIfEqualsSelector:@selector(handleFFStopCommand:)];
    [theMovieView ffEnd];
}

-(void)handleRRStartCommand:(id)sender
{
    [self stopExistingTimer];
    [self startTimerWithDoSelector:@selector(rrDo)
              finishSelectorString:@"handleRRStopCommand:"];
    [theMovieView rrStart];
}

-(void)handleRRStopCommand:(id)sender
{
    [self stopExistingTimerIfEqualsSelector:@selector(handleRRStopCommand:)];
    [theMovieView rrEnd];
}

-(void)handleIncrementVolumeCommand:(id)sender
{
    [theMovieView incrementVolume];
    [theMovieView showOverLayVolume];
    [theMovieView smartHideMouseOverOverlays];
    
    
}

-(BOOL)playlistShowing{
    return [thePlaylistDrawer state] == NSDrawerOpenState 
    || [thePlaylistDrawer state] == NSDrawerOpeningState;
}

-(void)handleDecrementVolumeCommand:(id)sender
{
    [theMovieView decrementVolume];
    [theMovieView showOverLayVolume];
    [theMovieView smartHideMouseOverOverlays];
}

-(void)handleToggleMuteCommand:(id)sender
{
    [theMovieView toggleMute];
    [theMovieView showOverLayVolume];
    [theMovieView smartHideMouseOverOverlays];
}

-(float)volume
{
    return [theMovieView volume];
}

-(void)setVolume:(float)aFloat
{
    [theMovieView setVolume:aFloat];
}

-(BOOL)muted
{
    return [theMovieView muted];
}

-(void)setMuted:(BOOL)aBool
{
    [theMovieView setMuted:aBool];
}


- (NSNameSpecifier *) objectSpecifier
{
    NSNameSpecifier *specifier = [[NSNameSpecifier alloc]
      initWithContainerClassDescription:
        (NSScriptClassDescription *)[NSApp classDescription]
                     containerSpecifier: [NSApp objectSpecifier]
                                    key: @"orderedDocuments"];
    [specifier setName: [self identifier]];
    return [specifier autorelease];
}

@end
