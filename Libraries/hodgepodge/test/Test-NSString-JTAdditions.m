//
//  Test-NSString-JTAdditions.m
//  IndyKit
//
//  Created by James Tuley on Wed Jun 16 2004.
//  Copyright (c) 2004 James Tuley. All rights reserved.
//

#import "Test-NSString-JTAdditions.h"

@implementation Test_NSString_JTAdditions


-(void)testEditDistance{
    
    STAssertEquals([@"Sheep" editDistanceFrom:@"sleeping"],4,nil);
    STAssertEquals([@"sheep" editDistanceFrom:@"Slop"],3 ,nil);

}

-(void)testFourChar{
    STAssertTrue((FourCharCode)JTFourCharCodeForNSString(@"m44f")==(FourCharCode)'m44f',nil);    
    STAssertTrue((FourCharCode)JTFourCharCodeForNSString(@"'m44f'")==(FourCharCode)'m44f',nil);    
    STAssertFalse((FourCharCode)JTFourCharCodeForNSString(@"moof")==(FourCharCode)'m44f',nil);    
}

@end
