/**
 * NiceScrubber.h
 * NicePlayer
 */

#import <AppKit/AppKit.h>


@interface NiceScrubber : NSControl {
    NSImage* left;
    NSImage* right;
    NSImage* center;
    NSImage* scrubClick;
    NSImage* scrub;
    double value;
    id target;
    SEL action;
    bool dragging;
}

-(BOOL)inUse;

@end
