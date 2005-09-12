//
//  Subtitle.m
//  NicePlayer
//
//  Created by James Tuley on 11/18/04.
//  Copyright 2004 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Subtitle.h"

@implementation Subtitle

-(void)dealloc{
    [theText release];
    free(timeVector);
    [super dealloc];
}

-(id)initWithFile:(id)aPath forMovieSeconds:(float)aSeconds{
    if ((self = [super init])){
            timeOffset = 0;
           intervals =30*aSeconds;
            lastCheck=0;
            timeVector =(uint*) calloc(intervals,sizeof(uint));
            int i;
            NSLog(@"initalize %d %d", intervals,sizeof(uint));
            for(i=0;i<intervals;i++)
                timeVector[i] = 0;
            NSLog(@"Array created");
            NSString* tContents = [NSString stringWithContentsOfFile:aPath];

            NSString* ext= [[aPath pathExtension] lowercaseString];
            if([ext isEqualTo:@"srt"])
                [self _JTparseSubRipFile:tContents];
            else if ([ext isEqualTo:@"sub"])// prolly needs more as some subrips use .sub extension.
                [self _JTMicroDVD:tContents];
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
        [theText addObject:[item substringToIndex:[item length]-1]];
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
        [theText addObject:[item substringToIndex:[item length]-1]];
        int i;
        for(i=start; i<=stop;i++)
            if(i<intervals)
                timeVector[i]=([theText count]-1);
    }
    
}


@end
