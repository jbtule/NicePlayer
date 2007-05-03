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
* The Original Code is CocoaScriptMenu.
*
* The Initial Developer of the Original Code is
* James Tuley.
* Portions created by the Initial Developer are Copyright (C) 2004-2005
* the Initial Developer. All Rights Reserved.
*
* Contributor(s):
*           James Tuley <jay+csm@tuley.name> (Original Author)
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
//  CSMMenuNameParser.m
//  CocoaScriptMenu
//
//  Created by James Tuley on 10/1/05.
//  Copyright 2005 James Tuley. All rights reserved.
//

#import "CSMMenuNameParser.h"

@interface CSMMenuNameParser(Protected)
-(BOOL)CSM_scanName:(NSScanner*) aScanner;
-(BOOL)CSM_scanEquivalent:(NSScanner*) aScanner;
@end

@implementation CSMMenuNameParser

-(id)initWithPath:(NSString*) aPath{
    if(self = [super init]){
        theModifier = 0;
        theKeyEquivalent = @"";
        theMenuName = @"";
        thePrefix =@"";
        NSString* tParseString = [aPath stringByStandardizingPath];
        tParseString = [tParseString lastPathComponent];
        
        if([tParseString length] > 2){
            if([[NSCharacterSet decimalDigitCharacterSet] isSupersetOfSet:
                [NSCharacterSet characterSetWithCharactersInString:[tParseString substringToIndex:2]]]){
                thePrefix = [tParseString substringToIndex:2];
                tParseString = [tParseString substringFromIndex:2];
            }
        }
            
        NSScanner* tScanner = [NSScanner scannerWithString:tParseString];
        [tScanner setCharactersToBeSkipped:nil]; 

        if([self CSM_scanName:tScanner]){
            if([self CSM_scanEquivalent:tScanner]){
                if(![tScanner isAtEnd]){
                    theMenuName = [theMenuName stringByAppendingString:[tParseString substringFromIndex:[tScanner scanLocation]]];
                }
            }else{
                theMenuName = tParseString;
                theKeyEquivalent = @"";
                theModifier =0;
            }
            
        }
        
        
        theMenuName = [theMenuName stringByDeletingPathExtension];
        
        [theMenuName retain];
        [thePrefix retain];
        [theKeyEquivalent retain];
    }return self;
}

//Scan menu name
-(BOOL)CSM_scanName:(NSScanner*) aScanner{
    NSCharacterSet* tStart = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"{%C",0x2045,nil]];
    if([aScanner scanUpToCharactersFromSet:tStart intoString:&theMenuName] && ![aScanner isAtEnd])
        [aScanner scanCharactersFromSet:tStart intoString:nil];
    return ![aScanner isAtEnd];
}

//Scan keyboard equivalent
-(BOOL)CSM_scanEquivalent:(NSScanner*) aScanner{
    
    
    //Scan modifiers
    NSCharacterSet* tModifiers = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"*^%%$%C%C%C%C",0x2318,0x2303,0x21E7,0x2325,nil]];
    NSString* tModString = nil;
    if([aScanner scanCharactersFromSet:tModifiers intoString:&tModString]){
        int i;
        for(i =0; i <[tModString length];i++){
            unichar tChar = [tModString characterAtIndex:i];
            
            switch(tChar){
                case '*':
                case 0x2318:
                    theModifier |= NSCommandKeyMask;
                    break;
                case '$':
                case 0x21E7:
                    theModifier |= NSShiftKeyMask;
                    break;
                case '%':
                case 0x2325:
                    theModifier |= NSAlternateKeyMask;
                    break;
                case '^':
                case 0x2303: 
                    theModifier |= NSControlKeyMask;
                    break;       
            }
            
        }
        
    }
    
    if([aScanner isAtEnd]) return NO;
    
    
    //scan shortcut key
    NSCharacterSet* tEnd = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"}%C",0x2046,nil]];
    
    NSString* tKeyEquivString= nil;
    if([aScanner scanUpToCharactersFromSet:tEnd intoString:&tKeyEquivString]){
        if([tKeyEquivString length] > 1) {
            if([[[tKeyEquivString substringToIndex:1] uppercaseString] isEqualToString:@"F"]  
               && [tKeyEquivString length] < 4){
                 int tFValue = [[tKeyEquivString substringFromIndex:1] intValue] -1;
                theKeyEquivalent = [NSString stringWithFormat:@"%C", NSF1FunctionKey + tFValue];
            }else{
                return NO;
            }
            
            
        }else{
            theKeyEquivalent = [tKeyEquivString lowercaseString];
        }
        
    }else{
        return NO;
    }
    
    [aScanner scanCharactersFromSet:tEnd intoString:nil];
    
    return YES;
    
    
    
}

-(void)dealloc{
    [theKeyEquivalent release];
    [thePrefix release];
    [theMenuName release];
    [super dealloc];
}

-(NSString*)keyEquivalent{
    return theKeyEquivalent;
}

-(unsigned int)keyEquivalentModifiers{
    return theModifier;
}

-(NSString*)name{
    return [theMenuName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

-(NSString*)sortName{
    return [thePrefix stringByAppendingString:[self name]];
}



@end
