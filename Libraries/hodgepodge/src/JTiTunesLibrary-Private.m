//
//  JTiTunesLibrary-Private.m
//  IndyKit
//
//  Created by James Tuley on Fri Jun 18 2004.
//  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
//

#import "JTiTunesLibrary-Private.h"
//#import "NDAlias.h"
#import <STEnum/STEnum.h>
@implementation JTiTunesLibrary(Private)

#pragma mark -
#pragma mark Private

id HDPGarrayOfFilePaths(id each, void* context){
    return [each objectForKey:@"Location"];
}

id HDPGaliasHashedByPath(id each, id obj, void* context){
    // [obj setObject:[NDAlias aliasWithURL:[NSURL URLWithString:each]] forKey:each];
    return obj;
}

-(void)_createAliasCache{

    id tArray = [[_theLibrary objectForKey:@"Tracks"] allValues];

   tArray = [tArray collectUsingFunction:HDPGarrayOfFilePaths context:nil];
    

    
    [_AliasCache release];
    _AliasCache =[tArray injectUsingFunction:HDPGaliasHashedByPath into:[[NSMutableDictionary alloc] init] context:nil];
}

-(BOOL)_loadiTunesImages:(NSArray*)rsrcGroups{
    FSRef tempRef;
    short mainID;
    HFSUniStr255 tempName;
    Handle tempHandle;
    OSErr anError = noErr;
    BOOL tempBool = YES;
    int i,j;
    NSMutableDictionary* newDict= [NSMutableDictionary dictionary];
    id tempObj=[[NSWorkspace sharedWorkspace] fullPathForApplication:@"iTunes.app"];
    if (tempObj ==nil) return NO;
    tempObj=[NSBundle bundleWithPath:tempObj];
    if (tempObj ==nil) return NO;
    tempObj = [tempObj pathForResource:@"iTunes" ofType:@"rsrc"];
    if (tempObj ==nil) return NO;
    tempObj =  [NSURL fileURLWithPath:tempObj];
    if (tempObj ==nil) return NO;
    tempBool= CFURLGetFSRef((CFURLRef)tempObj,&tempRef);
    if (!tempBool) return NO;
    anError=FSGetDataForkName(&tempName);
    if (anError != noErr) return NO;
    anError =FSOpenResourceFile(&tempRef, tempName.length, tempName.unicode, fsRdPerm, &mainID);
    if (anError != noErr) return NO;
    for(i=0;i<[rsrcGroups count];i++){        
        id tempMask, tempBase, tempGroup, tempMain;
        id tempRsrc = [[[rsrcGroups objectAtIndex:i] objectForKey:@"Resources"] objectForKey:@"Mask"];
        tempHandle = GetResource(JTFourCharCodeForNSString([tempRsrc objectForKey:@"Type"]),[[tempRsrc objectForKey:@"ID"] intValue]);
        anError = ResError();
        if (anError != noErr) return NO;
        HLock(tempHandle);
        tempMask=[[[NSImage alloc] initWithData:[NSData dataWithBytes:*tempHandle length:GetHandleSize(tempHandle)]] autorelease];
        HUnlock(tempHandle);
        tempRsrc = [[[rsrcGroups objectAtIndex:i]  objectForKey:@"Resources"] objectForKey:@"Base"];
        
        tempHandle = GetResource(JTFourCharCodeForNSString([tempRsrc objectForKey:@"Type"]),[[tempRsrc objectForKey:@"ID"] intValue]);
        anError = ResError();
        if (anError != noErr) return NO;
        HLock(tempHandle);
        tempBase=[[[NSImage alloc] initWithData:[NSData dataWithBytes:*tempHandle length:GetHandleSize(tempHandle)]] autorelease];
        HUnlock(tempHandle);
        
        tempGroup  = [[[rsrcGroups objectAtIndex:i] objectForKey:@"Images"] allKeys];
        tempMain = [tempBase imageByApplyingMask:tempMask invertMask:NO];
        id tempDiv = [[[rsrcGroups objectAtIndex:i] 
objectForKey:@"Resources"] objectForKey:@"Divisions"];
        for(j=0;j< [tempGroup count];j++){
            id tempItem = [[[rsrcGroups objectAtIndex:i] 
objectForKey:@"Images"]objectForKey:[tempGroup objectAtIndex:j]];
            id tempG=[tempMain
                 imageCroppedWithGridSquareSize:NSMakeSize([[tempDiv objectForKey:@"Width"] intValue],[[tempDiv objectForKey:@"Height"] intValue])
                                 takingSquareAt:NSMakePoint([[tempItem objectForKey:@"Row"]intValue],[[tempItem objectForKey:@"Column"]intValue])];
            
            [newDict setObject:tempG forKey:[tempGroup objectAtIndex:j]];
            
        }
    }
    
    _iTunesImages = [newDict retain];
    
    CloseResFile(mainID);
    return YES;
}




-(void)_databaseChanged{
    NSEnumerator *enumerator = [_observers objectEnumerator];
    id object;
    
    while (object = [enumerator nextObject]) {
        [[object objectAtIndex:0] performSelector:NSSelectorFromString([object objectAtIndex:1]) withObject:self];
    }
    
}

//because applescript won't return duratoin in milliseconds
//am doing this for backwards compatiblity of the hashes
//match should be close enough though
//*an addition
//iTunes also goofs up in some way for daylight savings time
//so instead of correcting this and possibly breaking the program in the future
//we'll just allow an leeway of exactly one hour.
-(BOOL)_JTappleScriptHackHashMatchedBetweenHash:(NSString*)aHash andTrack:(id)aTrack{
    
    BOOL tempBool = YES;
    
    NSArray* tempArray = [aHash componentsSeparatedByString:@"&"];
    
    tempBool = tempBool && [[tempArray objectAtIndex:0] intValue] == [[aTrack objectForKey:@"Size"] intValue];
    
    tempBool = tempBool && [[tempArray objectAtIndex:1] intValue]/1000 == [[aTrack objectForKey:@"Total Time"] intValue];
    
    NSTimeInterval tempInterval = [[NSDate dateWithString:[tempArray objectAtIndex:2]] timeIntervalSinceDate:[aTrack objectForKey:@"Date Added"]];
    
    // NSLog(@"time match? %f",tempInterval);
    
    //  NSLog(@"dates,%@ | %@",[tempArray objectAtIndex:2], [[aTrack objectForKey:@"Date Added"] description]);
    //   NSLog(@"for track %@",aTrack);
    
    tempBool = tempBool && ((tempInterval)==0 || (fabsf(tempInterval/3600.0)==1));
    
    return tempBool;
}


@end
