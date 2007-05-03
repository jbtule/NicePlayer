//
//  NSImage-JTAdditionsPrivate.m
//  IndyKit
//
//  Created by James Tuley on Fri Jun 18 2004.
//  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
//

#import "NSImage-JTAdditionsPrivate.h"


@implementation  NSImage(JTAdditionsPrivate)

-(NSImage*)_JTimageCroppedWithGrid:(int)rows by:(int)cols takingSquareAt:(NSPoint)rowCol{
    NSSize tempSize = [self size];
    int smallWidth = tempSize.width/cols;
    int smallHeight = tempSize.height/rows;
    NSRect tempRect = NSMakeRect((rowCol.y-1)*smallWidth,(rows-(rowCol.x))*smallHeight,smallWidth,smallHeight);
    NSImage* tempImage =[[[NSImage alloc] initWithSize:NSMakeSize(smallWidth,smallHeight)] autorelease];
    
    [tempImage lockFocus];
    [self drawInRect:NSMakeRect(0,0,smallWidth,smallHeight) fromRect:tempRect operation:NSCompositeCopy fraction:1.0];
    [tempImage unlockFocus];
    
    return tempImage;
}

@end
