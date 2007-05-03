//
//  Test-NSArray-JTAdditions.m
//  NicePlayer
//
//  Created by James Tuley on Tue Jun 15 2004.
//  Copyright (c) 2004 James Tuley. All rights reserved.
//

#import "Test-NSArray-JTAdditions.h"




@implementation Test_NSArray_JTAdditions

-(void)setUp{
        testArray = [[NSArray alloc] initWithObjects:@"-5",@"1",@"2",@"3",nil];    
    
    convertToNumbers = UnaryBlock(return [NSNumber numberWithInt:[each intValue]]);
    selectNegative = TestBlock(return [each intValue] < 0);
    concatEach = BinaryBlock(return [eachFirst stringByAppendingString:eachSecond]);
    sumEach =BinaryBlock(return [NSNumber numberWithInt:[eachFirst intValue] + [eachSecond intValue]]);

}


-(void)testCollect{
    id tempArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:-5],[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],nil];
    id tempArray2 = [testArray collect:convertToNumbers];
    STAssertEqualObjects(tempArray,tempArray2,[NSString stringWithFormat:@"test Array %@",tempArray2,nil]);
}


-(void)testSelect{
    id tempArray = [NSArray arrayWithObjects:@"-5",nil];
    id tempArray2 = [testArray select:selectNegative];
    STAssertEqualObjects(tempArray,tempArray2,[NSString stringWithFormat:@"test Array %@",tempArray2,nil]);
}

-(void)testDetect{
    id tempObj = @"-5";
        id tempObj2 = [testArray detect:selectNegative];
        STAssertEqualObjects(tempObj,tempObj2,[NSString stringWithFormat:@"test %@",tempObj2,nil]);
}

-(void)testReject{
    id tempArray = [NSArray arrayWithObjects:@"1",@"2",@"3",nil];
    id tempArray2 = [testArray reject:selectNegative];
    STAssertEqualObjects(tempArray,tempArray2,[NSString stringWithFormat:@"test Array %@",tempArray2,nil]);
}

-(void)testInject{
    id tempObj = @"-5123";
    id tempObj2 = [testArray inject:@"" into:concatEach];
    STAssertEqualObjects(tempObj,tempObj2,[NSString stringWithFormat:@"test %@",tempObj2,nil]);
}
@end
