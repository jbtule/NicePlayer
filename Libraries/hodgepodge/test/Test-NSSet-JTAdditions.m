//
//  Test-NSSet-JTAdditions.m
//  IndyKit
//
//  Created by James Tuley on Fri Jun 18 2004.
//  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
//

#import "Test-NSSet-JTAdditions.h"




@implementation Test_NSSet_JTAdditions
-(void)setUp{
    testSet = [[NSSet alloc] initWithObjects:@"-5",@"1",@"2",@"3",nil];    
}

-(void)testIsEmpty{
    id tempSet = [NSSet set];
    STAssertTrue([tempSet isEmpty],[NSString stringWithFormat:@"test Set %@",tempSet,nil]);
    STAssertFalse([testSet isEmpty], [NSString stringWithFormat:@"test Set %@",testSet,nil]);
    
}

-(void)testNotEmpty{
    id tempSet = [NSSet set];
    STAssertTrue([testSet notEmpty], [NSString stringWithFormat:@"test Set %@",testSet,nil]);
    STAssertFalse([tempSet notEmpty], [NSString stringWithFormat:@"test Set %@",tempSet,nil]);
    
}

-(void)testCollect{
    id tempSet = [NSSet setWithObjects:[NSNumber numberWithInt:-5],[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],nil];
    id tempSet2 = [testSet collectUsingFunction:convertToNumbers context:NULL];
    STAssertEqualObjects(tempSet,tempSet2,[NSString stringWithFormat:@"test Set %@",tempSet2,nil]);
}


-(void)testSelect{
    id tempSet = [NSSet setWithObjects:@"-5",nil];
    id tempSet2 = [testSet selectUsingFunction:selectNegativeNumbers context:NULL];
    STAssertEqualObjects(tempSet,tempSet2,[NSString stringWithFormat:@"test Set %@",tempSet2,nil]);
}

-(void)testDetect{
    id tempObj = @"-5";
    id tempObj2 = [testSet detectUsingFunction:selectNegativeNumbers context:NULL];
    STAssertEqualObjects(tempObj,tempObj2,[NSString stringWithFormat:@"test %@",tempObj2,nil]);
}

-(void)testReject{
    id tempSet = [NSSet setWithObjects:@"1",@"2",@"3",nil];
    id tempSet2 = [testSet rejectUsingFunction:selectNegativeNumbers context:NULL];
    STAssertEqualObjects(tempSet,tempSet2,[NSString stringWithFormat:@"test Set %@",tempSet2,nil]);
}

-(void)testInject{
    id tempObj = [NSNumber numberWithInt:1];
    id tempObj2 = [testSet injectUsingFunction:sumElements into:@"" context:NULL];
    STAssertEqualObjects(tempObj,tempObj2,[NSString stringWithFormat:@"test %@",tempObj2,nil]);
}

@end
