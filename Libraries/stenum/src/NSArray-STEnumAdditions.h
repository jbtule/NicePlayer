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
//  NSArray-STEnumAdditions.h
//  STEnum
//
//  Created by James Tuley on Tue Jun 15 2004.
//  Copyright (c) 2004-2005 James Tuley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Defines.h"

/*!
@header
 @discussion Enumeration methods for NSArray
 @copyright James Tuley
 */


/*!
@defined NSArrayPair
 @abstract   Shortcut to to put a pair of objects into an NSArray
 @param      a first object
 @param      b second object
 @result     returns an NSArray with the two objects in that order;
 */

#define NSArrayPair(a,b) [NSArray arrayWithObjects:a,b,nil]

/*!
@defined NSArrayTrio
 @abstract   Shortcut to to put a trio of objects into an NSArray
 @param      a first object
 @param      b second object
 @param      c last object
 
 @result     returns an NSArray with the three objects in that order;
 */

#define NSArrayTrio(a,b,c) [NSArray arrayWithObjects:a,b,c,nil]

/*!
@category NSArray(STNonSharedCollectionAdditions)
 @abstract    Methods that are only added to NSArrays
 @discussion  These methods should work on NSArrays and their subclasses.
 */

@interface NSArray (STNonSharedCollectionAdditions)
/*!
    @method arrayWithNumbersForRange:    
    @abstract Complete Creation Method:  Array with NSNumbers across aRange (index,length) by an interval of 1.0
    @discussion You may use this to use for things you might use a for loop
     <pre>
     @textblock
     NSArray* bigArray;
      ...//initalized somewhere
     NSArray* ZeroThroughNineArray =[NSArray arrayWithNumbersForRange:NSMakeRange(0,10)];
     id collectForIndex(id each, void* context){
         return [bigArray objectForIndex:[each intValue]];
     }
     NSArray* firstTenOfBigArray = [ZeroThroughNineArray collectUsingFunction:collectForIndex
                                                                    context:nil];
 
     @/textblock
     </pre>
*/

+(id)arrayWithNumbersForRange:(NSRange)aRange;

/*!
@method     arrayWithNumbersForRange:overInterval:
 @abstract  Complete Creation Method: Array initalized with NSNumbers across aRange (index,length) by an interval of anInterval
 */

+(id)arrayWithNumbersForRange:(NSRange)aRange overInterval:(double)anInterval;

/*!
@method     initWithNumbersForRange:
 @abstract  Array initalized with NSNumbers across aRange (index,length) by an interval of 1.0
 */
-(id)initWithNumbersForRange:(NSRange)aRange;
/*!
@method     initWithNumbersForRange:overInterval:
 @abstract   Array initalized with NSNumbers across aRange (index,length) by an interval of anInterval
 */
-(id)initWithNumbersForRange:(NSRange)aRange overInterval:(double)anInterval;

/*!
@method     firstObject
 @abstract  see @link NSArrayPair NSArrayPair@/link
 @result first object in the array
 */
-(id)firstObject;

/*!
@method     secondObject
 @abstract  see @link NSArrayPair NSArrayPair@/link
 @result second object in the array
 */
-(id)secondObject;

@end

@interface NSArray (STSharedCollectionAdditions)

#include <STEnum/STSharedEnum.h>

@end
