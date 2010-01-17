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

/*
 *  Defines.h
 *  STEnum
 *
 *  Created by James Tuley on 4/2/05.
 *  Copyright (c) 2005 James Tuley. All rights reserved.
 *
 */

/*!
    @header
    @abstract Defines,TypeDefs for use with STEnum methods
    @discussion These typedefs are all function pointers types that are used by the different enumartion methods. You can make static or nested functions that are compatable with these types. To learn about nested functions see this <a href="http://gcc.gnu.org/onlinedocs/gcc/Nested-Functions.html">reference at the gcc website</a>.
    @copyright James Tuley
 */

/*!
@defined STDoBreak
@abstract   Used to immediately end doUsingFunction:context: loop
@param      aBreakBOOLPtr the DoFunctions bool ptr argument
 @discussion Example Declaration:
 <pre>
 @textblock
 void aDoFunction(id each, void* aContext,BOOL* aBreak){
     STDoBreak(aBreak);
 }
 @/textblock
 </pre>
*/

#define STDoBreak(aBreakBOOLPtr) (*aBreakBOOLPtr = YES); return

/*!
@typedef STDoFunction
 @abstract   Function pointer for doUsingFunction:context:
 @discussion Example Declaration:
 <pre>
 @textblock
 void aDoFunction(id each, void* aContext,BOOL* aBreak){
     
 }
 @/textblock
 </pre>
 @param each id (any object) that you are enumerating through
 @param context void* pointer that you can use to pass in extra variables
 @param abreak BOOL* pointer when assigned to true, ends the while loop;
 @result returns void
 */

typedef void (*STDoFunction)(id, void *,BOOL *);

/*!
@typedef STCollectFunction
 @abstract   Function pointer for collectUsingFunction:context:
 @discussion Example Declaration:
 <pre>
 @textblock
 id aCollectFunction(id each, void* aContext){
     
 }
 @/textblock
 </pre>
 @param each id (any object) that you are enumerating through
 @param context void* pointer that you can use to pass in extra variables
 @result returns the object that you are replacing each with
 */
typedef id (*STCollectFunction)(id, void *); 
/*!
@typedef STSelectFunction
 @abstract   Function pointer for selectUsingFunction:context:,detectUsingFunction:context:,rejectUsingFunction:context:
 @discussion Example Declaration:
 <pre>
 @textblock
 BOOL aSelectFunction(id each, void* aContext){
     
 }
 @/textblock
 </pre>
 @param each id (any object) that you are enumerating through
 @param context void* pointer that you can use to pass in extra variables
 @result returns true if selected criteria is met
 */
typedef BOOL (*STSelectFunction)(id, void *);
/*!
@typedef STInjectFunction
 @abstract   Function pointer for injectUsingFunction:into:context: or injectObject:intoFunction:context:
 @discussion Example Declaration:
 <pre>
 @textblock
 void anInjectFunction(id each,id anObject, void* aContext){
     
 }
 @/textblock
 </pre>
 @param each id (any object) that you are enumerating through
 @param anObject id (any object) that you are injecting
 @param context void* pointer that you can use to pass in extra variables
 @result returns object to be used in next interation's anObject
 */
typedef id (*STInjectFunction)(id, id, void *);