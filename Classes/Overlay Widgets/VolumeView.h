/**
 * VolumeView.h
 * NicePlayer
 */

#import <Cocoa/Cocoa.h>

@interface VolumeView : NSImageView
{
    BOOL muted;
    float volume;
}
@end
