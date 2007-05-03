//
//  JTUpdateAlertPanelController.h
//  IndyKit
//
//  Created by James Tuley on 11/22/04.
//  Copyright 2004 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <HodgePodge/IndyKit.h>

@interface JTUpdateAlertPanelController : NSWindowController {
    NSString* theHeadlinePlaceHolder;
    IBOutlet NSTextField* theHeadline;
    IBOutlet JTURLButton* theURL;
    IBOutlet NSTextView* theChanges;
    IBOutlet NSButton* theLaunchCheck;
}
-(id) initWithWindowNibPath:(id)filePath;
-(IBAction)checkForUpdates:(id)sender;

-(void)loadInUpdateInfo:(NSDictionary*)anInfo;

@end
