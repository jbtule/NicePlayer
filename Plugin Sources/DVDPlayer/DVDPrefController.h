//
//  DVDPrefController.h
//  DVDPlayer
//
//  Created by Robert Chin on 3/13/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DVDPrefController : NSObject {
	IBOutlet id languageAudioPopUp;
	IBOutlet id languageSubtitlesPopUp;
	IBOutlet id languageMenusPopUp;
}

-(IBAction)setLanguageAudio:(id)sender;
-(IBAction)setLanguageSubtitles:(id)sender;
-(IBAction)setLanguageMenus:(id)sender;

@end
