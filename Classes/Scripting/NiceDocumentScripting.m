//
//  NiceDocumentScripting.m
//  NicePlayer
//
//  Created by Robert Chin on 2/13/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "NiceDocument.h"
#import "NiceMovie.h"
#import "NiceDocumentScripting.h"

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
    id collectMovies(id each, void* context){
        return [NiceMovie movieWithURL:each andPlaylist:self];
    }
    
    return [thePlaylist collectUsingFunction:collectMovies context:nil];
    
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


- (NSScriptObjectSpecifier *) objectSpecifier
{
    NSScriptObjectSpecifier *specifier = [[NSNameSpecifier alloc]
      initWithContainerClassDescription:
        (NSScriptClassDescription *)[NSApp classDescription]
                     containerSpecifier: [NSApp objectSpecifier]
                                    key: @"orderedDocuments"];
    [specifier setName: [self identifier]];
    return [specifier autorelease];
}

@end
