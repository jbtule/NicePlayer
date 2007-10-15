//
//  NiceWindowScripting.m
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

enum{
    NPAVERAGE ='npav',
    NPFLOATING ='npzf',
    NPDESKTOP = 'npzd'
};


@interface NSWindow(ApplesAppleScriptMethdod)
    -(void)setBoundsAsQDRect:(NSData*)aData;   
@end

@implementation NiceWindow (NiceWindowScripting)

+(BOOL)accessInstanceVariablesDirectly
{
	return NO;
}

-(int)transparency{
	return (1-[self alphaValue]) * 100;
}

-(void)setTransparency:(int)aPercent{
	[self setAlphaValue:1.0-(aPercent/100.00)];
}

-(int)opacity{
	return [self alphaValue] * 100;
}

-(void)setOpacity:(int)aPercent{
	[self setAlphaValue:(aPercent/100.00)];
}

-(int)floating{
    if(kCGDesktopIconWindowLevel-1 == [self level]){
        return NPDESKTOP;
    }else if([self windowIsFloating])
        return NPFLOATING;
    else
        return NPAVERAGE;
}

-(void)setFloating:(int)aHeight
{
    if(NPAVERAGE ==aHeight)
        [self unfloatWindow];
    else if (NPDESKTOP ==aHeight)
        [self setLevel:kCGDesktopIconWindowLevel-1];
    else
        [self floatWindow];

    [[NiceController controller] changedWindow:nil];
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
    NSDictionary* tDict =[sender evaluatedArguments];
    
    NSScreen* value = [tDict objectForKey:@"on"];
    
    if(value ==nil)
        value = [self screen];
    
    [[NiceController controller] handleEnterFullScreen:self onScreen:value];
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

-(NSArray*)currentAspectRatio
{
    NSSize tSize = [self aspectRatio];
    
    return [NSArray arrayWithObjects:[NSNumber numberWithShort:tSize.width],[NSNumber numberWithShort:tSize.height],nil];
}

-(BOOL)playlistShowing
{
	return [[[self windowController] document] playlistShowing];
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
	[self performClose:self];
	return nil;
}

-(void)setBoundsAsQDRect:(id)aBounds{
    if([aBounds length] == 88){
        Rect aRect;
        [aBounds getBytes:&(aRect.left) range:NSMakeRange(50,2)];
        [aBounds getBytes:&(aRect.top) range:NSMakeRange(62,2)];
        [aBounds getBytes:&(aRect.right) range:NSMakeRange(74,2)];
        [aBounds getBytes:&(aRect.bottom) range:NSMakeRange(86,2)];
        [super setBoundsAsQDRect:[NSData dataWithBytes:&aRect length:sizeof(Rect)]];
    }else{
        [super setBoundsAsQDRect:aBounds];
    }
}

@end
