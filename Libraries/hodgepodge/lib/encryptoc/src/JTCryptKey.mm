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
//  JTCryptKey.m
//  IndyKit
//
//  Created by James Tuley on Tue Jul 20 2004.
//  Copyright (c) 2004 James Tuley. All rights reserved.
//

#import <EncryptOC/JTCryptKey.h>
#import "libCdsaCrypt/libCdsaCrypt.h"
#import "JTPrivateCryptKey.h"
#import "JTPublicCryptKey.h"
//#import "JTSymmetricCryptKey.h"

@implementation JTCryptKey

+(id)generateRSAKeyPairWithBits:(int)aBits{
    CSSM_CSP_HANDLE 	cspHandle;
    CSSM_KEY        publicKey;
    CSSM_KEY        privateKey;
    
    CSSM_RETURN crtn = cdsaCspAttach(&cspHandle);
    if(crtn) {
        cssmPerror("Attach to CSP", crtn);
    }
    
    cdsaGenerateKeyPair(cspHandle,
                        CSSM_ALGID_RSA,			// e.g., CSSM_ALGID_RSA
                        aBits,
                        &publicKey,
                        &privateKey);

    
    return [NSDictionary dictionaryWithObjectsAndKeys:
        [self keyWithKey:&publicKey andHandle:cspHandle],
        JTPublicKey,
        [self keyWithKey:&privateKey andHandle:cspHandle],
        JTPrivateKey,
        nil];
    
}


+(id)generateDSAKeyPairWithBits:(int)aBits{
    CSSM_CSP_HANDLE 	cspHandle;
    CSSM_KEY        publicKey;
    CSSM_KEY        privateKey;
    
    CSSM_RETURN crtn = cdsaCspAttach(&cspHandle);
    if(crtn) {
        cssmPerror("Attach to CSP", crtn);
    }
    
    cdsaGenerateKeyPair(cspHandle,
                        CSSM_ALGID_DSA,			// e.g., CSSM_ALGID_RSA
                        aBits,
                        &publicKey,
                        &privateKey);
    
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
        [self keyWithKey:&publicKey andHandle:cspHandle],
        JTPublicKey,
        [self keyWithKey:&privateKey andHandle:cspHandle],
        JTPrivateKey,
        nil];
    
}


+(id)generateAES128KeyWithPhrase:(NSString*)aPhrase{
    CSSM_CSP_HANDLE 	cspHandle;
    CSSM_KEY        cdsaKey;
    
    CSSM_RETURN crtn = cdsaCspAttach(&cspHandle);
    if(crtn) {
        cssmPerror("Attach to CSP", crtn);
    }
    
    crtn = cdsaDeriveKey(cspHandle,
                         [aPhrase cString],
                         [aPhrase cStringLength],
                         CSSM_ALGID_AES,
                         128,
                         &cdsaKey);
    
    if(crtn) {
        cssmPerror("DeriveKey", crtn);
    }
    
    return [self keyWithKey:&cdsaKey andHandle:cspHandle];
    
}


+(id)generateDES64KeyWithPhrase:(NSString*)aPhrase{
    CSSM_CSP_HANDLE 	cspHandle;
    CSSM_KEY        cdsaKey;
    
    CSSM_RETURN crtn = cdsaCspAttach(&cspHandle);
    if(crtn) {
        cssmPerror("Attach to CSP", crtn);
    }
    
    crtn = cdsaDeriveKey(cspHandle,
                         [aPhrase cString],
                         [aPhrase cStringLength],
                         CSSM_ALGID_DES,
                         64,
                         &cdsaKey);
    
    if(crtn) {
        cssmPerror("DeriveKey", crtn);
    }
    
    return [self keyWithKey:&cdsaKey andHandle:cspHandle];
    
}

+(id)keyWithKey:(CSSM_KEY_PTR)aKey andHandle:(CSSM_CSP_HANDLE)aCSPHandle{
    Class tempClass;
    uint32 tempType = (aKey)->KeyHeader.KeyClass;
    switch(tempType){
        case CSSM_KEYCLASS_PUBLIC_KEY:
            tempClass = [JTPublicCryptKey class];
            break;
        case CSSM_KEYCLASS_PRIVATE_KEY:
            tempClass = [JTPrivateCryptKey class];
            break;
//        case CSSM_KEYCLASS_SESSION_KEY:
//            tempClass = [JTSymmetricCryptKey class];
//            break;
        default:
            tempClass = self;
            break;
    }
        
    return [[[tempClass alloc] initWithKey:aKey andHandle:aCSPHandle] autorelease];
}

-(id)initWithKey:(CSSM_KEY_PTR)aKey andHandle:(CSSM_CSP_HANDLE)aCSPHandle{
    if(self = [super init]){
        _cspHandle=aCSPHandle;
        _key=*aKey;
    
        NSAssert([self type]==((aKey)->KeyHeader.KeyClass),@"KeyPtr Type doesn't match class type, use Factory Methods");
    }return self;
}

-(void)dealloc{
   // cdsaFreeKey(_cspHandle,&_key);
    [super dealloc];
}

- (unsigned)hash{
   return [[self keyData] hash];
}

-(BOOL)writeToFile:(NSString*)aPath atomically:(BOOL)flag{
    
    return [[self keyData] writeToFile:aPath atomically:flag];
}

-(NSData*)keyData{
    return [NSData dataWithBytes:_key.KeyData.Data length:_key.KeyData.Length];
}

-(uint32)headerVersion{
    return (_key).KeyHeader.HeaderVersion;
}

-(NSString*)cspId{
    NSNumber* data1 =[NSNumber numberWithUnsignedInt:(_key).KeyHeader.CspId.Data1];
    NSNumber* data2 = [NSNumber numberWithUnsignedShort:(_key).KeyHeader.CspId.Data2];
    NSNumber* data3 = [NSNumber numberWithUnsignedShort:(_key).KeyHeader.CspId.Data3];
    NSString* data4 = [NSString stringWithCString:(char*)(_key).KeyHeader.CspId.Data4 length:8];
    
    return [NSString stringWithFormat:@"%@ %@ %@ %@",data1,data2,data3,data4,nil];
}

-(uint32)useFlag{
    return (_key).KeyHeader.KeyUsage;
}

-(uint32)attrFlag{
    return (_key).KeyHeader.KeyAttr;
}

-(uint32)blobType{
    return (_key).KeyHeader.BlobType;

}

-(uint32)blobFormat{
    return (_key).KeyHeader.Format;
}

-(uint32)type{
    return (_key).KeyHeader.KeyClass;
}

-(uint32)algorithm{
    return (_key).KeyHeader.AlgorithmId;
}

-(uint32)wrapAlgorithm{
    return (_key).KeyHeader.WrapAlgorithmId;

}

-(uint32)wrapMode{
    return (_key).KeyHeader.WrapMode;
    
}

-(uint32)signitureAlgorithm{
    switch(_key.KeyHeader.AlgorithmId){
        case CSSM_ALGID_RSA:
            return CSSM_ALGID_SHA1WithRSA;
        case CSSM_ALGID_DSA:
            return CSSM_ALGID_SHA1WithDSA;
        default:
            return CSSM_ALGID_NONE;
    }
}

-(id)startDate{
    uint8* tempArray =(_key).KeyHeader.StartDate.Year;
    
    NSLog(@"%d,%d,%d,%d",tempArray[0],tempArray[1],tempArray[2],tempArray[3]);

    
    int tempYear =  tempArray[0] *1000 + tempArray[1] *100 + tempArray[2] *10 +tempArray[3];
    tempArray =(_key).KeyHeader.StartDate.Month;
    int tempMonth =  tempArray[0] *10 + tempArray[1];
    tempArray =(_key).KeyHeader.StartDate.Day;
    int tempDay =  tempArray[0] *10 + tempArray[1];

    
    
    return  [NSCalendarDate dateWithYear:tempYear
                           month:tempMonth
                             day:tempDay 
                            hour:0
                          minute:0
                          second:0 
                        timeZone:[NSTimeZone defaultTimeZone]];
    
}

-(id)endDate{
    uint8* tempArray =(_key).KeyHeader.EndDate.Year;
    
    NSLog(@"%d,%d,%d,%d",tempArray[0],tempArray[1],tempArray[2],tempArray[3]);
    
    int tempYear =  tempArray[0] *1000 + tempArray[1] *100 + tempArray[2] *10 +tempArray[3];
    tempArray =(_key).KeyHeader.EndDate.Month;
    int tempMonth =  tempArray[0] *10 + tempArray[1];
    tempArray =(_key).KeyHeader.EndDate.Day;
    int tempDay =  tempArray[0] *10 + tempArray[1];
    
    
    
    return  [NSCalendarDate dateWithYear:tempYear
                                   month:tempMonth
                                     day:tempDay 
                                    hour:0
                                  minute:0
                                  second:0 
                                timeZone:[NSTimeZone defaultTimeZone]];
}

@end
