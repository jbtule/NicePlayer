/**
 * OverlaysControl.m
 * NicePlayer
 *
 * The class that determines which overlays should be showing in which window.
 */

#import "OverlaysControl.h"

static id overlayControl = nil;

@implementation OverlaysControl

+(id)control
{
	static BOOL tooLate = NO;
	
    if ( !tooLate ) {
        overlayControl = [OverlaysControl new];
        tooLate = YES;
    }
	
	return overlayControl;
}

-(id)init
{
	if(overlayControl)
		return overlayControl;
	
	if(self = [super init]){
		windows = [[NSMutableSet set] retain];

	}
	
	return self;
}

-(void)dealloc
{
	[windows release];
}

-(BOOL)isLocation:(NSPoint)aScreenPoint inWindow:(id)aWindow
{
	return NSMouseInRect(aScreenPoint, [aWindow frame], NO);
}

-(BOOL)inControlRegion:(NSPoint)aScreenPoint forWindow:(id)aWindow
{
    if([aWindow isFullScreen]){
		NSRect mainScreenFrame = [[NSScreen mainScreen] frame];
		return (aScreenPoint.y <= (mainScreenFrame.origin.y + 32)
				&& aScreenPoint.y >= (mainScreenFrame.origin.y)
				&& aScreenPoint.x >= mainScreenFrame.origin.x
				&& aScreenPoint.x <= mainScreenFrame.size.width);
	}

	NSRect windowFrame = [aWindow frame];
	NSRect mainVisibleFrame = [[NSScreen mainScreen] visibleFrame];
	NSRect tempRect = NSMakeRect(windowFrame.origin.x, windowFrame.origin.y, windowFrame.size.width, 32);

	if (mainVisibleFrame.origin.y < windowFrame.origin.y){
            tempRect.origin = NSMakePoint(0, 0);
        } else {
            tempRect.origin = [aWindow convertScreenToBase:NSMakePoint(windowFrame.origin.x, mainVisibleFrame.origin.y)];
        }
		return NSMouseInRect([aWindow convertScreenToBase:aScreenPoint], tempRect, NO);
}

-(BOOL)inTitleRegion:(NSPoint)aScreenPoint forWindow:(id)aWindow
{
    if([aWindow isFullScreen]){
		NSRect mainScreenFrame = [[NSScreen mainScreen] frame];
		return (aScreenPoint.y <= (mainScreenFrame.origin.y + mainScreenFrame.size.height) 
				&& aScreenPoint.y >= (mainScreenFrame.origin.y + mainScreenFrame.size.height - 48) 
				&& aScreenPoint.x >= mainScreenFrame.origin.x
				&& aScreenPoint.x <= mainScreenFrame.size.width);
	}
	
	NSRect windowFrame = [aWindow frame];
	NSRect mainVisibleFrame = [[NSScreen mainScreen] visibleFrame];
	NSRect tempRect = NSMakeRect(windowFrame.origin.x,  windowFrame.origin.y + windowFrame.size.height - 24,
								 windowFrame.size.width, 24);
	
	if ((mainVisibleFrame.origin.y + mainVisibleFrame.size.height) > (windowFrame.origin.y + windowFrame.size.height)){	
		tempRect.origin = NSMakePoint(0, windowFrame.size.height - 24);
	} else {
		tempRect.origin = [aWindow convertScreenToBase:NSMakePoint(windowFrame.origin.x, mainVisibleFrame.origin.y
																+ mainVisibleFrame.size.height - 24)];
	}
	return NSMouseInRect([aWindow convertScreenToBase:aScreenPoint], tempRect, NO);
}

-(void)mouseMovedInScreenPoint:(NSPoint)aScreenPoint
{
	id someWindows = [NSApp orderedWindows];
	id aWindow;
	unsigned i;
	BOOL hitTopMost = NO;

	for(i = 0, aWindow = [someWindows objectAtIndex:i];
		i < [someWindows count]; aWindow = [someWindows objectAtIndex:i++]){
		if([aWindow isKindOfClass:[NiceWindow class]]){
			if((hitTopMost == NO) && [self inControlRegion:aScreenPoint forWindow:aWindow]){
				[aWindow showOverLayWindow];
				hitTopMost = YES;
			} else if((hitTopMost == NO) && [self inTitleRegion:aScreenPoint forWindow:aWindow]){
				[aWindow showOverLayTitle];
				hitTopMost = YES;
			} else {
				if([self isLocation:aScreenPoint inWindow:aWindow]){
					hitTopMost = YES;
				}
				[aWindow hideOverlays];
			}
		}
	}
}


@end
