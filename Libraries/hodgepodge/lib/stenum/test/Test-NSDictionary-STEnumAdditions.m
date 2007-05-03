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
//  Test-NSDictionary-STEnumAdditions.m
//  STEnum
//
//  Created by James Tuley on Fri Jun 18 2004.
//  Copyright (c) 2004-2005 James Tuley. All rights reserved.
//

#import "Test-NSDictionary-STEnumAdditions.h"



@implementation Test_NSDictionary_STEnumAdditions
-(void)setUp{
    testDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"-5",@"k1", @"1",@"k2",@"2",@"k3",@"-3",@"k4",nil];    
}


-(void)testIsEmpty{
    id tempDict = [NSDictionary dictionary];
    STAssertTrue([tempDict isEmpty],[NSString stringWithFormat:@"test Array %@",tempDict,nil]);
    STAssertFalse([testDict isEmpty], [NSString stringWithFormat:@"test Array %@",testDict,nil]);
    
}

-(void)testNotEmpty{
    id tempDict = [NSDictionary dictionary];
    STAssertTrue([testDict notEmpty], [NSString stringWithFormat:@"test Array %@",testDict,nil]);
    STAssertFalse([tempDict notEmpty], [NSString stringWithFormat:@"test Array %@",tempDict,nil]);
    
}

-(void)testCollect{
    id tempDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:-5],@"k1", [NSNumber numberWithInt:1],@"k2",[NSNumber numberWithInt:2],@"k3",[NSNumber numberWithInt:-3],@"k4",nil];
    id tempDict2 = [testDict collectUsingFunction:Test_ST_convertToNumbers context:NULL];
    STAssertEqualObjects(tempDict,tempDict2,[NSString stringWithFormat:@"test Array %@",tempDict2,nil]);
}


-(void)testSelect{
    id tempDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"-5",@"k1",@"-3",@"k4",nil];;
    id tempDict2 = [testDict selectUsingFunction:Test_ST_selectNegativeNumbers context:NULL];
    STAssertEqualObjects(tempDict,tempDict2,[NSString stringWithFormat:@"test dict %@",tempDict2,nil]);
}

-(void)testDetect{
    id tempObj = @"-5";
    id tempObj2 = [testDict detectUsingFunction:Test_ST_selectNegativeNumbers context:NULL];
    STAssertEqualObjects(tempObj,tempObj2,[NSString stringWithFormat:@"test %@",tempObj2,nil]);
}

-(void)testReject{
    id tempDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"k2",@"2",@"k3",nil];
    id tempDict2 = [testDict rejectUsingFunction:Test_ST_selectNegativeNumbers context:NULL];
    STAssertEqualObjects(tempDict,tempDict2,[NSString stringWithFormat:@"test dict %@",tempDict2,nil]);
}

-(void)testInject{
    id tempObj = [NSNumber numberWithInt:-5];
    id tempObj2 = [testDict injectUsingFunction:Test_ST_sumElements into:@"" context:NULL];
    STAssertEqualObjects(tempObj,tempObj2,[NSString stringWithFormat:@"test %@",tempObj2,nil]);
}

@end
