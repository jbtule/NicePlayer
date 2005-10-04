//
//  NicePlugins.h
//  NicePlayer
//
//  Created by James Tuley on 10/3/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NicePlugin : NSObject {
    Class theClass;
}

+(id)pluginForClass:(Class)aClass;

-(id)initForClass:(Class)aClass;

-(NSString*)name;

-(NSString*)humanName;

-(Class)classRep;

-(NSArray*)fileTypes;

@end
