/**
 * NPApplication.m
 * NicePlayer
 *
 * The application subclass that allows for us to detect mouse movement when the application
 * is not in focus, allowing us to show and hide movie controls even when other apps are
 * active.
 */

#import "NPApplication.h"

@implementation NPApplication

- (void)finishLaunching
{
	[super finishLaunching];
	lastPoint = [NSEvent mouseLocation];
	inactiveTimer = nil;
	[self setDelegate:self];
        
	[NSApp checkForUpdates:nil];            
}

/**
 * This method tests to see if the mouse has moved to a different location. If so, inject the event into
 * our applications loop in order to determine of the mouse is in a place where the controls should appear
 * for the movie controller or title bar.
 */
-(void)testCursorMovement
{
	if(!NSEqualPoints(lastPoint, [NSEvent mouseLocation])){
		lastPoint = [NSEvent mouseLocation];
		NSEvent *newEvent = [NSEvent mouseEventWithType:NSMouseMoved
											   location:lastPoint
										  modifierFlags:0
											  timestamp:0
										   windowNumber:0
												context:nil
											eventNumber:0
											 clickCount:0
											   pressure:1.0];
		[self sendEvent:newEvent];
	}
}

/* Ripped from http://www.cocoabuilder.com/archive/message/cocoa/2004/9/1/116398 */

- (void)sendEvent:(NSEvent *)anEvent
{
	// catch first right mouse click, activate app
	// and hand the event on to the window for further processing
	BOOL done = NO;
	NSPoint locationInWindow;
	NSWindow *theWindow;
	NSView *theView = nil;
	if (![self isActive]) {
		//NSLog(@"a: event type: %i", [anEvent type]);
		// we do NOT get an NSRightMouseDown event
		if(([anEvent type] == NSRightMouseUp) || ([anEvent type] == NSMouseMoved)){
			// there seems to be no window assigned with this event at the moment;
			// but just in case ...
			if (theWindow = [anEvent window]) {
				theView = [[theWindow contentView] hitTest:[anEvent
					locationInWindow]];
				locationInWindow = [anEvent locationInWindow];
			} else {
				// find window
				NSEnumerator *enumerator = [[self orderedWindows] objectEnumerator];
				while (theWindow = [enumerator nextObject]) {
					locationInWindow = [theWindow mouseLocationOutsideOfEventStream];
					NSView *contentView = [theWindow contentView];
					theView = [contentView hitTest:locationInWindow];
					if (theView) {
						// we found our view
						//NSLog(@"hit view of class: %@", NSStringFromClass([theView class]));
						break;
					}
				}
			}
			if (theView) {
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
													   location:locationInWindow
												  modifierFlags:flags
													  timestamp:timestamp
												   windowNumber:windowNumber
														context:context
													eventNumber:eventNumber
													 clickCount:clickCount
													   pressure:pressure];
				if ([theView acceptsFirstMouse:newEvent]) {
					// activate app and send event to the window
					//[self activateIgnoringOtherApps:YES];
					[theWindow sendEvent:newEvent];
					done = YES;
				}
			}
		}
	}
	
	if (!done) {
		// we did not catch this one
		[super sendEvent:anEvent];
	}
}

-(void)deactivateTimer
{
	if(inactiveTimer){
		[inactiveTimer invalidate];
		inactiveTimer = nil;
	}
}

-(void)activateTimer
{
	if(!inactiveTimer){
		inactiveTimer = [NSTimer scheduledTimerWithTimeInterval:0.01
														 target:self
													   selector:@selector(testCursorMovement)
													   userInfo:nil
														repeats:YES];
	}
}

#pragma mark -
#pragma mark Delegate Methods

-(void)applicationDidBecomeActive:(NSNotification *)aNotification
{
	[self deactivateTimer];
}

-(void)applicationDidResignActive:(NSNotification *)aNotification
{
	if(![self isHidden])
		[self activateTimer];
}

-(void)applicationDidHide:(NSNotification *)aNotification
{
	[self deactivateTimer];
}

-(void)applicationDidUnhide:(NSNotification *)aNotification
{
	if(![self isActive])
		[self activateTimer];
}

-(void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	if(![self isActive])
		[self activateTimer];
}

-(void)application:(NSApplication *)sender openFiles:(NSArray *)filenames
{
	NSLog(@"%@ open %@", sender, filenames);
    [[NiceController controller] openFiles:filenames];
}

@end
