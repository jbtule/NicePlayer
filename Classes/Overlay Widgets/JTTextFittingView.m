//
//  JTTextFittingView.m
//  FitTextIntoView
//
//  Created by James Tuley on 9/25/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

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

#import "JTTextFittingView.h"


@implementation JTTextFittingView

-(void)dealloc{
    [theText release];
	[theAttributes release];
	[super dealloc];
}

-(void)setStringValue:(NSString*)aString{
    [theText release];
    theText = [[NSAttributedString alloc] initWithString:aString attributes:theAttributes];
    [self setNeedsDisplay:YES];
    
}

-(void)setMaxTextWidth:(double)aWidth{
	theWidth =aWidth;
}

-(void)setMaxText:(NSString*)aTextRepresentingWidth{
    NSAttributedString* tWidth = [[NSAttributedString alloc] initWithString:aTextRepresentingWidth attributes:theAttributes];

	theWidth =[tWidth size].width;
	[tWidth release];
}

-(void)setAttributes:(NSDictionary*)anAttributes{
[theAttributes release];
	theAttributes =anAttributes;
	[theAttributes retain];
}

-(NSString*)stringValue{
    return [theText string];
}

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        theText = [[NSAttributedString alloc] initWithString:@""];
		theWidth=0;
		theAttributes = [[NSDictionary alloc]init];
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)rect {
    
    // NSRectFill(NSMakeRect(0,0,[theText size].width,[theText size].height));
    double tWidth =[theText size].width;
	if(theWidth!=0){
		tWidth =theWidth;
	}
    double tRWidth =rect.size.width;
    [NSGraphicsContext saveGraphicsState];
	[self lockFocus];
   id transform = [NSAffineTransform transform];


    [transform scaleBy: tRWidth/tWidth];
	[transform translateXBy:tWidth/2.0 yBy:[theText size].height/2.0];

   [transform concat];




	//[theText drawAtPoint:NSMakePoint(0,0)];
   [theText drawInRect:NSMakeRect(-[self frame].size.width/2.0,-[theText size].height/2.0,[self frame].size.width,[theText size].height)];
	[self unlockFocus];
    [NSGraphicsContext restoreGraphicsState];
}

@end
