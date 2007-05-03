//
//  NSToolbar-JTAddition.m
//  IndyKit
//
//  Created by James Tuley on Sat Jul 17 2004.
//  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
//

#import "NSToolbar-JTAdditions.h"


@implementation NSToolbar (JTAdditions)

-(IBAction)resetToolbarToDefaults:(id)sender{
    while([[self items] count])
        [self removeItemAtIndex:0];
    
    id enumerator = [[[self delegate] toolbarDefaultItemIdentifiers:self] reverseObjectEnumerator];
    id object;
    
    while(object = [enumerator nextObject]){
        [self insertItemWithItemIdentifier:object atIndex:0];
    }
    
}

@end
