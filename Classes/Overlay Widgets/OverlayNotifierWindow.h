//
//  OverlayNotifierWindow.h
//  NicePlayer
//
//  Created by Robert Chin on 4/9/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OverlayWindow.h"

@interface OverlayNotifierWindow : OverlayWindow {
    IBOutlet id theNotificationText;
}

-(void)setText:(NSString *)aString;

@end
