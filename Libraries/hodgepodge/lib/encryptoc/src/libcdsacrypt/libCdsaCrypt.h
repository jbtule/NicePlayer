/*
	File:		libCdsaCrypt.h
        
        Contains:	simple high-level CDSA access routines.
        
	Copyright: 	© Copyright 2002 Apple Computer, Inc. All rights reserved.
	
	Disclaimer:	IMPORTANT:  This Apple software is supplied to you by Apple Computer, Inc.
                        ("Apple") in consideration of your agreement to the following terms, and your
                        use, installation, modification or redistribution of this Apple software
                        constitutes acceptance of these terms.  If you do not agree with these terms,
                        please do not use, install, modify or redistribute this Apple software.

                        In consideration of your agreement to abide by the following terms, and subject
                        to these terms, Apple grants you a personal, non-exclusive license, under Apple’s
                        copyrights in this original Apple software (the "Apple Software"), to use,
                        reproduce, modify and redistribute the Apple Software, with or without
                        modifications, in source and/or binary forms; provided that if you redistribute
                        the Apple Software in its entirety and without modifications, you must retain
                        this notice and the following text and disclaimers in all such redistributions of
                        the Apple Software.  Neither the name, trademarks, service marks or logos of
                        Apple Computer, Inc. may be used to endorse or promote products derived from the
                        Apple Software without specific prior written permission from Apple.  Except as
                        expressly stated in this notice, no other rights or licenses, express or implied,
                        are granted by Apple herein, including but not limited to any patent rights that
                        may be infringed by your derivative works or by other works in which the Apple
                        Software may be incorporated.

                        The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
                        WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
                        WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
                        PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
                        COMBINATION WITH YOUR PRODUCTS.

                        IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
                        CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
                        GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
                        ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION
                        OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT
                        (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN
                        ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
				
	Change History (most recent first):
                11/4/02		1.0d1

*/


#ifndef	_LIB_CDSA_CRYPT_H_
#define _LIB_CDSA_CRYPT_H_

#ifdef	__cplusplus
extern "C" {
#endif

#include <Security/cssm.h>

/*
 * Initialize CDSA and attach to the CSP.
 */
CSSM_RETURN cdsaCspAttach(
	CSSM_CSP_HANDLE		*cspHandle);
	
/*
 * Detach from CSP. To be called when app is finished with this 
 * library.
 */
CSSM_RETURN cdsaCspDetach(
	CSSM_CSP_HANDLE		cspHandle);
 
#pragma mark ------ Key generation ------

/*
 * Derive a CSSM_KEY from the specified raw key material.
 */
CSSM_RETURN cdsaDeriveKey(
	CSSM_CSP_HANDLE		cspHandle,		// from cdsaCspAttach()
	const void 			*rawKey,		
	size_t				rawKeyLen,
	CSSM_ALGORITHMS		keyAlg,			// e.g., CSSM_ALGID_AES
	uint32				keySizeInBits,
	CSSM_KEY_PTR		key);
	
/*
 * Generate asymmetric key pair. Currently supported algorithms
 * are RSA, DSA, and FEE.
 */
CSSM_RETURN cdsaGenerateKeyPair(
	CSSM_CSP_HANDLE 	cspHandle,
	CSSM_ALGORITHMS		keyAlg,			// e.g., CSSM_ALGID_RSA
	uint32				keySizeInBits,
	CSSM_KEY_PTR		publicKey,
	CSSM_KEY_PTR		privateKey);

/*
 * Free resources allocated in cdsaDeriveKey and cdsaGenerateKeyPair().
 */
CSSM_RETURN cdsaFreeKey(
	CSSM_CSP_HANDLE		cspHandle,		// from cdsaCspAttach()
	CSSM_KEY_PTR		key);			// from cdsaDeriveKey() 

#pragma mark ------ Diffie-Hellman key generation and derivation ------

/*
 * Generate a Diffie-Hellman key pair. Algorithm parameters are
 * either specified by caller via inParams, or are generated here
 * and returned to caller in outParams. Exactly one of (inParams,
 * outParams) must be non-NULL.
 */
CSSM_RETURN cdsaDhGenerateKeyPair(
	CSSM_CSP_HANDLE	cspHandle,
	CSSM_KEY_PTR	publicKey,
	CSSM_KEY_PTR	privateKey,
	uint32			keySizeInBits,
	const CSSM_DATA	*inParams,			// optional 
	CSSM_DATA_PTR	outParams);			// optional, we malloc

/*
 * Perform Diffie-Hellman key exchange. 
 * Given "our" private key (in the form of a CSSM_KEY) and "their" public
 * key (in the form of a raw blob of bytes), cook up a symmetric key.
 */
CSSM_RETURN cdsaDhKeyExchange(
	CSSM_CSP_HANDLE	cspHandle,
	CSSM_KEY_PTR	myPrivateKey,		// from cdsaDhGenerateKeyPair
	const void		*theirPubKey,
	uint32			theirPubKeyLen,
	CSSM_KEY_PTR	derivedKey,			// RETURNED
	uint32			deriveKeySizeInBits,
	CSSM_ALGORITHMS	derivedKeyAlg);		// e.g., CSSM_ALGID_AES

#pragma mark ------ Simple encrypt/decrypt routines ------

/* 
 * These routines are used to perform simple "one-shot"
 * encryption and decryption oprtations. Use them when 
 * all of the data to be encrypted or decrypted is 
 * available at once.
 */
 
/*
 * Encrypt.
 * cipherText->Data is allocated by the CSP and must be freed (via
 * free()) by caller.
 */
CSSM_RETURN cdsaEncrypt(
	CSSM_CSP_HANDLE		cspHandle,		// from cdsaCspAttach()
	const CSSM_KEY		*key,			// from cdsaDeriveKey()
	const CSSM_DATA		*plainText,
	CSSM_DATA_PTR		cipherText);
	
/*
 * Decrypt.
 * plainText->Data is allocated by the CSP and must be freed (via
 * free()) by caller.
 */
CSSM_RETURN cdsaDecrypt(
	CSSM_CSP_HANDLE		cspHandle,		// from cdsaCspAttach()
	const CSSM_KEY		*key,			// from cdsaDeriveKey()
	const CSSM_DATA		*cipherText,
	CSSM_DATA_PTR		plainText);
	
#pragma mark ------ Staged encrypt/decrypt routines ------

/* 
 * These routines are used to perform staged encryption and 
 * decryption operations. A typical use for these routines
 * would be to encrypt or decrypt data coming from a
 * stream or a file.
 *
 * To use these functions, first call cdsaStagedEncDecrInit
 * to set up a CSSM_CC_HANDLE. Then call cdsaStagedEncrypt
 * or cdsaStagedDecrypt as many times as you wish, setting the
 * 'final' aergument to CSSM_TRUE only for the last call.
 * Caller does not need to be concerned about buffer or block 
 * boundaries.
 */

typedef enum {
	/* for use in cdsaStagedEncDecrInit() */
	SO_Encrypt,
	SO_Decrypt,
	/* for use in cdsaStagedSignVerifyInit() */
	SO_Sign,
	SO_Verify
} StagedOpType;

CSSM_RETURN cdsaStagedEncDecrInit(
	CSSM_CSP_HANDLE		cspHandle,		// from cdsaCspAttach()
	const CSSM_KEY		*key,			// from cdsaDeriveKey()
	StagedOpType		opType,			// SO_Encrypt, SO_Decrypt
	CSSM_CC_HANDLE		*ccHandle);		// RETURNED
	
/*
 * Encrypt.
 * -- cipherText->Data is allocated by the CSP and must be freed (via
 *    free()) by caller.
 * -- plainText and its referent (plainText->Data) are optional on
 *    the final call; either one can be NULL at that time. 
 */
CSSM_RETURN cdsaStagedEncrypt(
	CSSM_CC_HANDLE		ccHandle,		// from cdsaStagedEncDecrInit()
	CSSM_BOOL			final,			// CSSM_TRUE on last call 
	const CSSM_DATA		*plainText,
	CSSM_DATA_PTR		cipherText);
	
/*
 * Decrypt.
 * -- plainText->Data is allocated by the CSP and must be freed (via
 *    free()) by caller.
 * -- cipherText and its referent (cipherText->Data) are optional on
 *    the final call; either one can be NULL at that time. 
 */
CSSM_RETURN cdsaStagedDecrypt(
	CSSM_CC_HANDLE		ccHandle,		// from cdsaStagedEncDecrInit()
	CSSM_BOOL			final,			// CSSM_TRUE on last call 
	const CSSM_DATA		*cipherText,
	CSSM_DATA_PTR		plainText);

#pragma mark ------ Digest routines ------

/*
 * The simple one-shot digest routine, when all of the data to 
 * be processed is available at once.
 * digest->Data is allocated by the CSP and must be freed (via
 * free()) by caller.
 */
CSSM_RETURN cdsaDigest(
	CSSM_CSP_HANDLE		cspHandle,		// from cdsaCspAttach()
	CSSM_ALGORITHMS		digestAlg,		// e.g., CSSM_ALGID_SHA1
	const CSSM_DATA		*inData,
	CSSM_DATA_PTR		digestData);
	
/*
 * Staged digest routines. For processing multiple chunks of 
 * data into one digest.
 * This is called once....
 */
CSSM_RETURN cdsaStagedDigestInit(
	CSSM_CSP_HANDLE		cspHandle,		// from cdsaCspAttach()
	CSSM_ALGORITHMS		digestAlg,		// e.g., CSSM_ALGID_SHA1
	CSSM_CC_HANDLE		*ccHandle);		// RETURNED
	
/*
 * And this is called an arbitrary number of times, with a value
 * of CSSM_TRUE for the 'final' argument on the last call.
 * -- Until the final call, the digestData argument is ignored.
 * -- digest->Data is allocated by the CSP and must be freed (via
 *    free()) by caller.
 * -- inData and its referent (inData->Data) are optional on
 *    the final call; either one can be NULL at that time.
 */
CSSM_RETURN cdsaStagedDigest(
	CSSM_CC_HANDLE		ccHandle,		// from cdsaStagedEncDecrInit()
	CSSM_BOOL			final,			// CSSM_TRUE on last call 
	const CSSM_DATA		*inData,
	CSSM_DATA_PTR		digestData);

#pragma mark ------ Simple sign/verify ------

/*
 * Generate a digital signature, one-shot version. To be
 * used when all of the data to be signed is available at once.
 * signature->Data is allocated by the CSP and must be freed (via
 * free()) by caller.
 */
CSSM_RETURN cdsaSign(
	CSSM_CSP_HANDLE		cspHandle,		// from cdsaCspAttach()
	const CSSM_KEY		*key,			// from cdsaGenerateKeyPair()
	CSSM_ALGORITHMS		sigAlg,			// e.g., CSSM_ALGID_SHA1WithRSA
	const CSSM_DATA		*dataToSign,
	CSSM_DATA_PTR		signature);
	
/*
 * Verify a digital signature, one-shot version. To be
 * used when all of the data to be verified is available at once.
 */
CSSM_RETURN cdsaVerify(
	CSSM_CSP_HANDLE		cspHandle,		// from cdsaCspAttach()
	const CSSM_KEY		*key,			// from cdsaGenerateKeyPair()
	CSSM_ALGORITHMS		sigAlg,			// e.g., CSSM_ALGID_SHA1WithRSA
	const CSSM_DATA		*dataToSign,
	const CSSM_DATA		*signature);
	
	
#pragma mark ------ Staged Sign/Verify routines ------

/* 
 * These routines are used to initialize staged sign and 
 * verify oprtations. A typical use for these routines
 * would be to generate or verify a digitial signature for
 * data coming from a stream or a file.
 *
 * To use these functions, first call cdsaStagedSignVerifyInit
 * to set up a CSSM_CC_HANDLE. Then call cdsaStagedSign
 * or cdsaStagedVerify as many times as you wish, passing a 
 * non-NULL 'signature' argument only for the last call.
 * Caller does not need to be concerned about buffer or block 
 * boundaries.
 */

CSSM_RETURN cdsaStagedSignVerifyInit(
	CSSM_CSP_HANDLE		cspHandle,		// from cdsaCspAttach()
	const CSSM_KEY		*key,			// from cdsaDeriveKey()
	CSSM_ALGORITHMS		sigAlg,			// e.g., CSSM_ALGID_SHA1WithRSA
	StagedOpType		opType,			// SO_Sign, SO_Verify
	CSSM_CC_HANDLE		*ccHandle);		// RETURNED
	
/*
 * Sign.
 * -- The signature argument is non-NULL only on the final call to
 *    this function. 
 * -- signature->Data is allocated by the CSP and must be freed (via
 *    free()) by caller.
 * -- dataToSign and its referent (dataToSign->Data) are optional on
 *    the final call; either one can be NULL at that time. 
 */
CSSM_RETURN cdsaStagedSign(
	CSSM_CC_HANDLE		ccHandle,		// from cdsaStagedSignVerifyInit()
	const CSSM_DATA		*dataToSign,
	CSSM_DATA_PTR		signature);		// non-NULL on final call only
	
/*
 * Verify.
 * -- The signature argument is non-NULL only on the final call to
 *    this function. 
 * -- dataToVerify and its referent (dataToVerify->Data) are optional on
 *    the final call; either one can be NULL at that time. 
 */
CSSM_RETURN cdsaStagedVerify(
	CSSM_CC_HANDLE		ccHandle,		// from cdsaStagedSignVerifyInit()
	const CSSM_DATA		*dataToVerify,
	const CSSM_DATA		*signature);	// non-NULL on final call only


#ifdef	__cplusplus
}
#endif

#endif	/* _LIB_CDSA_CRYPT_H_ */
