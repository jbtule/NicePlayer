//
//  JTUpdateAlertPanelController.m
//  IndyKit
//
//  Created by James Tuley on 11/22/04.
//  Copyright 2004 __MyCompanyName__. All rights reserved.
//

#import "JTUpdateAlertPanelController.h"

#define LocalizeIt(arg) NSLocalizedStringFromTableInBundle(arg, nil,[NSBundle bundleForClass:[self class]],@"no comment")
@implementation JTUpdateAlertPanelController

-(id) initWithWindowNibPath:(id)filePath{
    if (self = [super initWithWindowNibPath:filePath owner:self]){
        
    }return self;
}


-(void)windowDidLoad{
    theHeadlinePlaceHolder = [theHeadline stringValue];
    //NSLog(@"awake from nib");
    [theLaunchCheck setState:[NSApp allowAutomaticCheckForUpdates]];
}

-(IBAction)checkForUpdates:(id)sender{
    [NSApp setAllowAutomaticCheckForUpdates:[theLaunchCheck state]];
}

-(void)loadInUpdateInfo:(NSDictionary*)anInfo{
   // NSLog(@"loadInUpdateInfo");

   // NSLog(@"%@",anInfo);
    
   // NSLog(@"hed: %@",theHeadline);

    
    [theHeadline setStringValue:[NSString stringWithFormat:LocalizeIt(@"New version %@ %@ (v%@) available."),[anInfo objectForKey:@"BundleName"],[anInfo objectForKey:@"HumanVersion"],[anInfo objectForKey:@"BundleVersion"],nil]];
    [theURL setURLabsoluteString:[anInfo objectForKey:@"URL"]];
    [[theChanges textStorage]setAttributedString:[anInfo objectForKey:@"Changes"]];
    //NSLog(@"done loadInUpdateInfo");

}

@end
