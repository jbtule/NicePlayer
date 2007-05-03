//
//  NSApplication-JTAdditions.h
//  IndyKit
//
//  Created by James Tuley on Tue Jul 06 2004.
//  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
//

#import <cocoa/cocoa.h>


@interface NSApplication (JTAdditions) 

-(IBAction)emailAuthor:(id)sender;
-(IBAction)checkForUpdates:(id)sender;
-(IBAction)automaticCheckForUpdates:(id)sender;

@end
