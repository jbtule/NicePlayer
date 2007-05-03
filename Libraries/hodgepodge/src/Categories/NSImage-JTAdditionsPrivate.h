//
//  NSImage-JTAdditionsPrivate.h
//  IndyKit
//
//  Created by James Tuley on Fri Jun 18 2004.
//  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSImage-JTAdditions.h"


@interface NSImage(JTAdditionsPrivate)
-(NSImage*)_JTimageCroppedWithGrid:(int)rows by:(int)cols takingSquareAt:(NSPoint)rowCol;
@end
