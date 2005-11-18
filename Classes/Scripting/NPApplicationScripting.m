//
//  NPApplicationScripting.m
//  NicePlayer
//
//  Created by James Tuley on 2/19/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "NPApplicationScripting.h"
#import "NicePlugin.h"

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