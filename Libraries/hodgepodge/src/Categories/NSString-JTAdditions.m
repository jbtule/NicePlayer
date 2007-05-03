/*
 iEatBrainz
 Copyright (c) 2004, James Tuley
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 
 * Neither the name of James Tuley nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */
//
//  NSString-JTAdditions.m
//  iEatBrainz
//
//  Created by James Tuley on Thu Mar 18 2004.
//  Copyright (c) 2004 James Tuley. All rights reserved.
//

#import "NSString-JTAdditions.h"
#import <CoreServices/CoreServices.h>
#import <CoreFoundation/CoreFoundation.h>

FourCharCode JTFourCharCodeForNSString(NSString* aString){
    if ([aString length]==4){
        return (FourCharCode) NSSwapBigIntToHost(([aString characterAtIndex:0]<<24) | ([aString characterAtIndex:1]<<16) | ([aString characterAtIndex:2]<<8) | ([aString characterAtIndex:3]));
    }else if ([aString length]==6){
        return (FourCharCode) NSSwapBigIntToHost(([aString characterAtIndex:1]<<24) | ([aString characterAtIndex:2]<<16) | ([aString characterAtIndex:3]<<8) | ([aString characterAtIndex:4]));
    }{
        return 0;   
    }
}

@implementation  NSString (JTAdditions)

-(BOOL)isEmpty{
    return ([self isEqualToString:@""]);
}


//stringByResolvingAliasInPath
//Will resolve alias in a path
-(NSString*)stringByResolvingAliasInPath{
    NSString *path = [[self stringByStandardizingPath] stringByResolvingSymlinksInPath];    // Assume this exists.
    NSString *resolvedPath = nil;
    NSURL* url;
    NSEnumerator *enumerator =[[path pathComponents] objectEnumerator];
    NSString* pathComponent = nil;
    NSString* pathBase = @"";
    while(pathComponent = [enumerator nextObject]){
        pathBase =[pathBase stringByAppendingPathComponent:pathComponent];
        url = [[NSURL fileURLWithPath:pathBase]retain];
        if (url != NULL)
        {
            FSRef fsRef;
            if (CFURLGetFSRef((CFURLRef)url, &fsRef))
            {
                Boolean targetIsFolder, wasAliased;
                if (FSResolveAliasFile (&fsRef, true /*resolveAliasChains*/, 
                                        &targetIsFolder, &wasAliased) == noErr && wasAliased)
                {
                    CFURLRef resolvedUrl = CFURLCreateFromFSRef(NULL, &fsRef);
                    if (resolvedUrl != NULL)
                    {
                        pathBase = (NSString*)
                        CFURLCopyFileSystemPath(resolvedUrl,
                                                kCFURLPOSIXPathStyle);
                        CFRelease(resolvedUrl);
                    }
                }
            }
            [url release];
        }
    }
    resolvedPath = pathBase;
    
    return resolvedPath;
}

//-(NSString*)stringByResolvingAliasInPath2{
//    NSString* tempString = [self stringByStandardizingPath];
//    NSURL* tempURL = [NSURL fileURLWithPath:tempString];
//    FSRef tempRef;
//    Boolean isAlias, isDir;
//    BOOL success = YES;
//    NSEnumerator *enumerator =[[tempString pathComponents] objectEnumerator];
//    id object = [enumerator nextObject];
//    NSMutableString* pathbuild = [NSMutableString string];
//    while (object = [enumerator nextObject]) {
//        [pathbuild appendString:[NSString stringWithFormat:@"/%@", object,nil]];
//        tempURL = [NSURL fileURLWithPath:pathbuild];        
//        success =CFURLGetFSRef((CFURLRef)tempURL, &tempRef);        
//        if (success){
//            success =(noErr == FSIsAliasFile(&tempRef,&isAlias,&isDir));
//            if(success && isAlias){
//                success =(noErr == FSResolveAliasFile (&tempRef,YES,&isDir,&isAlias));
//                if (success){
//                    tempURL=(NSURL*) CFURLCreateFromFSRef(kCFAllocatorDefault,&tempRef);
//                    [tempURL autorelease];
//                
//                    pathbuild = [NSMutableString stringWithString:[tempURL path]];
//                }
//            }
//        }
//        
//    }
//    
//    return pathbuild;
//    
//}


//editDistanceFromString
//implemented from pseudocode from the Science Daily Enclyclopedia
//http://www.sciencedaily.com/encyclopedia/levenshtein_distance#The%20Algorithm
-(int)editDistanceFrom:(NSString*)aString{
    int stringlengthA = [self length];
    int stringlengthB  =[aString length];
    NSMutableArray* distance =[NSMutableArray arrayWithCapacity:stringlengthA+1];
    int i, j;
    
    for(i=0; i <= stringlengthA; i++){
        [distance addObject:[NSMutableArray arrayWithCapacity:stringlengthB+1]];
        
        [[distance objectAtIndex:i] addObject:[NSNumber numberWithInt:i]];
        for(j=1; j <= stringlengthB; j++)
            [[distance objectAtIndex:i] addObject:[NSNumber numberWithInt:-1]];

    }
    
    for(j=0; j <= stringlengthB; j++){
        [[distance objectAtIndex:0] replaceObjectAtIndex:j withObject:[NSNumber numberWithInt:j]];
    }
    

    for(i=1; i <= stringlengthA; i++){
        for(j=1; j <= stringlengthB; j++){
            int cost;
            if (NSOrderedSame ==[[self substringWithRange:NSMakeRange(i-1,1)] caseInsensitiveCompare:[aString substringWithRange:NSMakeRange(j-1,1)]])
                cost = 0;
            else
                cost = 1;
            
            [[distance objectAtIndex:i] replaceObjectAtIndex:j withObject:[NSNumber numberWithInt:(int)fmin( fmin([[[distance objectAtIndex:i-1]objectAtIndex:j] intValue]+1,[[[distance objectAtIndex:i]objectAtIndex:j-1] intValue]+1),[[[distance objectAtIndex:i-1]objectAtIndex:j-1] intValue]+cost)]];

        }
            
    }
    return [[[distance objectAtIndex:stringlengthA] objectAtIndex:stringlengthB] intValue];
}


@end
