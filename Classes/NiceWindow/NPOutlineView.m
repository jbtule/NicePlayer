//
//  NPOutlineView.m
//  NicePlayer
//
//  Created by James Tuley on 11/4/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "NPOutlineView.h"


@implementation NPOutlineView
- (NSImage *)dragImageForRowsWithIndexes:(NSIndexSet *)dragRows tableColumns:(NSArray *)tableColumns event:(NSEvent*)dragEvent offset:(NSPointPointer)dragImageOffset{
	NSMutableArray* tArray =[NSMutableArray array];
	unsigned current_index = [dragRows firstIndex];
    while (current_index != NSNotFound)
    {
		id tItem = [self itemAtRow:current_index];
		if(![[tItem objectForKey:@"type"] isEqualTo:@"chapter"]){
			[tArray addObject: [[tItem objectForKey:@"url"] path]];
		}
        
		current_index = [dragRows indexGreaterThanIndex: current_index];
    }
	
	return [[NSWorkspace sharedWorkspace] iconForFiles:tArray];
}


@end
