/**
 * BlackWindow.h
 * NicePlayer
 */

#import <AppKit/AppKit.h>
#import "../NiceController.h"
#import "../NiceWindow/NiceWindow.h"

@interface BlackWindow : NSWindow {
    id presentingWindow;
}

-(void)setPresentingWindow:(id)window;

@end
