/**
 * NPPluginView.h
 * NicePlayer
 */

#import <Cocoa/Cocoa.h>

enum play_states { STATE_INACTIVE, STATE_STOPPED, STATE_PLAYING };

@interface NPPluginView : NSView
{
	enum play_states oldPlayState;
}

+(BOOL)hasConfigurableNib;
+(id)configureNibView;

-(NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender;
-(NSDragOperation)draggingUpdated:(id)sender;
-(BOOL)prepareForDragOperation:(id)sender;
-(BOOL)performDragOperation:(id <NSDraggingInfo>)sender;
-(void)concludeDragOperation:(id <NSDraggingInfo>)sender;

-(void)ffStart:(int)seconds;
-(void)ffEnd;
-(void)rrStart:(int)seconds;
-(void)rrEnd;

@end
