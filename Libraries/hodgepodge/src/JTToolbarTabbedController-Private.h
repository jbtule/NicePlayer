//
//  JTToolbarTabbedWindow-Private.h
//  IndyKit
//
//  Created by James Tuley on 8/29/04.
//  Copyright 2004 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JTToolbarTabbedController.h"

@interface JTToolbarTabbedController(Private)

-(float)_JTtoolbarHeightForWindow;
-(void)_JTshowPaneWithView:(NSView*)myNewView andResetWidth:(BOOL)widthReset;
-(IBAction)_JTshowPane:(NSToolbarItem*)sender;
- (void)_JTlazyInitialize;

@end
