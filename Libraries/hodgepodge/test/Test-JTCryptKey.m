//
//  Test-JTCryptKey.m
//  IndyKit
//
//  Created by James Tuley on Sat Jul 31 2004.
//  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
//

#import "Test-JTCryptKey.h"
#import <IndyKit/IndyFoundation.h>

@implementation Test_JTCryptKey
-(void)setUp{
    cryptPhrase = [@"kill the wabbit" retain];
    rsakeypair = [[JTCryptKey generateRSAKeyPairWithBits:512] retain];
    dsakeypair= [[JTCryptKey generateDSAKeyPairWithBits:512] retain];
    mySecretData = [[@"My Secret Message, Muhahahaha" dataUsingEncoding:NSASCIIStringEncoding] retain];
    notMySecretData = [[@"My Secret Message, Mubahahaha" dataUsingEncoding:NSASCIIStringEncoding] retain];

}

-(void)testRSACrypt{
    id cryptData =[[rsakeypair objectForKey:JTPublicKey] encryptData:mySecretData];
    
    STAssertFalse([cryptData isEqualTo:mySecretData],nil);    

    id decryptData = [[rsakeypair objectForKey:JTPrivateKey] decryptData:cryptData];
    
    STAssertTrue([decryptData isEqualTo:mySecretData],nil);    
}

-(void)testRSASign{
    id sigData =[[rsakeypair objectForKey:JTPrivateKey] signData:mySecretData];
    
    STAssertTrue([[rsakeypair objectForKey:JTPublicKey] verifyData:mySecretData withSignature:sigData],nil);    
    STAssertFalse([[rsakeypair objectForKey:JTPublicKey] verifyData:notMySecretData withSignature:sigData],nil);   
}

-(void)testDSASign{
    id sigData =[[dsakeypair objectForKey:JTPrivateKey] signData:mySecretData];
    STAssertTrue([[dsakeypair objectForKey:JTPublicKey] verifyData:mySecretData withSignature:sigData],nil);   
    STAssertFalse([[dsakeypair objectForKey:JTPublicKey] verifyData:notMySecretData withSignature:sigData],nil);    

}

-(void)testAESCrypt{
    id cryptData =[[JTCryptKey generateAES128KeyWithPhrase:cryptPhrase] encryptData:mySecretData];
    STAssertFalse([cryptData isEqualTo:mySecretData],nil);    
    id decryptData = [[JTCryptKey generateAES128KeyWithPhrase:cryptPhrase] decryptData:cryptData];
    STAssertTrue([decryptData isEqualTo:mySecretData],nil);    
}

-(void)testDESCrypt{
    id cryptData =[[JTCryptKey generateAES128KeyWithPhrase:cryptPhrase] encryptData:mySecretData];
    STAssertFalse([cryptData isEqualTo:mySecretData],nil);    
    id decryptData = [[JTCryptKey generateAES128KeyWithPhrase:cryptPhrase] decryptData:cryptData];
    STAssertTrue([decryptData isEqualTo:mySecretData],nil);    
}

@end
