//
//  JTURLButtonCell.h
//  IndyKit
//
//  Created by James Tuley on Sun Aug 01 2004.
//  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>
#import <HodgePodge/IndyKit.h>

@interface JTURLButtonCell : NSButtonCell {
    NSURL* _goToURL;
    BOOL _mouseIsDown;
    BOOL _mouseIsEntered;
}
-(BOOL)mouseDown;
@end
