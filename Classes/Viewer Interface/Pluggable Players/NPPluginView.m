/**
 * NPPluginView.m
 * NicePlayer
 *
 * A superclass for plugins to inherit off of. You'll want to use -Wno-protocol so that you
 * don't get warnings about unimplemented protocol methods that are not implemented in your
 * subclass, but are implemented in this superclass.
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




#import "NPPluginView.h"
#import "NPMovieProtocol.h"

@implementation NPPluginView

+(BOOL)hasConfigurableNib
{
	return NO;
}

+(id)configureNibView
{
    NSLog(@"Error");
    return nil;
}

/* Forward all drag events to the window itself. */
-(NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
	return [[self window] draggingEntered:sender];
}

-(NSDragOperation)draggingUpdated:(id)sender
{
	return [[self window] draggingUpdated:sender];
}

-(BOOL)prepareForDragOperation:(id)sender
{
	return [[self window] prepareForDragOperation:sender];
}

-(BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
	return [[self window] performDragOperation:sender];
}

-(void)concludeDragOperation:(id <NSDraggingInfo>)sender
{
	[[self window] concludeDragOperation:sender];
}

-(void)ffStart:(int)seconds
{
	if(oldPlayState == STATE_INACTIVE)
		oldPlayState = [(<NPMoviePlayer>)self isPlaying] ? STATE_PLAYING : STATE_STOPPED;
	[(<NPMoviePlayer>)self stop];
}

-(void)ffEnd
{
	if(oldPlayState == STATE_PLAYING)
		[(<NPMoviePlayer>)self start];
	else
		[(<NPMoviePlayer>)self stop];
	oldPlayState = STATE_INACTIVE;
}

-(void)rrStart:(int)seconds
{
	if(oldPlayState == STATE_INACTIVE)
		oldPlayState = [(<NPMoviePlayer>)self isPlaying] ? STATE_PLAYING : STATE_STOPPED;
	[(<NPMoviePlayer>)self stop];
}

-(void)rrEnd
{
	if(oldPlayState == STATE_PLAYING)
		[(<NPMoviePlayer>)self start];
	else
		[(<NPMoviePlayer>)self stop];
	oldPlayState = STATE_INACTIVE;
}

@end
