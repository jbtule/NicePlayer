//
//  Subtitle.h
//  NicePlayer
//
//  Created by James Tuley on 11/18/04.
//  Copyright 2004 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Subtitle : NSObject {
    uint* timeVector;
    int intervals;
    float timeOffset;
    uint lastCheck;
    NSMutableArray* theText;
}

-(id)initWithFile:(id)aPath forMovieSeconds:(float)aSeconds;
-(NSString*)stringForTime:(float)aTime;
-(void)_JTparseSubRipFile:(NSString*)aContents;
-(void)_JTMicroDVD:(NSString*)aContents;
- (NSString*)lineEndingTypeForFileContents:(NSString *)fileContents;

@end
