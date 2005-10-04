//
//  NiceMovie.h
//  NicePlayer
//
//  Created by James Tuley on 2/19/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NiceMovie : NSObject {
    NSURL * theURL;
    id theParentPlaylist;
}

+(id)movieWithURL:(NSURL*)aURL andPlaylist:(id)aPlaylist;
-(id)initWithURL:(NSURL*)aURL andPlaylist:(id)aPlaylist;
-(NSURL*)URL;

-(NSString*)fileType;
-(NSString*)fileExtension;

-(NSString*)name;

-(NSArray*)suitablePlugins;

@end
