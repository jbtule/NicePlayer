/**
 * NiceDocument.h
 * NicePlayer
 */

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import <IndyKit/IndyFoundation.h>
#import "Viewer Interface/NPMovieView.h"
#import "NiceWindow/NiceWindow.h"
#import "Preferences/Preferences.h"
#import "Subtitle.h"

@class NiceWindow;
@class NPMovieView;

@interface NiceDocument : NSDocument
{
    IBOutlet NPMovieView *theMovieView;
    id theSubtitle;
    IBOutlet id thePlaylistDrawer;
    IBOutlet id thePlaylistTable;
    IBOutlet id theRepeatButton;
    IBOutlet NiceWindow *theWindow;
    NSURL* theCurrentURL;
    NSMutableArray* thePlaylist;
    NSMutableArray* theRandomizePlayList;
    enum defaultRepeatModeValues theRepeatMode;
	BOOL hasRealMovie;
	BOOL isRandom;
	id movieMenuItem;
	NSMutableArray *menuObjects;
	id asffrrTimer;
}

-(NSData *)dataRepresentationOfType:(NSString *)aType;
-(BOOL)readFromFile:(NSString *)fileName ofType:(NSString *)docType;
-(BOOL)readFromURL:(NSURL *)url ofType:(NSString *)docType;
-(void)loadURL:(NSURL *)url firstTime:(BOOL)isFirst;
-(BOOL)finalOpenURLFirstTime:(BOOL)isFirst;

#pragma mark Window Information

-(BOOL)isActive;
-(void)windowDidDeminiaturize:(NSNotification *)aNotification;
-(void)windowControllerDidLoadNib:(NSWindowController *) aController;
-(void)updateAfterLoad;
- (void)repositionAfterLoad;
-(void)movieHasEnded;
-(id)subTitle;
-(NSMenu *)movieMenu;
-(void)rebuildMenu;
-(id)window;
-(NSSize)calculateAspectRatio;

#pragma mark Interface

-(IBAction)toggleRandomMode:(id)sender;
-(IBAction)toggleRepeatMode:(id)sender;
-(void)refreshRepeatModeGUI;
-(void)play:(id)sender;
-(void)playNext:(id)sender;
-(void)pause:(id)sender;
-(unsigned)getNextIndex;
-(void)playNext;
-(void)playPrev;
-(unsigned)getPrevIndex;

#pragma mark -
#pragma mark Playlist

-(IBAction)openPlaylistDrawerConditional:(id)sender;
-(IBAction)togglePlaylistDrawer:(id)sender;
-(IBAction)openPlaylistDrawer:(id)sender;
-(IBAction)closePlaylistDrawer:(id)sender;
-(IBAction)choosePlaylistItem:(id)sender;
-(void)playAtIndex:(unsigned int)anIndex obeyingPreviousState:(BOOL)aBool;
-(IBAction)addToPlaylist:(id)sender;
-(void)addURLToPlaylist:(NSURL*)aURL;
-(void)addURLToPlaylist:(NSURL*)aURL atIndex:(int)index;
-(void)removeURLFromPlaylist:(NSURL*)aURL;
-(void)removeURLPlaceHolders;
-(BOOL)isPlaylistEmpty;

@end
