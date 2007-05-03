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
//  JTSymmetricCryptKey.m
//  IndyKit
//
//  Created by James Tuley on Tue Jul 20 2004.
//  Copyright (c) 2004 James Tuley. All rights reserved.
//

#import "JTSymmetricCryptKey.h"
#import "libCdsaCrypt/libCdsaCrypt.h"


@implementation JTSymmetricCryptKey

//+(id)keyWithData:(NSData*)aData withAlgortihm:(uint32)anAlgorithm{
//    CSSM_DATA                   keyData;
//    CSSM_KEYHEADER              hdr;
//    CSSM_RETURN			crtn;
//    CSSM_KEY_SIZE 		keySize;
//    CSSM_CSP_HANDLE             cspHandle;
//    CSSM_KEY                    cdsaKey;
//    
//    memset(&cdsaKey, 0, sizeof(CSSM_KEY));
//
//    crtn = cdsaCspAttach(&cspHandle);
//    if(crtn) {
//        cssmPerror("Attach to CSP", crtn);
//    }
//    
//    keyData.Data = [aData bytes];
//    keyData.Length = [aData length];
//  
//    hdr.HeaderVersion = CSSM_KEYHEADER_VERSION;
//    hdr.BlobType = CSSM_KEYBLOB_RAW;
//    
//    //Infer format from algorithm and key class 
//    hdr.Format = CSSM_KEYBLOB_RAW_FORMAT_OCTET_STRING;
//    
//    hdr.AlgorithmId = anAlgorithm;
//    
//    hdr.KeyClass = CSSM_KEYCLASS_SESSION_KEY;//changes per class
//
//    hdr.KeyAttr = CSSM_KEYATTR_EXTRACTABLE;
//    hdr.KeyUsage = CSSM_KEYUSE_ANY;
//    
//    
//    
//    cdsaKey.KeyData = keyData;
//    cdsaKey.KeyHeader = hdr;
//    
//    // ask the CSP for key size 
//    crtn = CSSM_QueryKeySizeInBits(cspHandle, NULL, &cdsaKey, &keySize);
//    if(crtn) {
//        cssmPerror("CSSM_QueryKeySizeInBits", crtn);
//    }
//    cdsaKey.KeyHeader.LogicalKeySizeInBits = keySize.LogicalKeySizeInBits;
//    
//    return [self keyWithKey:cdsaKey andHandle:cspHandle];
//}

-(UInt32)type{
    return CSSM_KEYCLASS_SESSION_KEY;
}

-(NSData*)encryptData:(NSData*)aData{
    CSSM_DATA		ptext;
    CSSM_DATA		ctext;
    CSSM_RETURN crtn;
    
    ptext.Data = (uint8*)[aData bytes];
    ptext.Length = [aData length];
    
    ctext.Data = NULL;
    ctext.Length = 0;
    
    crtn = cdsaEncrypt(_cspHandle,
                       &_key,
                       &ptext,
                       &ctext);
    if(crtn) {
        cssmPerror("cdsaEncrypt", crtn);
        return nil;
    }
    
    return [NSData dataWithBytesNoCopy:ctext.Data length:ctext.Length];
}

-(NSData*)decryptData:(NSData*)aData{
    CSSM_DATA		ptext;
    CSSM_DATA		ctext;
    CSSM_RETURN crtn;
    
    ctext.Data = (uint8*)[aData bytes];
    ctext.Length = [aData length];
    
    ptext.Data = NULL;
    ptext.Length = 0;
    
    crtn = cdsaDecrypt(_cspHandle,
                       &_key,
                       &ctext,
                       &ptext);
    if(crtn) {
        cssmPerror("cdsaDecrypt", crtn);
        return nil;
    }
    
    return [NSData dataWithBytesNoCopy:ptext.Data length:ptext.Length];
}


@end
