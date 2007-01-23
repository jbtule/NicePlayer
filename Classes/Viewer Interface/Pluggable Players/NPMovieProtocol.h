//
/**
 * NPMovieProtocol.m
 * NicePlayer
 *
 * Defines the basic protocol that views must adhere to if they are to be considered supported
 * plugins. You should adopt this protocol, as well as inheriting from NPPluginView (or,
 * implement the necessary methods contained in NPPluginView).
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
* Portions created by the Initial Developer are Copyright (C) 2004-2005
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
#import <AppKit/NSDragging.h>

enum direction { DIRECTION_BACKWARD = -1, DIRECTION_FORWARD = 1};

@protocol NPMoviePlayer

/**
 * Use something like this:
 * [NSDictionary dictionaryWithObjects:@"Quicktime", self,		nil
 *							   forKeys:@"Name",		 @"Class",	nil ];
 * The keys that should exist are: Name, Class.
 */
 
+(NSDictionary *)plugInfo;
+(BOOL)hasConfigurableNib;
+(id)configureNibView;

-(id)initWithFrame:(NSRect)frame;
-(void)close;
-(BOOL)openURL:(NSURL *)url;

-(BOOL)loadMovie;

-(void)keyDown:(NSEvent *)anEvent;
-(void)keyUp:(NSEvent *)anEvent;
-(void)mouseDown:(NSEvent *)anEvent;
-(void)mouseMoved:(NSEvent *)anEvent;

/**
 * Sent on screen size change.
 */
-(void)drawMovieFrame;

-(NSSize)naturalSize;
-(void)setLoopMode:(NSQTMovieLoopMode)flag;

-(BOOL)muted;
-(void)setMuted:(BOOL)aBOOL;
-(float)volume;
-(void)setVolume:(float)aVolume;

-(BOOL)isPlaying;
-(void)start;
-(void)stop;

-(void)ffStart:(int)seconds;
-(void)ffDo:(int)seconds;
-(void)ffEnd;
-(void)rrStart:(int)seconds;
-(void)rrDo:(int)seconds;
-(void)rrEnd;

-(void)stepBackward;
-(void)stepForward;

-(BOOL)hasEnded:(id)sender;

-(double)totalTime;
-(double)currentMovieTime;
-(void)setCurrentMovieTime:(double)newMovieTime;
-(double)currentMovieFrameRate;

-(id)menuPrefix;
-(id)menuTitle;
-(id)pluginMenu;

/** Extra Must Implement Methods **/

@end
