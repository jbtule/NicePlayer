//
//  TenThreeCompatibility.m
//  CocoaScriptMenu
//
//  Created by James Tuley on 10/10/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "TenThreeCompatibility.h"

NSSearchPathDirectory TTCApplicationSupportDirectory = NSApplicationSupportDirectory;


id TTCConstantIfAvailible(void** aConst, id aKnownValue){
    if(aConst!=NULL){
        return *aConst;
    }else{
        return aKnownValue;
    }
}

BOOL TTCRunningLessThan10_4O(){
    long vers;
    Gestalt( gestaltSystemVersion, &vers);
    return (vers < 0x00001040);
}

NSArray* TTCSearchPathForDirectoriesInDomains (NSSearchPathDirectory directory, NSSearchPathDomainMask domainMask, BOOL expandTilde){
    NSString* tSuffix = nil;
    NSSearchPathDirectory tDirectory = directory;
    
    if(tDirectory ==TTCApplicationSupportDirectory && TTCRunningLessThan10_4O() ){
        tDirectory = NSLibraryDirectory;
        tSuffix = @"Application Support";
    }

    NSArray* tArray =NSSearchPathForDirectoriesInDomains (tDirectory,  domainMask, expandTilde);
    
    //I should just make STEnum a requirement and make this a collect
    if(tSuffix !=nil){
        NSEnumerator* tEnumerator = [tArray objectEnumerator];
        NSString* tBasePath;
        NSMutableArray *tNewArray =[NSMutableArray array];
        while(tBasePath = [tEnumerator nextObject]){
            [tNewArray addObject:[tBasePath stringByAppendingPathComponent:tSuffix]];
        }
        tArray =[[tNewArray copy] autorelease]; 
    }
    
    return tArray;
}

//returns the most basic type in 10.3 enviornments as conforms to won't work if they aren't declared, not really useful out side of CocoaScriptMenu
//will need to edit if you add other specializ types to CocoaScriptMenu and you want them to function under 10.3
extern CFStringRef TTCTypeCreatePreferredIdentifierForTag(CFStringRef   inTagClass,CFStringRef   inTag, CFStringRef   inConformingToUTI){
    if (TTCRunningLessThan10_4O()){
        NSArray* tShellFileIdents = [NSArray arrayWithObjects:@"sh",@"command",@"csh",@"pl",@"pm",@"py",@"rb",nil];
        NSArray* tAppleScriptFileIdents = [NSArray arrayWithObjects:@"applescript",@"scpt",@"osas",nil];
        NSArray* tAppFileIdents = [NSArray arrayWithObjects:@"app",@"APPL",@"APPC",@"APPD",@"APPE",@"appe",@"CDEV",@"cdev",@"dfil",nil];
        
        if([tShellFileIdents containsObject:(NSString*)inTag]){
            return(CFStringRef) @"public.shell-script";
        }else  if([tAppleScriptFileIdents containsObject:(NSString*)inTag]){
            return (CFStringRef) @"com.apple.applescript.script";
        }else  if([tAppFileIdents containsObject:(NSString*)inTag]){
            return (CFStringRef) @"com.apple.application";
        }
    }
    return UTTypeCreatePreferredIdentifierForTag(inTagClass,inTag,inConformingToUTI);
}

