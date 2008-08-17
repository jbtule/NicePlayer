//
//  NPApplicationScripting.m
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

#import "NPApplicationScripting.h"
#import "NicePlugin.h"
#import "NPPluginReader.h"
#import <STEnum/STEnum.h>
BOOL dectectIdentifier(id each, void* context){
    return ([[each identifier] isEqualTo:(id)context]);            
}

@implementation NPApplication(Scripting)

-(NSArray *)niceMovies
{
    NSMutableArray* tArray =[NSMutableArray array];
    id tPlaylist =[self orderedDocuments];
    unsigned i;
    for(i=0;i<[tPlaylist count];i++){
        [tArray addObjectsFromArray:[[tPlaylist objectAtIndex:i] niceMovies]];
    }
    return tArray;
}


-(NSArray*)nicePlugins{
    NSMutableArray* tArray = [NSMutableArray array];
    id pluginOrder = [[NPPluginReader pluginReader] cachedPluginOrder];
    id pluginDict = [[NPPluginReader pluginReader] prefDictionary];
    
    unsigned i;
    for(i = 0; i < [pluginOrder count]; i++){
	NSDictionary *currentPlugin = [pluginOrder objectAtIndex:i];
	if(![[currentPlugin objectForKey:@"Chosen"] boolValue])
	    continue;
	id pluginClass = [[pluginDict objectForKey:[currentPlugin objectForKey:@"Name"]] objectForKey:@"Class"];
        
        [tArray addObject:[NicePlugin pluginForClass:pluginClass]];
    }
    
    return tArray;
}


-(id)valueInOrderedDocumentsWithName:(id)anIdentifier{

   return [[self orderedDocuments] detectUsingFunction:dectectIdentifier context:(void*)anIdentifier];
}

-(BOOL)isFullScreen{
	return [[NiceController controller] isFullScreen];
}

-(void)handleEnterFullScreenCommand:(id)sender
{
    NSDictionary* tDict =[sender evaluatedArguments];
    
    NSScreen* value = [tDict objectForKey:@"on"];
    
    if(value ==nil)
        value = [NSScreen mainScreen];
    
    [[NiceController controller] enterFullScreenOnScreen:value];
}

-(void)handleExitFullScreenCommand:(id)sender
{
    [[NiceController controller] exitFullScreen];
}

-(NSArray*)screens{
    return [NSScreen screens];
}

-(NSString*)resourcesPath{
    return [[NSBundle mainBundle] resourcePath];
}

@end

BOOL detectSelf(id each, void* context){
    NSMutableDictionary* tContext = (NSMutableDictionary*) context;
    int i =[[tContext objectForKey:@"i"]intValue];
    i++;
    [tContext setObject:[NSNumber numberWithInt:i] forKey:@"i"];
        return [[tContext objectForKey:@"self"] isEqual:each];
    }

@implementation NSScreen(Scripting)

-(NSData *)boundsAsQDRect{
    Rect qdRect;
    NSRect tRect = [self frame];
    qdRect.left = tRect.origin.x;
    qdRect.top = tRect.origin.y;
    qdRect.right = tRect.origin.x + tRect.size.width;
    qdRect.bottom = tRect.origin.y + tRect.size.height;   
    
    
    return [NSData dataWithBytes:&qdRect length:sizeof(Rect)];
    
}

-(int)orderedIndex{
    NSMutableDictionary* tContext = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:-1],@"i",self,@"self",nil];
    

    [[NSScreen screens] detectUsingFunction:detectSelf context:(void*)tContext];
    
    return [[tContext objectForKey:@"i"] intValue];
    
}

- (NSIndexSpecifier *) objectSpecifier
{
    NSIndexSpecifier *specifier = [[NSIndexSpecifier alloc]
      initWithContainerClassDescription:
        (NSScriptClassDescription *)[NSApp classDescription]
                     containerSpecifier: [NSApp objectSpecifier]
                                    key: @"screens"];
    [specifier setIndex: [self orderedIndex]];
    return [specifier autorelease];
}

@end