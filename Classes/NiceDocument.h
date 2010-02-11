/**
 * NiceDocument.h
 * NicePlayer
 */


/* ***** BEGIN LICENSE BLOCK *****
* Version: MPL 1.1/GPL 2.0/LGPL 2.1
*
* The contents of this file are subject to the Mozilla Public License Version
* 1.1 (the "License"); you may not use this file except in compliance with
* the License. You may obtain a copy of the License at
* http://www.mozilla.org/MPL/
*
* Software distributed under the License is distributed on an "AS IS" basis,
* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
* for the specific language governing rights and limitations under the
* License.
*
* The Original Code is NicePlayer.
*
* The Initial Developer of the Original Code is
* James Tuley & Robert Chin.
* Portions created by the Initial Developer are Copyright (C) 2004-2006
* the Initial Developer. All Rights Reserved.
*
* Contributor(s):
*           Robert Chin <robert@osiris.laya.com> (NicePlayer Author)
*           James Tuley <jay+nicesource@tuley.name> (NicePlayer Author)
*
* Alternatively, the contents of this file may be used under the terms of
* either the GNU General Public License Version 2 or later (the "GPL"), or
* the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
* in which case the provisions of the GPL or the LGPL are applicable instead
* of those above. If you wish to allow use of your version of this file only
* under the terms of either the GPL or the LGPL, and not to allow others to
* use your version of this file under the terms of the MPL, indicate your
* decision by deleting the provisions above and replace them with the notice
* and other provisions required by the GPL or the LGPL. If you do not delete
* the provisions above, a recipient may use your version of this file under
* the terms of any one of the MPL, the GPL or the LGPL.
*
* ***** END LICENSE BLOCK ***** */



#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import "Viewer Interface/NPMovieView.h"
#import "NiceWindow/NiceWindow.h"
#import "Preferences/Preferences.h"
#import "Subtitle.h"
#import "AppleRemote.h"

@class NiceWindow;
@class NPMovieView;

@interface NiceDocument : NSDocument
{
    IBOutlet NPMovieView *theMovieView;
    id theSubtitle;
    IBOutlet id thePlaylistDrawer;
    IBOutlet id thePlaylistTable;
    IBOutlet id theRepeatButton;
	IBOutlet id theRandomButton;
    IBOutlet NiceWindow *theWindow;
    NSURL* theCurrentURL;
	unsigned int _randomIndex;
	NSMutableArray* _randomList;
    NSMutableArray* thePlaylist;
	NSMutableArray* theDataSourceCache;
        NSMutableDictionary* theMainItemCache;
    enum defaultRepeatModeValues theRepeatMode;
    id movieMenuItem;
    NSMutableArray *menuObjects;
    id asffrrTimer;
    id playlistFilename;
    NSString* theID;
    NSTimer *remoteEventTimer;
    
    BOOL hasRealMovie;
    BOOL isRandom;
    BOOL wasPlayingBeforeMini;	
}

-(void)appleRemoteButton:(RemoteControlEventIdentifier)buttonIdentifier pressedDown:(BOOL)pressedDown;

-(NSString*)identifier;
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
-(NSMenuItem*)playOrderMenu;
-(NSArray*)FullPlaylistMenuItems;
-(NSArray*)BasicPlaylistMenuItems;
-(NSArray*)playlistMenuItems;
-(NSMenuItem*)volumeMenu;

#pragma mark Interface

-(IBAction)toggleRandomMode:(id)sender;
-(IBAction)toggleRepeatMode:(id)sender;
-(IBAction)switchRepeatMode:(NSMenuItem*)sender;
-(IBAction)switchVolume:(NSMenuItem*)sender;
-(IBAction)mute:(id)sender;
-(IBAction)increaseVolume:(id)sender;
-(IBAction)decreaseVolume:(id)sender;
-(IBAction)switchPlaylistItem:(NSMenuItem*)sender;
-(void)refreshRepeatModeGUI;
-(void)play:(id)sender;
-(void)playNext:(id)sender;
-(void)playPrev:(id)sender;
-(void)pause:(id)sender;
-(unsigned)getNextIndex;
-(void)playNext;
-(void)playPrev;
-(void)playPrevWithChapter;
-(unsigned)getPrevIndex;
-(BOOL)loadPlaylistFromURL:(NSURL *)aURL;

#pragma mark -
#pragma mark Playlist
-(void)reloadPlaylist;
-(IBAction)openPlaylistDrawerConditional:(id)sender;
-(IBAction)togglePlaylistDrawer:(id)sender;
-(IBAction)openPlaylistDrawer:(id)sender;
-(IBAction)closePlaylistDrawer:(id)sender;
-(IBAction)choosePlaylistItem:(id)sender;
-(void)playAtIndex:(unsigned int)anIndex obeyingPreviousState:(BOOL)aBool;
-(IBAction)addToPlaylist:(id)sender;
-(void)addURLToPlaylist:(NSURL*)aURL;
-(void)addURLToPlaylist:(NSURL*)aURL atIndex:(int)index;
-(void)removeURLFromPlaylistHelperAtIndex:(NSIndexSet*)anIndex;
-(void)removeURLFromPlaylistAtIndex:(int)anIndex;
-(void)removeURLFromPlaylistAtIndexSet:(NSIndexSet*)anIndex;
-(void)removeURLFromPlaylist:(NSURL*)aURL;
-(void)removeURLPlaceHolders;
-(BOOL)isPlaylistEmpty;
-(BOOL)hasPlaylist;

-(float)volume;

@end
