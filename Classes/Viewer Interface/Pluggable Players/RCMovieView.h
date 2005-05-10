//
//  RCMovieView.h
//  NicePlayer
//
//  Created by Robert Chin on 5/10/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QTKit/QTKit.h>
#import "NPMovieProtocol.h"
#import "NPPluginView.h"

@interface RCMovieView : NPPluginView <NPMoviePlayer>
{
    NSURL *myURL;
    QTMovie *film;
    QTMovieView *qtView;
    BOOL muted;
    NSDictionary* movieCache;
}

-(double)totalTimePrecise;
-(long)currentMovieTimePrecise;
-(void)setCurrentMovieTimePrecise:(long)newMovieTime;
-(long)currentMovieTimeScale;
-(void)incrementMovieTime:(long)timeDifference inDirection:(enum direction)aDirection;
-(void)stepFrameInDirection:(int)aDirection;

@end
