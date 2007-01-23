//
//  NiceMovie.m
//  NicePlayer
//
//  Created by James Tuley on 2/19/05.
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

#import "NiceMovie.h"
#import "NicePlugin.h"
#import "NiceDocumentScripting.h"
#import "NPPluginReader.h"

@implementation NiceMovie

+(id)movieWithURL:(NSURL*)aURL andPlaylist:(id)aPlaylist
{
    return [[[self alloc]initWithURL:aURL andPlaylist:aPlaylist]autorelease];
}

-(id)initWithURL:(NSURL*)aURL andPlaylist:(id)aPlaylist
{
    if ((self = [super init])){
        theURL = [aURL retain];
        theParentPlaylist =aPlaylist;
    }return self;
}

-(NSURL*)URL
{
    return theURL;
}

-(NSString*)fileType{
    return NSHFSTypeOfFile([[self URL] path]);

}
-(NSString*)fileExtension{
    return [[[self URL] path] pathExtension];
}

-(NSString*)applescriptPath
{
    return [(NSString *)CFURLCopyFileSystemPath((CFURLRef)theURL,kCFURLHFSPathStyle) autorelease];

}

-(id)playlist
{
    return theParentPlaylist;
}

-(id)window
{
    return [[self playlist] window];
}

-(int)index
{
    return [[self playlist] indexForMovie:self];
}

-(NSString*)description
{
    return [self name];
}

-(BOOL)isEqual:(id)aMovie
{
    return [[self URL] isEqual:[aMovie URL]] && [[self playlist] isEqual:[aMovie playlist]];
}

-(void)handlePlayCommand:(id)sender
{
    if([self playlist]  != nil){
        if(![[[self playlist] currentMovie] isEqualTo:self])
            [[self playlist]  playAtIndex:([self index] - 1) obeyingPreviousState:NO];
        [[self playlist] play:self];
    }
}

-(void)handlePauseCommand:(id)sender
{
    if([self playlist]  != nil){
        if(![[[self playlist] currentMovie] isEqualTo:self])
            [[self playlist]  playAtIndex:([self index] - 1) obeyingPreviousState:NO];
        [[self playlist] pause:self];
    }
}


-(NSString*)name
{
    return [[theURL path] lastPathComponent];
}


-(NSArray*)suitablePlugins{
    NSMutableArray* tArray = [NSMutableArray array];
    id pluginOrder = [[NPPluginReader pluginReader] cachedPluginOrder];
    id pluginDict = [[NPPluginReader pluginReader] prefDictionary];
    
    unsigned i;
    for(i = 0; i < [pluginOrder count]; i++){
	NSDictionary *currentPlugin = [pluginOrder objectAtIndex:i];
	if(![[currentPlugin objectForKey:@"Chosen"] boolValue])
	    continue;
	id pluginClass = [[pluginDict objectForKey:[currentPlugin objectForKey:@"Name"]] objectForKey:@"Class"];
        NicePlugin* tPlug =[NicePlugin pluginForClass:pluginClass];
        if(([[tPlug fileTypes] containsObject:[self fileType]])
                   || ([[tPlug fileTypes] containsObject:[self fileExtension]])){
            [tArray addObject:[NicePlugin pluginForClass:pluginClass]];
        }
    }
    
    return tArray;
}


- (NSScriptObjectSpecifier *) objectSpecifier
{
    NSNameSpecifier *tSpecifier;
     tSpecifier = [[NSNameSpecifier alloc]
      initWithContainerClassDescription:(NSScriptClassDescription *)[NSApp classDescription]
                     containerSpecifier:[NSApp objectSpecifier] 
                                    key:@"niceMovies"];
        [tSpecifier setName:[self name]];
        return [tSpecifier autorelease];
  
}


@end
