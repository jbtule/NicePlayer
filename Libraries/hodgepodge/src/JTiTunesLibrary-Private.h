//
//  JTiTunesLibrary-Private.h
//  IndyKit
//
//  Created by James Tuley on Fri Jun 18 2004.
//  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HodgePodge/JTiTunesLibrary.h>


@interface JTiTunesLibrary(Private)

-(BOOL)_loadiTunesImages:(NSArray*)rsrcGroups;
-(void)_databaseChanged;
-(BOOL)_JTappleScriptHackHashMatchedBetweenHash:(NSString*)aHash andTrack:(id)aTrack;
-(void)_createAliasCache;
@end
