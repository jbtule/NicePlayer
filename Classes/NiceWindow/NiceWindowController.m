//
//  NiceWindowController.m
//  NicePlayer
//
//  Created by James Tuley on 4/9/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "NiceWindowController.h"

@implementation NiceWindowController

- (id)initWithWindowNibName:(NSString *)windowNibName owner:(id)owner{
    if((self = [super initWithWindowNibName:windowNibName owner:owner])){
        [self setShouldCascadeWindows:NO];
    }return self;
    
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName
{
    if([displayName hasPrefix:@"Untitled"]){
        NSMutableString *newString = [NSMutableString stringWithString:displayName];
        [newString replaceOccurrencesOfString:@"Untitled"
                                   withString:@"NicePlayer"
                                      options:NSAnchoredSearch
                                        range:NSMakeRange(0, [newString length])];
        return newString;
    } else
        return displayName;
}

@end
