//
//  DVDDispose.m
//  DVDPlayer
//
//  Created by James Tuley on 1/19/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "DVDDispose.h"
#import <DVDPlayback/DVDPlayback.h>

@implementation DVDDisposer

-(void)applicationWillTerminate:(id)sender
{
	DVDDispose();
}

@end
