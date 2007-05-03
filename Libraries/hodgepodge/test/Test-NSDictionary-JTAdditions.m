//
//  Test-NSDictionary-JTAdditions.m
//  IndyKit
//
//  Created by James Tuley on Fri Jun 18 2004.
//  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
//

#import "Test-NSDictionary-JTAdditions.h"



@implementation Test_NSDictionary_JTAdditions
-(void)setUp{
    testDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"-5",@"k1", @"1",@"k2",@"2",@"k3",@"3",@"k4",nil];    
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
    id tempDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:-5],@"k1", [NSNumber numberWithInt:1],@"k2",[NSNumber numberWithInt:2],@"k3",[NSNumber numberWithInt:3],@"k4",nil];
    id tempDict2 = [testDict collectUsingFunction:convertToNumbers context:NULL];
    STAssertEqualObjects(tempDict,tempDict2,[NSString stringWithFormat:@"test Array %@",tempDict2,nil]);
}


-(void)testSelect{
    id tempDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"-5",@"k1",nil];;
    id tempDict2 = [testDict selectUsingFunction:selectNegativeNumbers context:NULL];
    STAssertEqualObjects(tempDict,tempDict2,[NSString stringWithFormat:@"test dict %@",tempDict2,nil]);
}

-(void)testDetect{
    id tempObj = @"-5";
    id tempObj2 = [testDict detectUsingFunction:selectNegativeNumbers context:NULL];
    STAssertEqualObjects(tempObj,tempObj2,[NSString stringWithFormat:@"test %@",tempObj2,nil]);
}

-(void)testReject{
    id tempDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"k2",@"2",@"k3",@"3",@"k4",nil];
    id tempDict2 = [testDict rejectUsingFunction:selectNegativeNumbers context:NULL];
    STAssertEqualObjects(tempDict,tempDict2,[NSString stringWithFormat:@"test dict %@",tempDict2,nil]);
}

-(void)testInject{
    id tempObj = [NSNumber numberWithInt:1];
    id tempObj2 = [testDict injectUsingFunction:sumElements into:@"" context:NULL];
    STAssertEqualObjects(tempObj,tempObj2,[NSString stringWithFormat:@"test %@",tempObj2,nil]);
}

@end
