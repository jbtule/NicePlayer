//
//  BlankView.h
//  NicePlayer
//
//  Created by James Tuley on 10/14/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NPMovieProtocol.h"


@interface BlankView : NSView<NPMoviePlayer>{
	float volume;
}

@end
