//
//  JTURLButton.m
//  IndyKit
//
//  Created by James Tuley on Sun Aug 01 2004.
//  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
//

#import "JTURLButton.h"
#import "JTURLButtonCell.h"


@implementation JTURLButton

-(id)initWithFrame:(NSRect)aRect{
    if(self = [super initWithFrame:aRect]){
        id tempCursor=[NSCursor pointingHandCursor];
        [self addCursorRect:[self frame] cursor:tempCursor];
        [tempCursor setOnMouseEntered:YES];
    }return self;
}
- (id)initWithCoder:(NSCoder *)decoder{
    if(self = [super initWithCoder:decoder]){
    }return self;
}

- (void)resetCursorRects{
    id tempCursor=[NSCursor pointingHandCursor];
    [self addCursorRect:[self bounds] cursor:tempCursor];
    
}

-(NSString*)URLabsoluteString{
    return [[[self cell] URL] absoluteString];
}

-(void)setURLabsoluteString:(NSString*)aString{
    [self setURL:[NSURL URLWithString:aString]];
}


-(NSURL*)URL{
    return [[self cell] URL];
}

-(void)setURL:(NSURL*)aURL{
    [[self cell] setURL:aURL];
    [self setNeedsDisplay:YES];
}



- (void)mouseDown:(NSEvent *)theEvent{

    [[self cell] setMouseDown:YES];
    [super mouseDown:theEvent];
    [[self cell] setMouseDown:NO];
    [[self cell] mouseEntered:theEvent];
}

+ (void)initialize {
    if (self == [JTURLButton class]) {		// Do it once
        [self setCellClass: [JTURLButtonCell class]];
    }
}

+ (Class) cellClass{
    return [JTURLButtonCell class];
}
- (BOOL)isOpaque{
    return NO;
}
@end
