/**
 * VolumeView.m
 * NicePlayer
 *
 * The view that displays the volume overlay when the volume is adjusted.
 */

#import "VolumeView.h"

@implementation VolumeView

-(id)initWithCoder:(id)aCoder{
    self =[super initWithCoder:aCoder];
    muted = NO;
    volume=1.0;
    return self;
}

-(void)setVolume:(float)aVolume{
    volume = aVolume;
    [self setNeedsDisplay];

}

-(void)setMuted:(BOOL)aBOOL{
    muted = aBOOL;
    if(muted)
        [self setImage:[NSImage imageNamed:@"volume_muted"]];
    else
        [self setImage:[NSImage imageNamed:@"volume_with_sound"]];
    [self setNeedsDisplay];
}

- (void)drawRect:(NSRect)aRect{
    [super drawRect:aRect];   
    if(!muted){
        float hue;
        float top;
        if (volume <=1.0){
            hue =117.0/360.0;
            top =1.0;
        }else{
            hue = 0.0;
            top =2.0;
        }
            
        [[NSColor colorWithDeviceHue:hue
                         saturation:.5
                         brightness:(top/volume)
                              alpha:1.0] set];
        
            NSRectFill(NSMakeRect(20,15,32*volume,8));
    }
    
    
}

@end
