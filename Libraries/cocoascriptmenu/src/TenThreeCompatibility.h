//
//  TenThreeCompatibility.h
//  CocoaScriptMenu
//
//  Created by James Tuley on 10/10/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


//function to check for mising weak constants
extern id TTCConstantIfAvailible(void** aConst, id aKnownValue);


//variables to make up for missing ones in 10.3
extern NSSearchPathDirectory TTCApplicationSupportDirectory;


//Use Instead of NSSearchPathForDirectoriesInDomains
extern NSArray* TTCSearchPathForDirectoriesInDomains (NSSearchPathDirectory directory, NSSearchPathDomainMask domainMask, BOOL expandTilde);

extern BOOL TTCRunningLessThan10_4O();


//returns the most basic type in 10.3 enviornments as conforms to won't work if they aren't declared, not really useful out side of CocoaScriptMenu
//will need to edit if you add other specializ types to CocoaScriptMenu and you want them to function under 10.3
extern CFStringRef TTCTypeCreatePreferredIdentifierForTag(CFStringRef   inTagClass,CFStringRef   inTag, CFStringRef   inConformingToUTI);

