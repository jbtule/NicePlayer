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

+(id)movieWithURL:(NSURL*)aURL;
+(id)movieWithFile:(NSString*)aPath;
-(id)initWithURL:(NSURL*)aURL;

-(NSURL*)path;

-(NSString*)name;

@end
