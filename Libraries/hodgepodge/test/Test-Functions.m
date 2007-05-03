/*
 *  Test-Functions.c
 *  IndyKit
 *
 *  Created by James Tuley on Fri Jun 18 2004.
 *  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
 *
 */

#import "Test-Functions.h"

id convertToNumbers(id obj, void * context){
    return [NSNumber numberWithInt:[obj intValue]];
}

BOOL selectNegativeNumbers(id obj, void * context){
    return [obj intValue] < 0;
}

id concatElements(id obj,id concat, void * context){
    return [concat stringByAppendingString:obj];
}


id sumElements(id obj,id sum, void * context){
    return [NSNumber numberWithInt:[sum intValue] + [obj intValue]];
}