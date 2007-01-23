/**
 * ControlPlay.m
 * NicePlayer
 *
 * The play button implementation.
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

#import "ControlPlay.h"

@implementation ControlPlay

-(id)initWithFrame:(NSRect)rect
{
    if ((self = [super initWithFrame:rect])) {
		[self changeToProperButton:NO];
	}
    return self;
}

-(void)mouseDown:(NSEvent *)theEvent 
{ 
	[super mouseDown:theEvent];
	[self togglePlaying];
}

-(void)togglePlaying
{
	if([actionView isPlaying])
		[(NPMovieView *)actionView stop];
	else
		[actionView start];
}

-(void)changeToProperButton:(BOOL)isPlaying
{
	iAmPlaying = isPlaying;
	if(isPlaying){
		[self changeToPauseButton];
	} else {
		[self changeToPlayButton];
	}
}

-(void)changeToPauseButton
{
    [self setImage:[NSImage imageNamed:@"pause"]];
    [self setAlternateImage:[NSImage imageNamed:@"pauseClick"]];
}

-(void)changeToPlayButton
{
	[self setImage:[NSImage imageNamed:@"play"]];
	[self setAlternateImage:[NSImage imageNamed:@"playClick"]];
}

-(void)mouseEntered:(NSEvent *)theEvent
{
	if(iAmPlaying)
		[self setImage:[NSImage imageNamed:@"pause_over"]];
	else
		[self setImage:[NSImage imageNamed:@"play_over"]];
}

-(void)mouseExited:(NSEvent *)theEvent
{
	if(iAmPlaying)
		[self setImage:[NSImage imageNamed:@"pause"]];
	else
		[self setImage:[NSImage imageNamed:@"play"]];
	[super mouseExited:theEvent];
}

@end
