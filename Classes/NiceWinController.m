//
//  NiceDocController.m
//  NicePlayer
//
//  Created by Robert Chin on 2/14/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//


@implementation NSWindowController (NiceDocController)

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
