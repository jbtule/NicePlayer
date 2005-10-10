//
//  NPApplication.h
//  NicePlayer
//
//  Created by Robert Chin on 11/1/04.
//  Copyright 2004 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "NiceController.h"

@interface NPApplication : NSApplication {
	NSTimer *inactiveTimer;
	NSPoint lastPoint;
}
-(void)copyDefaultScriptsToApplicationSupport;
-(id)bestMovieWindow;
-(NSArray *)movieWindows;
-(IBAction)visitNicePlayerWebSite:(id)sender;
-(IBAction)visitProjectRoadmap:(id)sender;
-(IBAction)donateToNicePlayer:(id)sender;
-(IBAction)onlineSupportWikiFAQ:(id)sender;
-(IBAction)submitBug:(id)sender;
-(IBAction)featureRequest:(id)sender;
@end
