//
//  JTURLButton.h
//  IndyKit
//
//  Created by James Tuley on Sun Aug 01 2004.
//  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>


@interface JTURLButton : NSButton {
}

-(void)setURL:(NSURL*)aURL;
-(NSURL*)URL;
@end
