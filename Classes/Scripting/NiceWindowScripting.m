//
//  NiceWindowScripting.m
//  NicePlayer
//
//  Created by Robert Chin on 2/13/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "NiceWindow.h"
#import "NiceDocument.h"
#import "NiceControllerScripting.h"
enum{
    NPDOUBLE = 'npdo',
    NPHALF = 'nphl',
    NPNORMAL ='npno',
    NPFILL = 'npfl',
    NPFITWIDTH = 'npfw'
};


@implementation NiceWindow (NiceWindowScripting)

+(BOOL)accessInstanceVariablesDirectly
{
	return NO;
}

-(void)handleResizeCommand:(id)sender{
    NSDictionary* tDict =[sender evaluatedArguments];

    int value = [[tDict objectForKey:@"to"] intValue];
    switch(value){
        case NPHALF:
            [self halfSize:self];
            break;
        case NPNORMAL:
            [self normalSize:self];
            break;
        case NPDOUBLE:
            [self doubleSize:self];
            break;
        case NPFILL:
            [self fillScreenSize:self];
            break;
        case NPFITWIDTH:
            [self fillWidthSize:self];
            break;
        default:
            NSLog(@"enum %d",value);
    }
    
}

-(void)handleEnterFullScreenCommand:(id)sender
{
    [[NiceController controller] handleEnterFullScreen:self];
}

-(void)handleExitFullScreenCommand:(id)sender
{
    [[NiceController controller] handleExitFullScreen:self];
}

-(void)handleAddURLToPlaylistCommand:(id)sender
{
    NSDictionary *eArgs = [sender evaluatedArguments];
    NSURL *newURL = (NSURL *)CFURLCreateWithFileSystemPath(NULL, (CFStringRef)[eArgs objectForKey:@"file"],
                                                           kCFURLHFSPathStyle, NO);
    if([eArgs objectForKey:@"atIndex"] != nil)
        [[[self windowController] document] addURLToPlaylist:newURL
                                                     atIndex:[[eArgs objectForKey:@"atIndex"] intValue]];
    else
        [[[self windowController] document] addURLToPlaylist:newURL];
    
    [newURL release];
}

-(BOOL)playlistShowing
{
	return [[[self windowController] document] isPlaylistEmpty];
}

-(id)documentMovie
{
	return [[self windowController] document];
}

-(void)setPlaylistShowing:(BOOL)aBool
{
	if(aBool)
		[[[self windowController] document] openPlaylistDrawer:nil];
	else
		[[[self windowController] document] closePlaylistDrawer:nil];
}

-(void)handleTogglePlaylistDrawer:(id)sender
{
	[[[self windowController] document] togglePlaylistDrawer:sender];
}

-(id)handleCloseScriptCommand:(id)sender
{
	if([self isFullScreen])
		[self unFullScreen];
	[self close];
	return nil;
}

@end
