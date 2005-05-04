/*
 *  NiceUtilities.c
 *  NicePlayer
 *
 *  Created by James Tuley on 12/11/04.
 *  Copyright 2004 __MyCompanyName__. All rights reserved.
 *
 */

#import "NiceUtilities.h"

id NPConvertFileNamesToURLs(id obj, void* context){
    return [NSURL fileURLWithPath:obj];
}

NSArray* NPSortUrls(NSArray* anArrayOfUrls){
    int urlSort(id url1, id url2, void *context){
        
        NSString* v1 = [[url1 path] lastPathComponent];
        NSString*  v2 = [[url2 path]lastPathComponent];
        return [v1 caseInsensitiveCompare:v2];
        
    }
    return [anArrayOfUrls sortedArrayUsingFunction:urlSort context:nil];
}

@implementation NSString (niceStringComparisonAdditions)

-(NSComparisonResult)caseInsensitiveNumericCompareSublist:(NSString *)aString
{
	return [self compare:aString
				 options:(NSCaseInsensitiveSearch | NSLiteralSearch)
				   range:NSMakeRange(0, [aString length])];
}

@end