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
* The Original Code is EncryptOC.
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
//  Test-JTCryptKey.m
//  IndyKit
//
//  Created by James Tuley on Sat Jul 31 2004.
//  Copyright (c) 2004 James Tuley. All rights reserved.
//

#import "Test-JTCryptKey.h"

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
