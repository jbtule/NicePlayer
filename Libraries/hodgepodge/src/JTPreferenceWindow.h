//
//  JTPrefWindowController.h
/*
 iEatBrainz
 Copyright (c) 2004, James Tuley
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 
 * Neither the name of James Tuley nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */
//  iEatBrainz
//
//  Created by James Tuley on Sun Apr 11 2004.
//  Copyright (c) 2004 James Tuley. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface JTPreferenceWindow : NSWindow {
    @protected
    NSMutableDictionary* _toolbarDict;
    NSMutableArray* _toolbarOrder;
    NSString* _lastIdentifier;
    NSView* _blankView;
    @private
    NSString* _suffix;
    NSString* _prefix;
    id _reserved;
    id _reserved2;
    id _reserved3;
    id _reserved4;
}
-(void)setTitleSuffix:(NSString*)aSuffix;
-(NSString*)titleSuffix;

-(void)setTitlePrefix:(NSString*)aPrefix;
-(NSString*)titlePrefix;

-(void)showPaneWithIdentifier:(NSString*)anIdentifier;

-(void)addPane:(NSView*)aView 
      withIcon:(NSImage*)anImage
withIdentifier:(NSString*)anIdentifier
     withLabel:(NSString*)aLabel
   withToolTip:(NSString*)aToolTip
allowingResize:(BOOL)allowResize;


@end
