//
//  JTPreferenceWindow-Private.h
//  IndyKit
//
//  Created by James Tuley on Fri Jun 18 2004.
//  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HodgePodge/JTPreferenceWindow.h>




@interface JTPreferenceWindow(Private)

-(float)_JTtoolbarHeightForWindow;
-(void)_JTshowPaneWithView:(NSView*)myNewView andResetWidth:(BOOL)widthReset;
-(IBAction)_JTshowPane:(NSToolbarItem*)sender;
- (void)_JTlazyInitialize;

@end
