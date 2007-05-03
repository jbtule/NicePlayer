/*
 iEatBrainz
 Copyright (c) 2004, James Tuley
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 
 * Neither the name of James Tuley nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */
//
//  NSImage-JTAdditions.m
//  iEatBrainz
//
//  Created by James Tuley on Thu Mar 25 2004.
//  Copyright (c) 2004 James Tuley. All rights reserved.
//

#import "NSImage-JTAdditions.h"
#import "NSImage-JTAdditionsPrivate.h"

@implementation NSImage(JTAdditions)



- (NSImage*) imageByApplyingMask:(NSImage*)aMask invertMask:(BOOL)invert{
    NSImage* maskImage;
    NSBitmapImageRep* maskRep = [NSBitmapImageRep imageRepWithData:[aMask TIFFRepresentation]];
    
    NSBitmapImageRep* transRep=[[[NSBitmapImageRep alloc] initWithBitmapDataPlanes:nil pixelsWide:[maskRep pixelsWide] pixelsHigh:[maskRep pixelsHigh] bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO colorSpaceName:NSDeviceRGBColorSpace bytesPerRow:0 bitsPerPixel:0] autorelease];

    if(![transRep respondsToSelector:@selector(getPixel:atX:y:)]){
        int length = [maskRep pixelsHigh] * [maskRep pixelsWide];
        unsigned char *bytes = [maskRep bitmapData];
        unsigned char*transBytes = [transRep bitmapData];    
        int i,total,sign;
            if (invert){
               total =0;
                sign = 1;
        }else{
            total = 255;
            sign = -1;  
        }
           
           for(i=1;i<length;i++){
               transBytes[i*4-1]=total + (sign)*bytes[i*3-1];//since we are assuming true black and white it doesn't matter which channel is copied.
        }
        
    }else{
        int xi;
        int yi;
        for(xi=0;xi<[transRep pixelsWide];xi++){
            for(yi=0;yi<[transRep pixelsHigh];yi++){
                unsigned int tempArr[4];
                unsigned int maskArr[3];
                [transRep getPixel: tempArr atX:xi y:yi];
                [maskRep getPixel: maskArr atX:xi y:yi];
                if(invert){
                tempArr[3] = maskArr[2];//since we are assuming true black and white it doesn't matter which channel is copied.
                }else{
                    tempArr[3] = 255-maskArr[2];//since we are assuming true black and white it doesn't matter which channel is copied.

                }

                [transRep setPixel:tempArr atX:xi y:yi];
            }
        }
    }
    maskImage = [[[NSImage alloc] init] autorelease];
    [maskImage  addRepresentation:transRep];
    
    [maskImage lockFocus];
    [self drawInRect:NSMakeRect(0,0,[self size].width,[self size].height) fromRect:NSMakeRect(0,0,[maskImage size].width,[maskImage size].height) operation:NSCompositeSourceIn fraction:1.0];
    [maskImage unlockFocus];
    
    return maskImage;
    
    
}



//- (NSImage*) imageByApplyingMask:(NSImage*)aMask invertMask:(BOOL)invert{
//    NSImage* maskImage;
//    NSBitmapImageRep* maskRep = [NSBitmapImageRep imageRepWithData:[aMask TIFFRepresentation]];
//    int length = [maskRep pixelsHigh] * [maskRep pixelsWide];
//    unsigned char *bytes = [maskRep bitmapData];
//    
//    NSBitmapImageRep* transRep=[[[NSBitmapImageRep alloc] initWithBitmapDataPlanes:nil pixelsWide:[maskRep pixelsWide] pixelsHigh:[maskRep pixelsHigh] bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO colorSpaceName:NSDeviceRGBColorSpace bytesPerRow:0 bitsPerPixel:0] autorelease];
//    unsigned char*transBytes = [transRep bitmapData];    
//    int i,total,sign;
//    if (invert){
//        total =0;
//        sign = 1;
//    }else{
//        total = 255;
//        sign = -1;  
//    }
//    
//    for(i=1;i<length;i++){
//        transBytes[i*4-1]=total + (sign)*bytes[i*3-1];//since we are assuming true black and white it doesn't matter which channel is copied.
//    }
//    
//    maskImage = [[[NSImage alloc] init] autorelease];
//    [maskImage  addRepresentation:transRep];
//    
//    [maskImage lockFocus];
//    [self drawInRect:NSMakeRect(0,0,[self size].width,[self size].height) fromRect:NSMakeRect(0,0,[maskImage size].width,[maskImage size].height) operation:NSCompositeSourceIn fraction:1.0];
//    [maskImage unlockFocus];
//    
//    return maskImage;
//    
//    
//}


//yeah this method was added later, the method it calls should disappear, but adding this is a quick refactoring, needs to be changed later.
-(NSImage*)imageCroppedWithGridSquareSize:(NSSize)aSize takingSquareAt:(NSPoint)rowCol{
    int rows = [self size].height/aSize.height;
    int cols = [self size].width/aSize.width;
    
    return [self _JTimageCroppedWithGrid:rows by:cols takingSquareAt:rowCol];
}




@end
