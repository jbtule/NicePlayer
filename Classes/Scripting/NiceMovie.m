//
//  NiceMovie.m
//  NicePlayer
//
//  Created by James Tuley on 2/19/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "NiceMovie.h"

@implementation NiceMovie

+(id)movieWithURL:(NSURL*)aURL andPlaylist:(id)aPlaylist{
    return [[[self alloc]initWithURL:aURL andPlaylist:aPlaylist]autorelease];
}

-(id)initWithURL:(NSURL*)aURL andPlaylist:(id)aPlaylist{
    if (self = [super init]){
        theURL = [aURL retain];
        theParentPlaylist =aPlaylist;
    }return self;
}

-(NSURL*)URL{
    return theURL;
}

-(NSString*)applescriptPath{
    return [(NSString *)CFURLCopyFileSystemPath((CFURLRef)theURL,kCFURLHFSPathStyle) autorelease];

}

-(id)playlist{
    return theParentPlaylist;
}

-(id)window{
    return [[self playlist] window];
}

-(int)index{
    return [[self playlist]  indexForMovie:self];
}

-(NSString*)description{
    return [self name];
}

-(BOOL)isEqual:(id)aMovie{
    return [[self URL] isEqual:[aMovie URL]] && [[self playlist] isEqual:[aMovie playlist]];
}

-(void)handlePlayCommand:(id)sender{
    if([self playlist]  != nil){
        if(![[[self playlist] currentMovie] isEqualTo:self])
            [[self playlist]  playAtIndex:([self index] - 1) obeyingPreviousState:NO];
        [[self playlist] play:self];
    }
}

-(void)handlePauseCommand:(id)sender{
    if([self playlist]  != nil){
        if(![[[self playlist] currentMovie] isEqualTo:self])
            [[self playlist]  playAtIndex:([self index] - 1) obeyingPreviousState:NO];
        [[self playlist] pause:self];
    }
}


-(NSString*)name{
    return [[theURL path] lastPathComponent];
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
