/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
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
* The Original Code is Mozilla Communicator client code.
*
* The Initial Developer of the Original Code is
* Netscape Communications Corporation.
* Portions created by the Initial Developer are Copyright (C) 1998
* the Initial Developer. All Rights Reserved.
*
* Contributor(s):
*          Roine Gustafsson <roine @ mirailabs.com>
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

// A straight-forward wrapper/port of the unversalchardet's test code to 
// Objective C, with mappings to Foundation's NSStringEncodings

// This is an unfinished port; there is a richer feedbased API available 
// which is not currently used. Feel free to add this functionality.

#import "UniversalCharsetDetector.h"
#import <CoreFoundation/CoreFoundation.h>

#include "nscore.h"
#include "nsUniversalDetector.h"

class nsUniversalStringDetector: public nsUniversalDetector
{
public:
    nsUniversalStringDetector() { mResult = NULL; };
    virtual ~nsUniversalStringDetector() { };
    int DoIt(const char* aBuf, PRUint32 aLen, const char** oCharset);
protected:
	virtual void Report(const char* aCharset);
private:
	const char* mResult;
};

void nsUniversalStringDetector::Report(const char *aCharset)
{
    mResult = aCharset;
}

int nsUniversalStringDetector::DoIt(const char* aBuf,PRUint32 aLen, const char** oCharset)
{
    mResult = nsnull;
    this->Reset();
    nsresult rv = this->HandleData(aBuf, aLen);
    if (NS_FAILED(rv))
        return rv;
    this->DataEnd();
    if (mResult)
        *oCharset=mResult;
	
    return NS_OK;
}

@implementation UniversalCharsetDetector

+ (NSStringEncoding)detectWithData:(NSData*)data
{
	// Not optimal; [data bytes] will cause the entire data to be made available. Bad if it's a gigabyte file.
	// Should use the incremental API instead
	return [UniversalCharsetDetector detectWithBuffer:(const char*)[data bytes] length:[data length]];
}


+ (NSStringEncoding)detectWithBuffer:(const char*)buf length:(int)len
{
    nsUniversalStringDetector* mCharDet = new nsUniversalStringDetector;
    const char* charset = NULL;
    int i;
	
	// This is a mapping between the universalchardet name and the Apple codes.
	// This can almost be automated with CFStringConvertIANACharSetNameToEncoding,
	// but there were too many mismatches so we've kept the translation table. The API is used
	// as a fallback in case universalchardet code gets extended and this doesn't, or something.
	
	struct {const char* name; NSStringEncoding encoding;} foundation[] = {
	   { "EUCJP", 			NSJapaneseEUCStringEncoding },     
	   { "EUC-JP", 			NSJapaneseEUCStringEncoding },     
	   { "ISO-2022-JP", 	NSISO2022JPStringEncoding },
	   { "ISO-8859-2", 		NSISOLatin2StringEncoding },
	   { "UTF-8", 			NSUTF8StringEncoding }, 
	   { "UTF8", 			NSUTF8StringEncoding },
	   { "windows-1250",	NSWindowsCP1250StringEncoding },
	   { "windows-1251",	NSWindowsCP1251StringEncoding },
	   { "windows-1252",	NSWindowsCP1252StringEncoding },
	   { "windows-1253",	NSWindowsCP1253StringEncoding },
	   { NULL, 0 }};
	   
	struct {const char* name; CFStringEncoding encoding;} corefoundation[] = {
	   { "Big5", 			kCFStringEncodingBig5 },
	   { "GB18030", 		kCFStringEncodingGB_18030_2000 }, 
	   { "gb18030", 		kCFStringEncodingGB_18030_2000 }, 
	   { "GB2312", 			kCFStringEncodingGB_2312_80 },
	   { "EUC-KR", 			kCFStringEncodingEUC_KR },
	   { "EUCKR", 			kCFStringEncodingEUC_KR },
	   { "x-euc-tw", 		kCFStringEncodingEUC_TW },
	   { "EUCTW", 			kCFStringEncodingEUC_TW },
	   { "HZ-GB-2312", 		kCFStringEncodingHZ_GB_2312 }, 
	   { "x-mac-cyrillic", 	kCFStringEncodingMacCyrillic }, 
	   { "KOI8-R", 			kCFStringEncodingKOI8_R },
	   { "ISO-2022-CN", 	kCFStringEncodingISO_2022_CN },
	   { "ISO-2022-KR", 	kCFStringEncodingISO_2022_KR },
	   { "ISO-8859-5", 		kCFStringEncodingISOLatinCyrillic },
	   { "ISO-8859-7", 		kCFStringEncodingISOLatinGreek },
	   { "ISO-8859-8", 		kCFStringEncodingISOLatinHebrew },
	   { "ISO-8859-8-I", 	kCFStringEncodingISOLatinHebrew },
	   { "TIS-620", 		kCFStringEncodingDOSThai },
	   { "windows-1255", 	kCFStringEncodingWindowsHebrew },
	   { "x-mac-hebrew", 	kCFStringEncodingMacHebrew },
	   { "Shift_JIS", 		kCFStringEncodingShiftJIS },
	   { "SJIS", 			kCFStringEncodingShiftJIS },
	   { "IBM855", 			kCFStringEncodingDOSCyrillic },			// CFStringConvertIANACharSetNameToEncoding fails on this
	   { "IBM866", 			kCFStringEncodingDOSRussian },
	   { "UTF-16BE",		kCFStringEncodingUTF16BE },
	   { "UTF-16LE",		kCFStringEncodingUTF16LE },
	   { "UTF-32BE",		kCFStringEncodingUTF32BE },
	   { "UTF-32LE",		kCFStringEncodingUTF32LE },
	   { "X-ISO-10646-UCS-4-2143", kCFStringEncodingUTF32 },
	   { "X-ISO-10646-UCS-4-3412", kCFStringEncodingUTF32 },
	   { NULL, 0 }};
	   
    if (mCharDet->DoIt(buf,len,&charset) != NS_OK || !charset)
		return 0;	// Unknown or error

	// Check for native Foundation string encodings
	for (i=0;foundation[i].name; i++)
		if (strcmp(charset,foundation[i].name) == 0)
			return foundation[i].encoding;

	// Check for CoreFoundation string encodings
	for (i=0;corefoundation[i].name; i++)
		if (strcmp(charset,corefoundation[i].name) == 0)
			return CFStringConvertEncodingToNSStringEncoding(corefoundation[i].encoding);

	// Try to interpret the encoding with CFStringConvertIANACharSetNameToEncoding
	CFStringEncoding cfencoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)[NSString stringWithUTF8String:charset]);
	if (cfencoding != kCFStringEncodingInvalidId)
		return CFStringConvertEncodingToNSStringEncoding(cfencoding);

	
	// Only reached if universalchardet returns something we can't interpret

    return 0;
}

@end
