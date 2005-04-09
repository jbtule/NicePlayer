//
//  FadeOut.h
//  NicePlayer
//
//  Created by Robert Chin on 2/11/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FadeOut : NSObject {
	NSMutableSet *windowSet;
	NSTimer *faderTimer;
}

+(id)fadeOut;
-(id)init;
-(id)initialFadeForDict:(id)anArray;
-(id)notifierFadeForDict:(id)aDictionary;
-(id)fadeForDict:(id)aDictionary inSeconds:(float)seconds actuallyDisplay:(BOOL)aBool;
-(void)doFadeForDict:(id)aTimer;
-(void)addWindow:(id)anObject;
-(void)removeWindow:(id)anObject;
-(void)destroyAndCreateTimer;
-(void)updateAlphaValues;
-(void)testForRemoval;

@end
