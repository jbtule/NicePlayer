//
//  JTToolbarTabbedWindow.m
//  IndyKit
//
//  Created by James Tuley on 8/29/04.
//  Copyright 2004 __MyCompanyName__. All rights reserved.
//

#import "JTToolbarTabbedWindow.h"


@implementation JTToolbarTabbedWindow

- (unsigned int)styleMask{
    
    if([self showsResizeIndicator])
        return NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask;  
    else
        return NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask;
}


@end
