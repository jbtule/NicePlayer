//
//  PrefPluginConfig.h
//  NicePlayer
//
//  Created by Robert Chin on 12/12/04.
//  Copyright 2004 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PrefPluginConfig : NSTableView {
	IBOutlet id nameLabel;
	IBOutlet id visibleView;
	IBOutlet id insertView;
	NSRect oldWindowFrame;
	NSRect oldViewFrame;
	NSView *currSubview;
}

-(id)classForRow:(int)row;
-(void)hideWidgets;
-(void)showWidgets;

@end
