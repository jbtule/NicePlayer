//
//  NPApplicationScripting.m
//  NicePlayer
//
//  Created by James Tuley on 2/19/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "NPApplicationScripting.h"


@implementation NPApplication(Scripting)

-(NSArray *)niceMovies
{
    NSMutableArray* tArray =[NSMutableArray array];
    id tPlaylist =[self orderedDocuments];
    int i;
    for(i=0;i<[tPlaylist count];i++){
        [tArray addObjectsFromArray:[[tPlaylist objectAtIndex:i] niceMovies]];
    }
    return tArray;
}

@end
