//
//  ParentShadowWindow.m
//  NicePlayer
//
//  Created by James Tuley on 2/15/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "ParentShadowWindow.h"


@implementation ParentShadowWindow

- (BOOL)isKeyWindow{
    return [[self parentWindow] isKeyWindow];
}

@end
