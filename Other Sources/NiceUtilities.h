/*
 *  NiceUtilities.h
 *  NicePlayer
 *
 *  Created by James Tuley on 12/11/04.
 *  Copyright 2004 __MyCompanyName__. All rights reserved.
 *
 */
#import <cocoa/cocoa.h>

extern id NPConvertFileNamesToURLs(id obj, void* context);
extern NSArray* NPSortUrls(NSArray* anArrayOfUrls);
extern id NPInjectNestedDirectories(id each, id injected, void* context);
extern BOOL NPIs10_4OrGreater();
@interface NSString (niceSortingAdditions)
-(NSComparisonResult)niceStringComparisonAdditions:(NSString *)aString;
@end