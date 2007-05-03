/*
	File:		libCdsaCrypt.cpp
        
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


#include "libCdsaCrypt.h"
#include <stdlib.h>
#include <stdio.h>
#include <strings.h>

#pragma mark --- static session data and private functions ----

static CSSM_VERSION vers = {2, 0};
static const CSSM_GUID testGuid = { 0xFADE, 0, 0, { 1,2,3,4,5,6,7,0 }};

/*
 * Standard app-level memory functions required by CDSA.
 */
void * appMalloc (uint32 size, void *allocRef) {
	return( malloc(size) );
}
void appFree (void *mem_ptr, void *allocRef) {
	free(mem_ptr);
 	return;
}
void * appRealloc (void *ptr, uint32 size, void *allocRef) {
	return( realloc( ptr, size ) );
}
void * appCalloc (uint32 num, uint32 size, void *allocRef) {
	return( calloc( num, size ) );
}
static CSSM_API_MEMORY_FUNCS memFuncs = {
	appMalloc,
	appFree,
	appRealloc,
 	appCalloc,
 	NULL
 };

/*
 * Init CSSM; returns CSSM_FALSE on error. Reusable.
 */
static CSSM_BOOL cssmInitd = CSSM_FALSE;
CSSM_RETURN cssmStartup()
{
	if(cssmInitd) {
		return CSSM_OK;
	}  

	CSSM_RETURN  crtn;
    CSSM_PVC_MODE pvcPolicy = CSSM_PVC_NONE;
	
	crtn = CSSM_Init (&vers, 
		CSSM_PRIVILEGE_SCOPE_NONE,
		&testGuid,
		CSSM_KEY_HIERARCHY_NONE,
		&pvcPolicy,
		NULL /* reserved */);
	if(crtn != CSSM_OK) {
		return crtn;
	}
	else {
		cssmInitd = CSSM_TRUE;
		return CSSM_OK;
	}
}

/*
 * Cook up a symmetric encryption context for the specified key,
 * inferring all needed attributes solely from the key algorithm.
 * This is obviously not a one-size-fits all function, but rather
 * the "most common case". If you need to encrypt/decrypt with other
 * padding, mode, etc., do it yourself.
 */
static CSSM_RETURN genCryptHandle(
	CSSM_CSP_HANDLE cspHandle,
	const CSSM_KEY	*key,
	const CSSM_DATA	*ivPtr,
	CSSM_CC_HANDLE	*ccHandle)
{
	CSSM_ALGORITHMS		keyAlg = key->KeyHeader.AlgorithmId;
	CSSM_ALGORITHMS		encrAlg;
	CSSM_ENCRYPT_MODE	encrMode = CSSM_ALGMODE_NONE;
	CSSM_PADDING 		encrPad = CSSM_PADDING_NONE;
	CSSM_RETURN			crtn;
	CSSM_CC_HANDLE		ccHand = 0;
	CSSM_ACCESS_CREDENTIALS	creds;
	CSSM_BOOL			isSymmetric = CSSM_TRUE;
	
	/* 
	 * Infer algorithm - ususally it's the same as in the key itself
	 */
	switch(keyAlg) {
		case CSSM_ALGID_3DES_3KEY:
			encrAlg = CSSM_ALGID_3DES_3KEY_EDE;
			break;
		default:
			encrAlg = keyAlg;
			break;
	}
	
	/* infer mode and padding */
	switch(encrAlg) {
		/* 8-byte block ciphers */
		case CSSM_ALGID_DES:
		case CSSM_ALGID_3DES_3KEY_EDE:
		case CSSM_ALGID_RC5:
		case CSSM_ALGID_RC2:
			encrMode = CSSM_ALGMODE_CBCPadIV8;
			encrPad = CSSM_PADDING_PKCS5;
			break;
		
		/* 16-byte block ciphers */
		case CSSM_ALGID_AES:
			encrMode = CSSM_ALGMODE_CBCPadIV8;
			encrPad = CSSM_PADDING_PKCS7;
			break;
			
		/* stream ciphers */
		case CSSM_ALGID_ASC:
		case CSSM_ALGID_RC4:
			encrMode = CSSM_ALGMODE_NONE;
			encrPad = CSSM_PADDING_NONE;
			break;
			
		/* RSA asymmetric */
		case CSSM_ALGID_RSA:
			/* encrMode not used */
			encrPad = CSSM_PADDING_PKCS1;
			isSymmetric = CSSM_FALSE;
			break;
		default:
			/* don't wing it - abort */
			return CSSMERR_CSP_INTERNAL_ERROR;
	}
	
	memset(&creds, 0, sizeof(CSSM_ACCESS_CREDENTIALS));
	if(isSymmetric) {
		crtn = CSSM_CSP_CreateSymmetricContext(cspHandle,
			encrAlg,
			encrMode,
			NULL,			// access cred
			key,
			ivPtr,			// InitVector
			encrPad,
			NULL,			// Params
			&ccHand);
	}
	else {
		crtn = CSSM_CSP_CreateAsymmetricContext(cspHandle,
			encrAlg,
			&creds,			// access
			key,
			encrPad,
			&ccHand);
	
	}
	if(crtn) {
		return crtn;
	}
	*ccHandle = ccHand;
	return CSSM_OK;
}

#pragma mark --- start of public Functions ---

/*
 * Initialize CDSA and attach to the CSP.
 */
CSSM_RETURN cdsaCspAttach(
	CSSM_CSP_HANDLE		*cspHandle)
{
	CSSM_CSP_HANDLE cspHand;
	CSSM_RETURN		crtn;
	
	/* initialize CDSA (this is reusable) */
	crtn = cssmStartup();
	if(crtn) {
		return crtn;
	}
	
	/* Load the CSP bundle into this app's memory space */
	crtn = CSSM_ModuleLoad(&gGuidAppleCSP,
		CSSM_KEY_HIERARCHY_NONE,
		NULL,			// eventHandler
		NULL);			// AppNotifyCallbackCtx
	if(crtn) {
		return crtn;
	}
	
	/* obtain a handle which will be used to refer to the CSP */ 
	crtn = CSSM_ModuleAttach (&gGuidAppleCSP,
		&vers,
		&memFuncs,			// memFuncs
		0,					// SubserviceID
		CSSM_SERVICE_CSP,	
		0,					// AttachFlags
		CSSM_KEY_HIERARCHY_NONE,
		NULL,				// FunctionTable
		0,					// NumFuncTable
		NULL,				// reserved
		&cspHand);
	if(crtn) {
		return crtn;
	}
	*cspHandle = cspHand;
	return CSSM_OK;
}
	
/*
 * Detach from CSP. To be called when app is finished with this 
 * library.
 */
CSSM_RETURN cdsaCspDetach(
	CSSM_CSP_HANDLE		cspHandle)
{
	return CSSM_ModuleDetach(cspHandle);
}

#pragma mark ------ Key generation ------

/*
 * Derive a symmetric CSSM_KEY from the specified raw key material.
 */
CSSM_RETURN cdsaDeriveKey(
	CSSM_CSP_HANDLE		cspHandle,
	const void 			*rawKey,
	size_t				rawKeyLen,
	CSSM_ALGORITHMS		keyAlg,			// e.g., CSSM_ALGID_AES
	uint32				keySizeInBits,
	CSSM_KEY_PTR		key)
{
	CSSM_RETURN					crtn;
	CSSM_CC_HANDLE 				ccHand;
	CSSM_DATA					dummyLabel = {8, (uint8 *)"tempKey"};
	CSSM_DATA					saltData = {8, (uint8 *)"someSalt"};
	CSSM_PKCS5_PBKDF2_PARAMS 	pbeParams;
	CSSM_DATA					pbeData;
	CSSM_ACCESS_CREDENTIALS		creds;
	
	memset(key, 0, sizeof(CSSM_KEY));
	memset(&creds, 0, sizeof(CSSM_ACCESS_CREDENTIALS));
	crtn = CSSM_CSP_CreateDeriveKeyContext(cspHandle,
		CSSM_ALGID_PKCS5_PBKDF2,
		keyAlg,
		keySizeInBits,
		&creds,
		NULL,			// BaseKey
		1000,			// iterationCount, 1000 is the minimum
		&saltData,
		NULL,			// seed
		&ccHand);
	if(crtn) {
		return crtn;
	}
	
	/* this is the caller's raw key bits, typically ASCII (though it
	 * could be anything) */
	pbeParams.Passphrase.Data = (uint8 *)rawKey;
	pbeParams.Passphrase.Length = rawKeyLen;
	/* The only PRF supported by the CSP is HMACSHA1 */
	pbeParams.PseudoRandomFunction = CSSM_PKCS5_PBKDF2_PRF_HMAC_SHA1;
	pbeData.Data = (uint8 *)&pbeParams;
	pbeData.Length = sizeof(pbeParams);
	crtn = CSSM_DeriveKey(ccHand,
		&pbeData,
		CSSM_KEYUSE_ANY,
		CSSM_KEYATTR_RETURN_DATA | CSSM_KEYATTR_EXTRACTABLE,
		&dummyLabel,
		NULL,			// cred and acl
		key);
	CSSM_DeleteContext(ccHand);		// ignore error here
	return crtn;
}

/*
 * Generate asymmetric key pair. Currently supported algorithms
 * are RSA, DSA, and FEE.
 */
CSSM_RETURN cdsaGenerateKeyPair(
	CSSM_CSP_HANDLE 	cspHandle,
	CSSM_ALGORITHMS		keyAlg,			// e.g., CSSM_ALGID_RSA
	uint32				keySizeInBits,
	CSSM_KEY_PTR		publicKey,
	CSSM_KEY_PTR		privateKey)
{
	CSSM_RETURN		crtn;
	CSSM_CC_HANDLE 	ccHandle;
	CSSM_DATA		dummyLabel = {8, (uint8 *)"tempKey"};

	memset(publicKey, 0, sizeof(CSSM_KEY));
	memset(privateKey, 0, sizeof(CSSM_KEY));
	
	crtn = CSSM_CSP_CreateKeyGenContext(cspHandle,
		keyAlg,
		keySizeInBits,
		NULL,					// Seed
		NULL,					// Salt
		NULL,					// StartDate
		NULL,					// EndDate
		NULL,					// Params
		&ccHandle);
	if(crtn) {
		return crtn;
	}

	/* post-context-create algorithm-specific stuff */
	switch(keyAlg) {
		 case CSSM_ALGID_DSA:
			/* 
			 * extra step - generate params - this just adds some
			 * info to the context
			 */
			{
				CSSM_DATA dummy = {0, NULL};
				crtn = CSSM_GenerateAlgorithmParams(ccHandle, 
					keySizeInBits, &dummy);
				if(crtn) {
					return crtn;
				}
				free(dummy.Data);
			}
			break;
		default:
			/* RSA, FEE - nothing to do */
			break;
	}
	
	/*
	 * Public keys can encrypt and verify signature. 
	 * Private keys can decrypt and sign.
	 */
	crtn = CSSM_GenerateKeyPair(ccHandle,
		CSSM_KEYUSE_ENCRYPT | CSSM_KEYUSE_VERIFY,
		CSSM_KEYATTR_RETURN_DATA | CSSM_KEYATTR_EXTRACTABLE,
		&dummyLabel,
		publicKey,
		CSSM_KEYUSE_DECRYPT | CSSM_KEYUSE_SIGN,
		CSSM_KEYATTR_RETURN_DATA | CSSM_KEYATTR_EXTRACTABLE,
		&dummyLabel,			// same labels
		NULL,					// CredAndAclEntry
		privateKey);
	CSSM_DeleteContext(ccHandle);
	return crtn;
}

/*
 * Free resources allocated in cdsaDeriveKey().
 */
CSSM_RETURN cdsaFreeKey(
	CSSM_CSP_HANDLE		cspHandle,
	CSSM_KEY_PTR		key)
{
	return CSSM_FreeKey(cspHandle, 
		NULL,			// access cred
		key,	
		CSSM_FALSE);	// don't delete since it wasn't permanent
}

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
	const CSSM_DATA	*inParams,		// optional 
	CSSM_DATA_PTR	outParams)		// optional, we malloc
{
	CSSM_RETURN		crtn;
	CSSM_CC_HANDLE 	ccHandle;
	CSSM_DATA		labelData = {8, (uint8 *)"tempKey"};
	
	/* Caller must specify either inParams or outParams, not both */
	if(inParams && outParams) {
		return CSSMERR_CSSM_INVALID_POINTER;
	}
	if(!inParams && !outParams) {
		return CSSMERR_CSSM_INVALID_POINTER;
	}
	memset(publicKey, 0, sizeof(CSSM_KEY));
	memset(privateKey, 0, sizeof(CSSM_KEY));
	
	crtn = CSSM_CSP_CreateKeyGenContext(cspHandle,
		CSSM_ALGID_DH,
		keySizeInBits,
		NULL,					// Seed
		NULL,					// Salt
		NULL,					// StartDate
		NULL,					// EndDate
		inParams,				// Params, may be NULL
		&ccHandle);
	if(crtn) {
		return crtn;
	}
	
	if(outParams) {
		/* explicitly generate params and return them to caller */
		outParams->Data = NULL;
		outParams->Length = 0;
		crtn = CSSM_GenerateAlgorithmParams(ccHandle, 
			keySizeInBits, outParams);
		if(crtn) {
			CSSM_DeleteContext(ccHandle);
			return crtn;
		}
	}
	
	crtn = CSSM_GenerateKeyPair(ccHandle,
		CSSM_KEYUSE_DERIVE,		// only legal use of a Diffie-Hellman key 
		CSSM_KEYATTR_RETURN_DATA | CSSM_KEYATTR_EXTRACTABLE,
		&labelData,
		publicKey,
		/* private key specification */
		CSSM_KEYUSE_DERIVE,
		CSSM_KEYATTR_RETURN_REF,
		&labelData,				// same labels
		NULL,					// CredAndAclEntry
		privateKey);
	CSSM_DeleteContext(ccHandle);
	return crtn;
}

/*
 * Perform Diffie-Hellman key exchange. 
 * Given "our" private key (in the form of a CSSM_KEY) and "their" public
 * key (in the form of a raw blob of bytes), cook up a symmetric key.
 */
CSSM_RETURN cdsaDhKeyExchange(
	CSSM_CSP_HANDLE	cspHandle,
	CSSM_KEY_PTR	myPrivateKey,			// from cdsaDhGenerateKeyPair
	const void		*theirPubKey,
	uint32			theirPubKeyLen,
	CSSM_KEY_PTR	derivedKey,				// RETURNED
	uint32			deriveKeySizeInBits,
	CSSM_ALGORITHMS	derivedKeyAlg)			// e.g., CSSM_ALGID_AES
{
	CSSM_RETURN 			crtn;
	CSSM_ACCESS_CREDENTIALS	creds;
	CSSM_CC_HANDLE			ccHandle;
	CSSM_DATA				labelData = {8, (uint8 *)"tempKey"};
	
	memset(&creds, 0, sizeof(CSSM_ACCESS_CREDENTIALS));
	memset(derivedKey, 0, sizeof(CSSM_KEY));
	
	crtn = CSSM_CSP_CreateDeriveKeyContext(cspHandle,
		CSSM_ALGID_DH,
		derivedKeyAlg,
		deriveKeySizeInBits,
		&creds,
		myPrivateKey,	// BaseKey
		0,				// IterationCount
		0,				// Salt
		0,				// Seed
		&ccHandle);
	if(crtn) {
		return crtn;
	}
	
	/* public key passed in as CSSM_DATA *Param */
	CSSM_DATA theirPubKeyData = { theirPubKeyLen, (uint8 *)theirPubKey };
	
	crtn = CSSM_DeriveKey(ccHandle,
		&theirPubKeyData,
		CSSM_KEYUSE_ANY, 
		CSSM_KEYATTR_RETURN_DATA | CSSM_KEYATTR_EXTRACTABLE,
		&labelData,
		NULL,				// cread/acl
		derivedKey);
	CSSM_DeleteContext(ccHandle);
	return crtn;
}

#pragma mark ------ Simple encrypt/decrypt routines ------

/* 
 * Common initialization vector shared by encrypt and decrypt.
 * Some applications may wish to specify a different IV for
 * each encryption op (e.g., disk block number, IP packet number,
 * etc.) but that is outside the scope of this library.
 */
static uint8 iv[16] = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 };
static const CSSM_DATA ivCommon = {16, iv};

/*
 * Encrypt.
 * cipherText->Data is allocated by the CSP and must be freed (via
 * free()) by caller.
 */
CSSM_RETURN cdsaEncrypt(
	CSSM_CSP_HANDLE		cspHandle,
	const CSSM_KEY		*key,
	const CSSM_DATA		*plainText,
	CSSM_DATA_PTR		cipherText)
{
	CSSM_RETURN 	crtn;
	CSSM_CC_HANDLE	ccHandle;
	CSSM_DATA		remData = {0, NULL};
	uint32			bytesEncrypted;
	
	crtn = genCryptHandle(cspHandle, key, &ivCommon, &ccHandle);
	if(crtn) {
		return crtn;
	}
	cipherText->Length = 0;
	cipherText->Data = NULL;
	crtn = CSSM_EncryptData(ccHandle,
		plainText,
		1,
		cipherText,
		1,
		&bytesEncrypted,
		&remData);
	CSSM_DeleteContext(ccHandle);
	if(crtn) {
		return crtn;
	}
	
	cipherText->Length = bytesEncrypted;
	if(remData.Length != 0) {
		/* append remaining data to cipherText */
		uint32 newLen = cipherText->Length + remData.Length;
		cipherText->Data = (uint8 *)appRealloc(cipherText->Data,
			newLen,
			NULL);
		memmove(cipherText->Data + cipherText->Length, 
			remData.Data, remData.Length);
		cipherText->Length = newLen;
		appFree(remData.Data, NULL);
	}
	return CSSM_OK;
}

/*
 * Decrypt.
 * plainText->Data is allocated by the CSP and must be freed (via
 * free()) by caller.
 */
CSSM_RETURN cdsaDecrypt(
	CSSM_CSP_HANDLE		cspHandle,
	const CSSM_KEY		*key,
	const CSSM_DATA		*cipherText,
	CSSM_DATA_PTR		plainText)
{
	CSSM_RETURN 	crtn;
	CSSM_CC_HANDLE	ccHandle;
	CSSM_DATA		remData = {0, NULL};
	uint32			bytesDecrypted;
	
	crtn = genCryptHandle(cspHandle, key, &ivCommon, &ccHandle);
	if(crtn) {
		return crtn;
	}
	plainText->Length = 0;
	plainText->Data = NULL;
	crtn = CSSM_DecryptData(ccHandle,
		cipherText,
		1,
		plainText,
		1,
		&bytesDecrypted,
		&remData);
	CSSM_DeleteContext(ccHandle);
	if(crtn) {
		return crtn;
	}
	
	plainText->Length = bytesDecrypted;
	if(remData.Length != 0) {
		/* append remaining data to plainText */
		uint32 newLen = plainText->Length + remData.Length;
		plainText->Data = (uint8 *)appRealloc(plainText->Data,
			newLen,
			NULL);
		memmove(plainText->Data + plainText->Length, 
			remData.Data, remData.Length);
		plainText->Length = newLen;
		appFree(remData.Data, NULL);
	}
	return CSSM_OK;
}

#pragma mark ------ Staged encrypt/decrypt routines ------

/* 
 * Staged init - cook up a CSSM_CC_HANDLE and call the appropriate
 * init.
 */
CSSM_RETURN cdsaStagedEncDecrInit(
	CSSM_CSP_HANDLE		cspHandle,		// from cdsaCspAttach()
	const CSSM_KEY		*key,			// from cdsaDeriveKey()
	StagedOpType		opType,			// SO_Encrypt, SO_Decrypt
	CSSM_CC_HANDLE		*ccHandle)		// RETURNED
{
	CSSM_RETURN 	crtn;
	CSSM_CC_HANDLE	ccHand;
	
	crtn = genCryptHandle(cspHandle, key, &ivCommon, &ccHand);
	if(crtn) {
		return crtn;
	}
	switch(opType) {
		case SO_Encrypt:
			crtn = CSSM_EncryptDataInit(ccHand);
			break;
		case SO_Decrypt:
			crtn = CSSM_DecryptDataInit(ccHand);
			break;
		default:
			return CSSMERR_CSP_FUNCTION_NOT_IMPLEMENTED;
	}
	if(crtn) {
		CSSM_DeleteContext(ccHand);
	}
	else {
		*ccHandle = ccHand;
	}
	return CSSM_OK;
}

/*
 * Encrypt.
 * cipherText->Data is allocated by the CSP and must be freed (via
 * free()) by caller.
 */
CSSM_RETURN cdsaStagedEncrypt(
	CSSM_CC_HANDLE		ccHandle,		// from cdsaStagedEncDecrInit()
	CSSM_BOOL			final,			// CSSM_TRUE on last call 
	const CSSM_DATA		*plainText,
	CSSM_DATA_PTR		cipherText)
{
	CSSM_RETURN 	crtn;
	
	cipherText->Length = 0;
	cipherText->Data = NULL;

	/* 1. any more data to encrypt? */
	if(plainText && plainText->Length) {
		uint32 bytesEncrypted;
		
		crtn = CSSM_EncryptDataUpdate(ccHandle,
			plainText,
			1,
			cipherText,
			1,
			&bytesEncrypted);
		if(crtn) {
			goto abort;
		}
		cipherText->Length = bytesEncrypted;
	}
	
	/* 2. Last call? */
	if(final) {
		CSSM_DATA remData = {0, NULL};
		
		crtn = CSSM_EncryptDataFinal(ccHandle, &remData);
		if(crtn) {
			goto abort;
		}
		
		/* append remaining data to plainText */
		uint32 newLen = cipherText->Length + remData.Length;
		cipherText->Data = (uint8 *)appRealloc(cipherText->Data,
			newLen,
			NULL);
		memmove(cipherText->Data + cipherText->Length, 
			remData.Data, remData.Length);
		cipherText->Length = newLen;
		appFree(remData.Data, NULL);
	}
abort:
	/* in any case, delete the context if we're done */
	if(final) {
		CSSM_DeleteContext(ccHandle);
	}
	return crtn;
}
	
/*
 * Decrypt.
 * plainText->Data is allocated by the CSP and must be freed (via
 * free()) by caller.
 */
CSSM_RETURN cdsaStagedDecrypt(
	CSSM_CC_HANDLE		ccHandle,		// from cdsaStagedEncDecrInit()
	CSSM_BOOL			final,			// CSSM_TRUE on last call 
	const CSSM_DATA		*cipherText,
	CSSM_DATA_PTR		plainText)
{
	CSSM_RETURN 	crtn;
	
	plainText->Length = 0;
	plainText->Data = NULL;

	/* 1. any more data to decrypt? */
	if(cipherText && cipherText->Length) {
		uint32 bytesDecrypted;
		
		crtn = CSSM_DecryptDataUpdate(ccHandle,
			cipherText,
			1,
			plainText,
			1,
			&bytesDecrypted);
		if(crtn) {
			goto abort;
		}
		plainText->Length = bytesDecrypted;
	}
	
	/* 2. Last call? */
	if(final) {
		CSSM_DATA remData = {0, NULL};
		
		crtn = CSSM_DecryptDataFinal(ccHandle, &remData);
		if(crtn) {
			goto abort;
		}
		
		/* append remaining data to plainText */
		uint32 newLen = plainText->Length + remData.Length;
		plainText->Data = (uint8 *)appRealloc(plainText->Data,
			newLen,
			NULL);
		memmove(plainText->Data + plainText->Length, 
			remData.Data, remData.Length);
		plainText->Length = newLen;
		appFree(remData.Data, NULL);
	}
abort:
	/* in any case, delete the context if we're done */
	if(final) {
		CSSM_DeleteContext(ccHandle);
	}
	return crtn;
}


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
	CSSM_DATA_PTR		digestData)
{
	CSSM_RETURN 	crtn;
	CSSM_CC_HANDLE	ccHandle;
	
	digestData->Data = NULL;
	digestData->Length = 0;
	
	crtn = CSSM_CSP_CreateDigestContext(cspHandle, digestAlg, &ccHandle);
	if(crtn) {
		return crtn;
	}
	crtn = CSSM_DigestData(ccHandle, inData, 1, digestData);
	CSSM_DeleteContext(ccHandle);
	return crtn;
}
	
/*
 * Staged digest routines. For processing multiple chunks of 
 * data into one digest.
 * This is called once....
 */
CSSM_RETURN cdsaStagedDigestInit(
	CSSM_CSP_HANDLE		cspHandle,		// from cdsaCspAttach()
	CSSM_ALGORITHMS		digestAlg,		// e.g., CSSM_ALGID_SHA1
	CSSM_CC_HANDLE		*ccHandle)		// RETURNED
{
	CSSM_RETURN 	crtn;
	CSSM_CC_HANDLE	ccHand;
	
	crtn = CSSM_CSP_CreateDigestContext(cspHandle, digestAlg, &ccHand);
	if(crtn) {
		return crtn;
	}
	crtn = CSSM_DigestDataInit(ccHand);
	if(crtn) {
		CSSM_DeleteContext(ccHand);
	}
	else {
		*ccHandle = ccHand;
	}
	return crtn;
}
	
/*
 * And this is call an arbitraty number of times, with a value
 * of CSSM_TRUE for the 'final' argument on the last call.
 * Until the final call, the digestData argument is ignored.
 * digest->Data is allocated by the CSP and must be freed (via
 * free()) by caller.
 */
CSSM_RETURN cdsaStagedDigest(
	CSSM_CC_HANDLE		ccHandle,		// from cdsaStagedEncDecrInit()
	CSSM_BOOL			final,			// CSSM_TRUE on last call 
	const CSSM_DATA		*inData,
	CSSM_DATA_PTR		digestData)
{
	CSSM_RETURN crtn;
	
	/* 1. any more data to digest? */
	if(inData && inData->Length) {
		crtn = CSSM_DigestDataUpdate(ccHandle, inData, 1);
		if(crtn) {
			goto abort;
		}
	}
	
	/* 2. Last call? */
	if(final) {
		digestData->Data = NULL;
		digestData->Length = 0;
		
		crtn = CSSM_DigestDataFinal(ccHandle, digestData);
	}
abort:
	/* in any case, delete the context if we're done */
	if(final) {
		CSSM_DeleteContext(ccHandle);
	}
	return crtn;
}

#pragma mark ------ Simple sign/verify ------

/*
 * Generate a digital signature, one-shot version. To be
 * used when all of the data to be signed is available at once.
 * signature->Data is allocated by the CSP and must be freed (via
 * free()) by caller.
 */
CSSM_RETURN cdsaSign(
	CSSM_CSP_HANDLE		cspHandle,		// from cdsaCspAttach()
	const CSSM_KEY		*key,			// from cdsaDeriveKey()
	CSSM_ALGORITHMS		sigAlg,			// e.g., CSSM_ALGID_SHA1WithRSA
	const CSSM_DATA		*dataToSign,
	CSSM_DATA_PTR		signature)
{
	CSSM_CC_HANDLE	sigHand;
	CSSM_RETURN		crtn;
	
	crtn = CSSM_CSP_CreateSignatureContext(cspHandle,
		sigAlg,
		NULL,				// passPhrase
		key,
		&sigHand);
	if(crtn) {
		return crtn;
	}
	crtn = CSSM_SignData(sigHand,
		dataToSign,
		1,
		CSSM_ALGID_NONE,
		signature);
	CSSM_DeleteContext(sigHand);
	return crtn;
}
	
/*
 * Verify a digital signature, one-shot version. To be
 * used when all of the data to be verified is available at once.
 */
CSSM_RETURN cdsaVerify(
	CSSM_CSP_HANDLE		cspHandle,		// from cdsaCspAttach()
	const CSSM_KEY		*key,			// from cdsaDeriveKey()
	CSSM_ALGORITHMS		sigAlg,			// e.g., CSSM_ALGID_SHA1WithRSA
	const CSSM_DATA		*dataToSign,
	const CSSM_DATA		*signature)
{
	CSSM_CC_HANDLE	sigHand;
	CSSM_RETURN		crtn;
	
	crtn = CSSM_CSP_CreateSignatureContext(cspHandle,
		sigAlg,
		NULL,				// passPhrase
		key,
		&sigHand);
	if(crtn) {
		return crtn;
	}
	crtn = CSSM_VerifyData(sigHand,
		dataToSign,
		1,
		CSSM_ALGID_NONE,
		signature);
	CSSM_DeleteContext(sigHand);
	return crtn;
}
	
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
	CSSM_CC_HANDLE		*ccHandle)		// RETURNED
{
	CSSM_CC_HANDLE	sigHand;
	CSSM_RETURN		crtn;

	/* Create a signature context */
	crtn = CSSM_CSP_CreateSignatureContext(cspHandle,
		sigAlg,
		NULL,				// passPhrase
		key,
		&sigHand);
	if(crtn) {
		return crtn;
	}
	
	/* init */
	switch(opType) {
		case SO_Sign:
			crtn = CSSM_SignDataInit(sigHand);
			break;
		case SO_Verify:
			crtn = CSSM_VerifyDataInit(sigHand);
			break;
		default:
			return CSSMERR_CSP_FUNCTION_NOT_IMPLEMENTED;
	}
	if(crtn) {
		CSSM_DeleteContext(sigHand);
	}
	else {
		*ccHandle = sigHand;
	}
	return CSSM_OK;
}

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
	CSSM_DATA_PTR		signature)		// non-NULL on final call only
{
	CSSM_RETURN 	crtn = CSSM_OK;
	
	/* 1. Any more data to sign? */
	if(dataToSign && dataToSign->Length) {
		crtn = CSSM_SignDataUpdate(ccHandle, dataToSign, 1);
	}
	
	/* 2. Last call? */
	if(signature && (crtn == CSSM_OK)) {
		signature->Length = 0;
		signature->Data = NULL;
		crtn = CSSM_SignDataFinal(ccHandle, signature);
	}

	/* 3. Delete the context if we're done */
	if(signature) {
		CSSM_DeleteContext(ccHandle);
	}
	return crtn;
}

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
	const CSSM_DATA		*signature)		// non-NULL on final call only
{
	CSSM_RETURN 	crtn = CSSM_OK;
	
	/* 1. any more data to verify? */
	if(dataToVerify && dataToVerify->Length) {
		crtn = CSSM_VerifyDataUpdate(ccHandle, dataToVerify, 1);
	}
	
	/* 2. Last call? */
	if(signature && (crtn == CSSM_OK)) {
		crtn = CSSM_VerifyDataFinal(ccHandle, signature);
	}

	/* 3. Delete the context if we're done */
	if(signature) {
		CSSM_DeleteContext(ccHandle);
	}
	return crtn;
}

