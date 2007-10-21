//
//  Subtitle.m
//  NicePlayer
//
//  Created by James Tuley on 11/18/04.
//  Copyright 2004 __MyCompanyName__. All rights reserved.
//


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
* The Original Code is NicePlayer.
*
* The Initial Developer of the Original Code is
* James Tuley & Robert Chin.
* Portions created by the Initial Developer are Copyright (C) 2004-2005
* the Initial Developer. All Rights Reserved.
*
* Contributor(s):
*           Robert Chin <robert@osiris.laya.com> (NicePlayer Author)
*           James Tuley <jay+nicesource@tuley.name> (NicePlayer Author)
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



#import <Cocoa/Cocoa.h>
#import "Subtitle.h"
#import <UniversalCharsetDetector/NSString+UniversalCharsetDetector.h>

@interface Subtitle(private)
-(void)_JTmeasureWidth:(NSString*)aString;
-(void)_JTparseSubRipFile:(NSString*)aContents;
-(void)_JTMicroDVD:(NSString*)aContents;
-(void)_JTparseSubStationAlpha:(NSString*)aContents;
@end

@implementation Subtitle

-(void)dealloc{
    [theText release];
    [thePath release];
    free(timeVector);
    [super dealloc];
}

-(NSString*)path{
    
    return thePath;
    
}

-(id)initWithFile:(id)aPath forMovieSeconds:(float)aSeconds{
    if ((self = [super init])){
	
                        thePath = aPath;
                        [thePath retain];
            timeOffset = 0;
           intervals =30*aSeconds;
            lastCheck=0;
            timeVector =(uint*) calloc(intervals,sizeof(uint));
            int i;
         //   NSLog(@"initalize %d %d", intervals,sizeof(uint));
            for(i=0;i<intervals;i++)
                timeVector[i] = 0;
      //NSLog(@"Array created");
			NSStringEncoding tCoding = NSUTF8StringEncoding;
			
			
			NSError* tError; 
            NSString* tContents = [NSString stringWithContentsOfFileDetectingCharset:aPath usedEncoding:&tCoding error:&tError];

			NSLog(@"Encoding %d",tCoding);
			NSLog(@"Encoding %@",tError);

			
            NSString* ext= [[aPath pathExtension] lowercaseString];
			@try{
            if([ext isEqualTo:@"srt"])
                [self _JTparseSubRipFile:tContents];
            else if ([ext isEqualTo:@"sub"])// prolly needs more as some subrips use .sub extension.
                [self _JTMicroDVD:tContents];
			else if ([ext isEqualTo:@"ssa"])
                [self _JTparseSubStationAlpha:tContents];
			}
			@catch (id all){
				[self autorelease];
				return nil;
				}
    } return self;
}

-(void)_JTparseSubRipFile:(NSString*)aContents{
    NSString* lineEnding = [self lineEndingTypeForFileContents:aContents];
    NSScanner* tScanner = [NSScanner scannerWithString:aContents];
    theText = [[NSMutableArray alloc]init];
    [theText addObject:@""];
    while(![tScanner isAtEnd]){
        int num =0;
        float start=0;
        float stop =0;
        if(![tScanner scanInt:&num])
            break;
        NSString* tString = nil;
        //scan Start Time
       
        if(![tScanner scanUpToString:@":" intoString:&tString])
            break;
        start += [tString intValue]*60*60*30;
        if(![tScanner scanString:@":" intoString:nil])
            break;
        
        [tScanner scanUpToString:@":" intoString:&tString];
            start += [tString intValue]*60*30;
        [tScanner scanString:@":" intoString:nil];
        
        [tScanner scanUpToString:@"," intoString:&tString];
            start += [tString intValue]*30;
        [tScanner scanString:@"," intoString:nil];
        
        [tScanner scanUpToString:@"-->" intoString:&tString];
            start +=30* [tString floatValue]/1000.0;
        [tScanner scanString:@"-->" intoString:nil];
        
        //scan stop Time
        
        [tScanner scanUpToString:@":" intoString:&tString];
            stop += [tString intValue]*60*60*30;
        [tScanner scanString:@":" intoString:nil];
        
        [tScanner scanUpToString:@":" intoString:&tString];
            stop += [tString intValue]*60*30;
        [tScanner scanString:@":" intoString:nil];
        
        [tScanner scanUpToString:@"," intoString:&tString];
            stop += [tString intValue]*30;
        [tScanner scanString:@"," intoString:nil];
        
        [tScanner scanUpToString:lineEnding intoString:&tString];
            stop +=30.0* [tString floatValue]/1000.0;
        [tScanner scanString:lineEnding intoString:nil];
        NSString* item =@"";
        [tScanner scanUpToString:lineEnding intoString:&tString];
        
        //Subtitles have at most two lines.
        item=[item stringByAppendingString:tString];
        [tScanner scanString:lineEnding intoString:nil];
        
        uint tLocation = [tScanner scanLocation];
        [tScanner scanUpToString:lineEnding intoString:&tString];
        if([tString intValue]!=num+1){
            item=[item stringByAppendingString:@"\n"];
            item=[item stringByAppendingString:tString];
        }else{
            [tScanner setScanLocation:tLocation];
        }
            
        //remove final carrage return before adding to array
		NSString* tFinalString =[item substringToIndex:[item length]-1];
		[self _JTmeasureWidth:tFinalString];
        [theText addObject:tFinalString];
        int i;
        for(i=start; i<=stop;i++)
            if(i<intervals)
                timeVector[i]=([theText count]-1);
        
    }
    
    
}

//modified from code posted on cocoadev mailinglist
- (NSString*)lineEndingTypeForFileContents:(NSString *)fileContents{
    
    /* Is this a DOS format? */
    NSRange dosRange = [fileContents rangeOfString:@"\r\n"];
    if (dosRange.location != NSNotFound) return @"\r\n";
    
    /* Not DOS; is this the Mac format? */
    NSRange macRange = [fileContents rangeOfString:@"\r"];
    if (macRange.location != NSNotFound) return @"\r";
    
    /* Neither DOS nor Mac, so return Unix */
    return @"\n";
    
}


- (NSString*)lineEndingTypeForFile:(NSString *)path
{
    NSString *fileContents = [NSString stringWithContentsOfFile:path];
    
    return [self lineEndingTypeForFileContents:fileContents];

}

-(BOOL)checkForChangeWithTime:(float)aTime{
    int tInt = (aTime-timeOffset)*30;
    if(0 <= tInt && tInt < intervals)
        return (!(timeVector[tInt]==lastCheck));
    return NO;
}

-(void)setOffsetSeconds:(float)aSeconds{
    timeOffset=aSeconds;
}

-(NSString*)stringForTime:(float)aTime{
    int tInt = (aTime-timeOffset)*30;
    if(0 <= tInt && tInt < intervals){
        lastCheck =timeVector[tInt];
    }
    return [theText objectAtIndex:lastCheck];
}


-(NSString*)longestText{
	return theLongestLine;
}


-(void)_JTmeasureWidth:(NSString*)aString{
	NSAttributedString* tString = [[NSAttributedString alloc]initWithString:aString];
	if(theLongestLength < [tString size].width){
		theLongestLength = [tString size].width;
		theLongestLine = aString;
	}
	[tString release];
}


-(uint)_uintArrayForTime:(int)aTime{// for peeking with fscript
    int tInt = aTime*30;
    return timeVector[tInt];
}

-(id)_textArray{//to peek at in fscript
    return theText;   
}

-(void)_JTMicroDVD:(NSString*)aContents{
    NSString* lineEnding = [self lineEndingTypeForFileContents:aContents];
    NSScanner* tScanner = [NSScanner scannerWithString:aContents];
    theText = [[NSMutableArray alloc]init];
    [theText addObject:@""];
    float frameRate=30;
    
    //Special type of MicroDVD with the framerate specified first preceded with {1}{1}
    [tScanner scanString:@"{1}{1}" intoString:nil];
    [tScanner scanFloat:&frameRate];
    NSLog(@"start");
    while(![tScanner isAtEnd]){
        float start=0;
        float stop =0;
        //scan Start Time
        float tFloat = 0;
        [tScanner scanString:@"{" intoString:nil];
        [tScanner scanFloat:&tFloat];
        start += 30*tFloat/frameRate;
        [tScanner scanString:@"}{" intoString:nil];
        [tScanner scanFloat:&tFloat];
        stop += 30*tFloat/frameRate;
        [tScanner scanString:@"}" intoString:nil];
        NSMutableString* item =nil;       
        [tScanner scanUpToString:lineEnding intoString:&item];
        item = [[item mutableCopy] autorelease];
        [item replaceOccurrencesOfString:@"|" withString:@"\n" options:NSLiteralSearch range: NSMakeRange(0, [item length])];
        //remove final carrage return before adding to array
		NSString* tFinalString =[item substringToIndex:[item length]-1];

		[self _JTmeasureWidth:tFinalString];
        [theText addObject:tFinalString];
        int i;
        for(i=start; i<=stop;i++)
            if(i<intervals)
                timeVector[i]=([theText count]-1);
    }
}

	
-(void)_JTparseSubStationAlpha:(NSString*)aContents{
   NSString* lineEnding = [self lineEndingTypeForFileContents:aContents];
   
   
    NSScanner* tScanner = [NSScanner scannerWithString:aContents];
	[tScanner scanUpToString:@"[Events]" intoString:nil];
	[tScanner scanUpToString:@"Format:" intoString:nil];
	[tScanner scanString:@"Format:" intoString:nil];
	NSString* tFormat= nil;
	[tScanner scanUpToString:lineEnding intoString:&tFormat];
	[tScanner scanString:lineEnding intoString:nil];

	NSArray* tFormatArray = [tFormat componentsSeparatedByString:@", "];
	
	
	unsigned tStartIndex = [tFormatArray indexOfObject:@"Start"];
	unsigned tEndIndex = [tFormatArray indexOfObject:@"End"];
	unsigned tTextIndex = [tFormatArray indexOfObject:@"Text"];
//	NSLog(@"start %d end %d text %d",tStartIndex,tEndIndex,tTextIndex);


    theText = [[NSMutableArray alloc]init];
    [theText addObject:@""];
    while(![tScanner isAtEnd]){
		NSString* tDialog= nil;
		[tScanner scanString:@"Dialogue:" intoString:nil];
		[tScanner scanUpToString:lineEnding intoString:&tDialog];
		[tScanner scanString:lineEnding intoString:nil];

		NSArray* tDialogArray = [tDialog componentsSeparatedByString:@","];
		
		int tCount =[tDialogArray count] - [tFormatArray count];
		if(tCount > 0){
			NSString * tText =@"";
			for(int i = tCount;  i > 0; i--){
				tText = [tText stringByAppendingString:@","];		
				tText =[tText stringByAppendingString:[tDialogArray objectAtIndex:[tDialogArray count] -i]];
			}
			
			NSMutableArray* tMArray =[[tDialogArray mutableCopy]autorelease];
			for(int j =0; j < tCount;j++){
				[tMArray removeLastObject];
			}
			tText = [[tMArray lastObject] stringByAppendingString:tText];
			[tMArray removeLastObject];

			[tMArray addObject:tText];
			tDialogArray =tMArray;
		}
		
	//	NSLog(@"dialog %d %@ %@",[tDialogArray count],tDialogArray,tDialog);

		
		NSString* tStartTime = [tDialogArray objectAtIndex:tStartIndex];
		NSString* tEndTime = [tDialogArray objectAtIndex:tEndIndex];
		NSString* tText = [tDialogArray objectAtIndex:tTextIndex];

        float start=0;
        float stop =0;
		NSArray* tTimeArray =[tStartTime componentsSeparatedByString:@":"];
        //scan Start Time
       
	 //  		NSLog(@"start %d %@",[tTimeArray count],tTimeArray);

	   
        start += [[tTimeArray objectAtIndex:0] intValue]*60*60*30;
		start += [[tTimeArray objectAtIndex:1] intValue]*60*30;        
		start += [[tTimeArray objectAtIndex:2] floatValue]*30;
        
        //scan stop Time
        
		tTimeArray =[tEndTime componentsSeparatedByString:@":"];
	 //  		NSLog(@"end %d %@",[tTimeArray count],tTimeArray);

        stop += [[tTimeArray objectAtIndex:0] intValue]*60*60*30;
		stop += [[tTimeArray objectAtIndex:1] intValue]*60*30;
		stop += [[tTimeArray objectAtIndex:2] floatValue]*30;
           
	
		NSMutableString* tFinalString = [[tText mutableCopy] autorelease];
		[tFinalString replaceOccurrencesOfString:@"\\n" withString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tFinalString length])];		
		
		[self _JTmeasureWidth:tFinalString];
        [theText addObject:tFinalString];
        int i;
        for(i=start; i<=stop;i++)
            if(i<intervals)
                timeVector[i]=([theText count]-1);
        
    }
    
}


@end
