//
//  NiceDocumentScripting.m
//  NicePlayer
//
//  Created by Robert Chin on 2/13/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "NiceDocument.h"

@implementation NiceDocument (NiceDocumentScripting)

-(void)handlePauseCommand:(id)sender
{
	[(NPMovieView *)theMovieView stop];
}

-(void)handlePlayPauseCommand:(id)sender
{
	if([theMovieView isPlaying])
		[(NPMovieView *)theMovieView stop];
	else
		[theMovieView start];
}

@end
