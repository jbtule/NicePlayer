/*
 *  NiceDocumentScripting.h
 *  NicePlayer
 *
 *  Created by Robert Chin on 4/8/05.
 *  Copyright 2005 __MyCompanyName__. All rights reserved.
 *
 */

#import "NiceDocument.h"

@interface NiceDocument (NiceDocumentScripting)

-(double)currentMovieDuration;
-(double)currentMovieFrameRate;
-(double)currentMovieTime;
-(void)setCurrentMovieTime:(double)aTime;

-(NSArray *)niceMovies;
-(NiceMovie*)currentMovie;
-(NiceMovie*)prevMovie;
-(NiceMovie*)nextMovie;
-(int)indexForMovie:(NiceMovie*)aMovie;

+(BOOL)accessInstanceVariablesDirectly;
-(void)handlePlayPauseCommand:(id)sender;

-(void)stopExistingTimer;
-(void)stopExistingTimerIfEqualsSelector:(SEL)aSelector;
-(void)startTimerWithDoSelector:(SEL)doSelector
           finishSelectorString:(id)finishSelectorString;

-(void)handleSkipForwardCommand:(id)sender;
-(void)handleSkipBackwardCommand:(id)sender;

-(void)handleFFStartCommand:(id)sender;
-(void)handleFFStopCommand:(id)sender;
-(void)handleRRStartCommand:(id)sender;
-(void)handleRRStopCommand:(id)sender;

-(BOOL)playlistShowing;

-(void)handleIncrementVolumeCommand:(id)sender;
-(void)handleDecrementVolumeCommand:(id)sender;
-(void)handleToggleMuteCommand:(id)sender;
-(float)volume;
-(void)setVolume:(float)aFloat;

-(BOOL)muted;
-(void)setMuted:(BOOL)aBool;

@end