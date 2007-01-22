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
	
	UInt32 cid;
	BOOL openedVolume;
}

-(void)updateBounds;
-(void)resizeToAspect;

-(void)previousChapter;
-(void)nextChapter;

-(id)titleMenu;
-(id)chapterMenu;
-(id)audioMenu;
-(id)angleMenu;
-(id)subPictureMenu;

-(float)titleAspectRatio;
-(void)gotoMainMenu;
-(id)bookmarksForCurrentDisc;

-(IBAction)setBookmarkForCurrentDiscWithNameField:(NSBookmarkCreateButton *)sender;

- (void) setVideoDisplay;

@end
