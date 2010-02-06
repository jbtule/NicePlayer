/*
 *  NiceUtilities.c
 *  NicePlayer
 *
 *  Created by James Tuley on 12/11/04.
 *  Copyright 2004 __MyCompanyName__. All rights reserved.
 *
 */

/* ***** BEGIN LICENSE BLOCK *****
* Version: MPL 1.1/GPL 2.0/LGPL 2.1
*
* The contents of this file are subject to the Mozilla Public License Version
* 1.1 (the "License"); you may not use this file except in compliance with
* the License. You may obtain a copy of the License at
* http://www.mozilla.org/MPL/
*
* Software distributed under the License is distributed on an "AS IS" basis,
* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
* for the specific language governing rights and limitations under the
* License.
*
* The Original Code is NicePlayer.
*
* The Initial Developer of the Original Code is
* James Tuley & Robert Chin.
* Portions created by the Initial Developer are Copyright (C) 2004-2006
* the Initial Developer. All Rights Reserved.
*
* Contributor(s):
*           Robert Chin <robert@osiris.laya.com> (NicePlayer Author)
*           James Tuley <jay+nicesource@tuley.name> (NicePlayer Author)
*
* Alternatively, the contents of this file may be used under the terms of
* either the GNU General Public License Version 2 or later (the "GPL"), or
* the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
* in which case the provisions of the GPL or the LGPL are applicable instead
* of those above. If you wish to allow use of your version of this file only
* under the terms of either the GPL or the LGPL, and not to allow others to
* use your version of this file under the terms of the MPL, indicate your
* decision by deleting the provisions above and replace them with the notice
* and other provisions required by the GPL or the LGPL. If you do not delete
* the provisions above, a recipient may use your version of this file under
* the terms of any one of the MPL, the GPL or the LGPL.
*
* ***** END LICENSE BLOCK ***** */

#import "NiceUtilities.h"
#import "NPPluginReader.h"
#import <STEnum/STEnum.h>
id NPConvertFileNamesToURLs(id obj, void* context){
    return [NSURL fileURLWithPath:obj];
}

BOOL NPIs10_4OrGreater(){
    long vers;
    Gestalt( gestaltSystemVersion, &vers);
    return !(vers < 0x00001040);
}

int urlSort(id url1, id url2, void *context){
    
    NSString* v1 = [[url1 path] lastPathComponent];
    NSString*  v2 = [[url2 path]lastPathComponent];
    return [v1 caseInsensitiveCompare:v2];
    
}

NSArray* NPSortUrls(NSArray* anArrayOfUrls){
 
    return [anArrayOfUrls sortedArrayUsingFunction:urlSort context:nil];
}

id appendToEach(id aLastPath,void* aPrefix){
    return [(NSString*)aPrefix stringByAppendingPathComponent:aLastPath];
}

id NPInjectNestedDirectories(id each, id injected, void* verifyBool){
	BOOL tVerify = *(BOOL*)verifyBool;
	if([[each lastPathComponent] hasPrefix:@"."])
	   return injected;
    if([[each pathExtension] isEqualToString:@""]){
        BOOL tBool = NO;
        if([[NSFileManager defaultManager] fileExistsAtPath:each isDirectory:&tBool] && tBool){
            NSArray* tSubPaths =[[NSFileManager defaultManager] directoryContentsAtPath:each];
            if([[each lastPathComponent] isEqualToString:@"VIDEO_TS"]){
                [injected addObject:[each stringByDeletingLastPathComponent]];
            } else if([tSubPaths containsObject:@"VIDEO_TS"]){
                [injected addObject:each];
            }else{

				BOOL tNestedVerify = YES;
                tSubPaths = [tSubPaths collectUsingFunction:appendToEach context:(void*)each];
                injected =[tSubPaths injectUsingFunction:NPInjectNestedDirectories into:injected context:&tNestedVerify];
            }

        }else if(!tVerify || [[[NPPluginReader pluginReader] allowedExtensions] containsObject: NSHFSTypeOfFile(each)] ){
            [injected addObject:each];
        }
    } else if(!tVerify || [[[NPPluginReader pluginReader] allowedExtensions] containsObject: [each pathExtension]] ){
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