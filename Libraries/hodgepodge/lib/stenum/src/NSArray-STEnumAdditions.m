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
* The Original Code is STEnum.
*
* The Initial Developer of the Original Code is
* James Tuley.
* Portions created by the Initial Developer are Copyright (C) 2004-2005
* the Initial Developer. All Rights Reserved.
*
* Contributor(s):
*           James Tuley <jbtule@mac.com> (Original Author)
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

//
//  NSArray-STEnumAdditions.m
//  STEnum
//
//  Created by James Tuley on Tue Jun 15 2004.
//  Copyright (c) 2004 James Tuley. All rights reserved.
//

#import "NSArray-STEnumAdditions.h"

@implementation  NSArray (STNonSharedCollectionAdditions)

+(id)arrayWithNumbersForRange:(NSRange)aRange{
    return [[[self alloc] initWithNumbersForRange:aRange] autorelease];
}
+(id)arrayWithNumbersForRange:(NSRange)aRange overInterval:(double)anInterval{
    return [[[self alloc] initWithNumbersForRange:aRange overInterval:anInterval] autorelease];
}

-(id)initWithNumbersForRange:(NSRange)aRange{
    return [self initWithNumbersForRange:aRange overInterval:1.0];
}
-(id)initWithNumbersForRange:(NSRange)aRange overInterval:(double)anInterval{
    double i;
    NSMutableArray* tempArray = [NSMutableArray array];
    for(i = aRange.location; i < aRange.location+aRange.length; i=i+anInterval)
        [tempArray addObject:[NSNumber numberWithDouble:i]];
    return [self initWithArray:tempArray];
}

-(id)firstObject{
    if([self count] > 0)
        return [self objectAtIndex:0];
    else
        return nil;
}

-(id)secondObject{
      if([self count] > 1)
          return [self objectAtIndex:1];
      else
          return nil;
}

@end
@interface  NSArray(STPrivateAdditions)
-(id)_STEmptyMutableCollection;
-(id)_STObjectForObject:(id)anObject;
-(void)_STAdd:(id)anObject toCollection:(id)aCollection originalObject:anOriginalObject;
-(id)_STReturnMeFromCollection:(id)aCollection;
-(NSEnumerator*)_STEnumerator;
@end
@implementation  NSArray(STPrivateAdditions)


-(NSEnumerator*)_STEnumerator{
    return [self objectEnumerator];
}


-(id)_STEmptyMutableCollection{
    return [NSMutableArray arrayWithCapacity:[self count]];
}

-(id)_STObjectForObject:(id)anObject{
    return anObject;
}

-(void)_STAdd:(id)anObject toCollection:(id)aCollection originalObject:anOriginalObject{
    [aCollection addObject:anObject];
}

-(id)_STReturnMeFromCollection:(id)aCollection{
    return [[self classForCoder] arrayWithArray: aCollection];
}

@end
@implementation  NSArray(STSharedCollectionAdditions)

#include "STSharedEnum.m"

@end
