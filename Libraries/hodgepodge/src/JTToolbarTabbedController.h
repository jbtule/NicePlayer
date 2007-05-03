//
//  JTToolbarTabbedController.h
//  IndyKit
//
//  Created by James Tuley on 8/29/04.
//  Copyright 2004 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface JTToolbarTabbedController : NSObject {
    @protected
    NSMutableDictionary* _toolbarDict;
    NSMutableArray* _toolbarOrder;
    NSString* _lastIdentifier;
    NSView* _blankView;
    IBOutlet NSWindow* controlledWindow;
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
