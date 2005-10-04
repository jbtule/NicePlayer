//
//  NicePlugins.m
//  NicePlayer
//
//  Created by James Tuley on 10/3/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "NicePlugin.h"
#import "NPMovieProtocol.h"

@implementation NicePlugin

+(id)pluginForClass:(Class)aClass{
    return [[[self alloc] initForClass:aClass] autorelease];
}


-(id)initForClass:(Class) aClass{
    if((self = [super init])){
        theClass =aClass;
    }return self;
}

-(BOOL)isEqual:(id)aPlugin
{
    return [[self classRep] isEqual:[aPlugin classRep]];
}


-(NSString*)humanName{
    return [[theClass plugInfo] objectForKey:@"Name"];
}

-(NSString*)name{
    return NSStringFromClass([self classRep]);
}

-(Class)classRep{
    return theClass;
}

-(NSArray*)fileTypes{
      return [[theClass plugInfo] objectForKey:@"FileExtensions"];
}

- (NSScriptObjectSpecifier *) objectSpecifier
{
    NSNameSpecifier *tSpecifier;
    tSpecifier = [[NSNameSpecifier alloc]
      initWithContainerClassDescription:(NSScriptClassDescription *)[NSApp classDescription]
                     containerSpecifier:[NSApp objectSpecifier] 
                                    key:@"nicePlugins"];
    [tSpecifier setName:[self name]];
    return [tSpecifier autorelease];
    
}
@end
