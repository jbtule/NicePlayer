//
//  NiceDrawer.m
//  NicePlayer
//
//  Created by Robert Chin on 2/10/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "NiceDrawer.h"

/*************************
Drawers are evil private children, and aren't like normal children thus
they need there own private methods, 
and they ignore thier public  ones they inherited from their super.
**************************/
@interface NSDrawerWindow : NSWindow 
    -(NSWindow*)_parentWindow;
@end

@implementation NiceDrawer

- (void)mouseMoved:(NSEvent *)anEvent
{
	id theWindow = [(NSDrawerWindow*)[self window] _parentWindow];
	// create new event with useful window, location and event values
	unsigned int flags = [anEvent modifierFlags];
	NSTimeInterval timestamp = [anEvent timestamp];
	int windowNumber = [theWindow windowNumber];
	NSGraphicsContext *context = [anEvent context];
	// original event is not a mouse down event so the following values	are missing
	int eventNumber = 0; // [anEvent eventNumber]
	int clickCount = 0; // [anEvent clickCount]
	float pressure = 1.0; // [anEvent pressure]
	NSEvent *newEvent = [NSEvent mouseEventWithType:[anEvent type]
										   location:[theWindow mouseLocationOutsideOfEventStream]
									  modifierFlags:flags
										  timestamp:timestamp
									   windowNumber:windowNumber
											context:context
										eventNumber:eventNumber
										 clickCount:clickCount
										   pressure:pressure];
	
	[theWindow mouseMoved:newEvent];
}


@end
