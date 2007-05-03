//
//  MenuNameParserTest.m
//  CocoaScriptMenu
//
//  Created by James Tuley on 10/1/05.
//  Copyright 2005 James Tuley. All rights reserved.
//

#import "MenuNameParserTest.h"
#import "CSMMenuNameParser.h"

@implementation MenuNameParserTest

-(void)testFunctionKeyParse{
    id menu = [[CSMMenuNameParser alloc] initWithPath:@"/test/something{f12}.scpt"];
    STAssertEquals([menu keyEquivalentModifiers],(unsigned int)0,@"There should be no modifier",nil);
    
    
    NSString* tF12Key =[NSString stringWithFormat:@"%C",NSF12FunctionKey,nil];
    STAssertEqualObjects([menu keyEquivalent],tF12Key,@"It should read represent the F12 key ",nil);

    STAssertEqualObjects(@"something",[menu name],@"Name didn't parse",nil);
    
    [menu release];
}

-(void)testModifierKeyParse{
    id menu = [[CSMMenuNameParser alloc] initWithPath:@"/test/01something{*$G}"];
    
    
    unsigned int tMod =NSCommandKeyMask | NSShiftKeyMask;
    STAssertEquals([menu keyEquivalentModifiers],tMod,@"",nil);
    
    STAssertEqualObjects([menu keyEquivalent],@"g",@"It should read as the g key ",nil);
    
    STAssertEqualObjects(@"something",[menu name],@"Name didn't parse",nil);
    [menu release];
}

-(void)testInvalid{
    id menu = [[CSMMenuNameParser alloc] initWithPath:@"/test/01some{thing{*$G}"];
    
    STAssertEquals([menu keyEquivalentModifiers],(unsigned int)0,@"There should be no modifier",nil);
    
    STAssertEqualObjects([menu keyEquivalent],@"",@"should be no key equivalent",nil);
    
    STAssertEqualObjects(@"some{thing{*$G}",[menu name],@"Name didn't parse",nil);
    [menu release];
}

@end
