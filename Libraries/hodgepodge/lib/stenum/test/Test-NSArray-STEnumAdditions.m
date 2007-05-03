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
//  Test-NSArray-STEnumAdditions.m
//  STEnum
//
//  Created by James Tuley on Tue Jun 15 2004.
//  Copyright (c) 2004-2005 James Tuley. All rights reserved.
//

#import "Test-NSArray-STEnumAdditions.h"

id Nested_Test_ST_convertToNumbers(id obj, void * context){
    return [NSNumber numberWithInt:[obj intValue]];
}


@implementation Test_NSArray_STEnumAdditions

-(void)setUp{
        testArray = [[NSArray alloc] initWithObjects:@"-5",@"1",@"2",@"-3",nil];    
}




-(void)testCollect{
    id tempArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:-5],[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:-3],nil];
    id tempArray2 = [testArray collectUsingFunction:Test_ST_convertToNumbers context:nil];
    STAssertEqualObjects(tempArray,tempArray2,[NSString stringWithFormat:@"test Array %@",tempArray2,nil]);
}


-(void)testCollect2{
    id tempArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:-5],[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:-3],nil];
    
    
    id tempArray2 = [testArray collectUsingFunction:Nested_Test_ST_convertToNumbers context:nil];
    
    

    STAssertEqualObjects(tempArray,tempArray2,[NSString stringWithFormat:@"test Array %@",tempArray2,nil]);
}

-(void)testSelect{
    id tempArray = [NSArray arrayWithObjects:@"-5",@"-3",nil];
    id tempArray2 = [testArray selectUsingFunction:Test_ST_selectNegativeNumbers context:nil];
    STAssertEqualObjects(tempArray,tempArray2,[NSString stringWithFormat:@"test Array %@",tempArray2,nil]);
}

-(void)testDetect{
    id tempObj = @"-5";
        id tempObj2 = [testArray detectUsingFunction:Test_ST_selectNegativeNumbers context:nil];
        STAssertEqualObjects(tempObj,tempObj2,[NSString stringWithFormat:@"test %@",tempObj2,nil]);
}

-(void)testReject{
    id tempArray = [NSArray arrayWithObjects:@"1",@"2",nil];
    id tempArray2 = [testArray rejectUsingFunction:Test_ST_selectNegativeNumbers context:nil];
    STAssertEqualObjects(tempArray,tempArray2,[NSString stringWithFormat:@"test Array %@",tempArray2,nil]);
}

-(void)testInject{
    id tempObj = @"-512-3";
    id tempObj2 = [testArray injectUsingFunction:Test_ST_concatElements into:@"" context:nil];
    STAssertEqualObjects(tempObj,tempObj2,[NSString stringWithFormat:@"test %@",tempObj2,nil]);
}
@end
