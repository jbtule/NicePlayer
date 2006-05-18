/**
 * DVDPlayerView.h
 * NicePlayer
 */

#import <Cocoa/Cocoa.h>
#import "NPMovieProtocol.h"
#import "NPPluginView.h"

@class NSBookmarkCreateButton;

@interface DVDPlayerView : NPPluginView <NPMoviePlayer>
{
	NSURL *myURL;
	id updateChapterTimer;
	
	UInt32 cid, cid1, cid2, cid3;
}

-(void)previousChapter;
-(void)nextChapter;

-(id)titleMenu;
-(id)chapterMenu;
-(id)audioMenu;
-(id)angleMenu;
-(id)subPictureMenu;

-(void)gotoMainMenu;
-(id)bookmarksForCurrentDisc;

-(IBAction)setBookmarkForCurrentDiscWithNameField:(NSBookmarkCreateButton *)sender;

@end
