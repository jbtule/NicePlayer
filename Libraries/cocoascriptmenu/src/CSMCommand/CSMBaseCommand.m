//
//  CSMBaseCommand.m
//  CocoaScriptMenu
//
//  Created by James Tuley on 3/25/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "CSMBaseCommand.h"
#import "CSMMenuNameParser.h"


@interface CSMCommand(Private)
+(id)CSM_alloc;
@end

@implementation CSMCommand(Private)
+(id)CSM_alloc{
    return [super alloc];
}
@end

@implementation CSMBaseCommand

+(id)alloc{
    return [self CSM_alloc];
}

-(id)initWithScriptPath:(NSString*) aPath{
    if(self = [super init]){
        theFilePath = [[aPath stringByStandardizingPath] retain];
        theNameParser = [[[[[self superclass] menuNameParser] class] alloc] initWithPath:theFilePath];
    }return self;
}



@end
