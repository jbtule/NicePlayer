//
//  NPAddCommand.m
//  NicePlayer
//
//  Created by James Tuley on 2/19/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "NPAddCommand.h"
#import "NiceMovie.h"
#import "NiceDocument.h"

id evaluatedSpecicfier(id each, void* context){
    if ([each isKindOfClass: [NSScriptObjectSpecifier class]])
    {
        NSScriptObjectSpecifier *spec = (NSScriptObjectSpecifier *)each;
        
        return [spec objectsByEvaluatingWithContainers: NSApp];
    }else{
        return each;
    }
}    

@implementation NPAddCommand

- (id) evaluatedDirectParameters
{
    id param = [self directParameter];
    
    if(![param isKindOfClass:[NSArray class]]){
        param = [NSArray arrayWithObject:param];
    }
    
    return [param collectUsingFunction:evaluatedSpecicfier context:nil];
}


-(id)performDefaultImplementation
{

    id tDArg = [self evaluatedDirectParameters];
    NSDictionary *tEArgs = [self evaluatedArguments];
    id tPlaylist = [tEArgs objectForKey:@"to"];
    id tIndex = [tEArgs objectForKey:@"atIndex"];
    unsigned i;
    for(i=0;i<[tDArg count];i++){
        [self addURL:[self getURLFromObject:[tDArg objectAtIndex:i]] toPlaylist:tPlaylist atIndex:tIndex];
    }
    return nil;
}

-(void)addURL:(NSURL*)aURL toPlaylist:(NiceDocument*)aPlaylist atIndex:(NSNumber*)anIndex
{
    if(anIndex != nil){
        [aPlaylist addURLToPlaylist:aURL atIndex:[anIndex intValue]];
    }else{
        [aPlaylist addURLToPlaylist:aURL];
    }
}

-(NSURL*)getURLFromObject:(id)anObject{
    if([anObject isKindOfClass:[NiceMovie class]]){
        return [anObject URL];
    }else{
        return [NSURL fileURLWithPath:anObject];
        
    }
}

@end
