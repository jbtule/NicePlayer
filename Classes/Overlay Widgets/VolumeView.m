/**
 * VolumeView.m
 * NicePlayer
 *
 * The view that displays the volume overlay when the volume is adjusted.
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

#import "VolumeView.h"

@implementation VolumeView

-(id)initWithCoder:(id)aCoder{
    self =[super initWithCoder:aCoder];
    muted = NO;
    volume=1.0;
    return self;
}

- (BOOL)acceptsFirstResponder
{
	return NO;
}

-(void)setVolume:(float)aVolume{
    volume = aVolume;
    [self setNeedsDisplay];

}

-(void)setMuted:(BOOL)aBOOL{
    muted = aBOOL;
    if(muted)
        [self setImage:[NSImage imageNamed:@"volume_muted"]];
    else
        [self setImage:[NSImage imageNamed:@"volume_with_sound"]];
    [self setNeedsDisplay];
}

- (void)drawRect:(NSRect)aRect{
    [super drawRect:aRect];   
    if(!muted){
        float hue;
        float top;
        if (volume <=1.0){
            hue =117.0/360.0;
            top =1.0;
        }else{
            hue = 0.0;
            top =2.0;
        }
            
        [[NSColor colorWithDeviceHue:hue
                         saturation:.5
                         brightness:(top/volume)
                              alpha:1.0] set];
        
            NSRectFill(NSMakeRect(20,15,32*volume,8));
    }
}

@end
