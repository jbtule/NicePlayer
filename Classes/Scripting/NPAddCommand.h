//
//  NPAddCommand.h
//  NicePlayer
//
//  Created by James Tuley on 2/19/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class NiceDocument;

@interface NPAddCommand : NSScriptCommand {

}

-(NSURL*)getURLFromObject:(id)anObject;
-(void)addURL:(NSURL*)aURL toPlaylist:(NiceDocument *)aPlaylist atIndex:(NSNumber*)anIndex;

@end
