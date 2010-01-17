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
//  STSharedEnum.m
//  STEnum
//
//  Created by James Tuley on 4/2/05.
//  Copyright 2005 James Tuley. All rights reserved.
//

//This file is included in all the STEnumAdditions.m,

-(BOOL)isEmpty{
    
    return([self count] ==0);
    
}
-(BOOL)notEmpty{
    return ![self isEmpty];
}

-(void)doUsingFunction:(STDoFunction)actionFunction context:(void *)context{
    NSEnumerator *enumerator = [self _STEnumerator];
    id each;
    BOOL tBreak = NO;
    while ((each = [enumerator nextObject]) && !tBreak) {
        actionFunction(each,context,&tBreak);
    }
}

-(id)collectUsingFunction:(STCollectFunction)collectionFunction context:(void *)context{
    id tempCollection = [self _STEmptyMutableCollection];
    
    NSEnumerator *enumerator = [self _STEnumerator];
    id each;
    while (each = [enumerator nextObject]) {
        [self _STAdd:collectionFunction([self _STObjectForObject:each], context) toCollection:tempCollection originalObject:each];
    }
    return [self _STReturnMeFromCollection:tempCollection];
}

-(id)selectUsingFunction:(STSelectFunction)selectingFunction context:(void *)context{
    id tempCollection = [self _STEmptyMutableCollection];
    
    NSEnumerator *enumerator = [self _STEnumerator];
    id each;
    while (each = [enumerator nextObject])    {
        if(selectingFunction([self _STObjectForObject:each],context))
            [self _STAdd:[self _STObjectForObject:each] toCollection:tempCollection originalObject:each];
    }
    
    return [self _STReturnMeFromCollection:tempCollection];
}


-(id)rejectUsingFunction:(STSelectFunction)rejectingFunction context:(void *)context{
    id tempCollection = [self _STEmptyMutableCollection];
    NSEnumerator *enumerator = [self _STEnumerator];
    id each;
    while (each = [enumerator nextObject]) {
        if(!rejectingFunction([self _STObjectForObject:each],context))
            [self _STAdd:[self _STObjectForObject:each] toCollection:tempCollection originalObject:each];
    }
    
    return [self _STReturnMeFromCollection:tempCollection];
}


-(id)detectUsingFunction:(STSelectFunction)detectingFunction context:(void *)context{
    id returnObject = nil;
    NSEnumerator *enumerator = [self _STEnumerator];
    id each;
    while (each = [enumerator nextObject]) {
        if(detectingFunction([self _STObjectForObject:each],context)){
            returnObject = [self _STObjectForObject:each];
            break;
        }
    }
    return [[returnObject retain] autorelease];
}

- (id)injectUsingFunction:(STInjectFunction)injectingFunction into:(id)anObject context:(void *)context{
    NSEnumerator *enumerator = [self _STEnumerator];
    id each;
    while (each = [enumerator nextObject]) {
        anObject=injectingFunction([self _STObjectForObject:each],anObject,context);
    }
    return anObject;
}

-(id)injectObject:(id)anObject intoFunction:(STInjectFunction)injectingFunction context:(void *)context{
    return [self injectUsingFunction:injectingFunction into:anObject context:context];
}

