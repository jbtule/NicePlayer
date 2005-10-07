/*
 *  NiceUtilities.c
 *  NicePlayer
 *
 *  Created by James Tuley on 12/11/04.
 *  Copyright 2004 __MyCompanyName__. All rights reserved.
 *
 */

#import "NiceUtilities.h"
#import "NPPluginReader.h"
#import <IndyKit/IndyKit.h>
id NPConvertFileNamesToURLs(id obj, void* context){
    return [NSURL fileURLWithPath:obj];
}

BOOL NPIs10_4OrGreater(){

    long vers;
    Gestalt( gestaltSystemVersion, &vers);
    return !(vers < 0x00001040);
}


NSArray* NPSortUrls(NSArray* anArrayOfUrls){
    int urlSort(id url1, id url2, void *context){
        
        NSString* v1 = [[url1 path] lastPathComponent];
        NSString*  v2 = [[url2 path]lastPathComponent];
        return [v1 caseInsensitiveCompare:v2];
        
    }
    return [anArrayOfUrls sortedArrayUsingFunction:urlSort context:nil];
}


id NPInjectNestedDirectories(id each, id injected, void* verifyBool){
    if([[each pathExtension] isEqualToString:@""]){
        BOOL tBool = NO;
        if([[NSFileManager defaultManager] fileExistsAtPath:each isDirectory:&tBool] && tBool){
            NSArray* tSubPaths =[[NSFileManager defaultManager] directoryContentsAtPath:each];
            if([[each lastPathComponent] isEqualToString:@"VIDEO_TS"]){
                [injected addObject:[each stringByDeletingLastPathComponent]];
            } else if([tSubPaths containsObject:@"VIDEO_TS"]){
                [injected addObject:each];
            }else{
                id appendToEach(id aLastPath,void* aPrefix){
                   return [each stringByAppendingPathComponent:aLastPath];
                }
                
                tSubPaths = [tSubPaths collectUsingFunction:appendToEach context:NULL];
                BOOL tVerifyType = YES;
                injected =[tSubPaths injectUsingFunction:NPInjectNestedDirectories into:injected context:&tVerifyType];
            }

        }else if(! *(BOOL*)verifyBool || [[[NPPluginReader pluginReader] allowedExtensions] containsObject: NSHFSTypeOfFile(each)] ){
            [injected addObject:each];
        }
    } else if(!*(BOOL*)verifyBool || [[[NPPluginReader pluginReader] allowedExtensions] containsObject: [each pathExtension]] ){
            [injected addObject:each];
    }
    return injected;
}

@implementation NSString (niceStringComparisonAdditions)

-(NSComparisonResult)caseInsensitiveNumericCompareSublist:(NSString *)aString
{
	return [self compare:aString
				 options:(NSCaseInsensitiveSearch | NSLiteralSearch)
				   range:NSMakeRange(0, [aString length])];
}

@end