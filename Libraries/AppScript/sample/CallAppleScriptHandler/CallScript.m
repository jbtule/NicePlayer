/*
 * Simple demonstration of calling an AppleScript handler (in this case
 * an 'joinText' subroutine) via NSAppleScript -executeAppleEvent:error:
 * using objc-appscript (specifically its aem API) to create and pack the
 * the Apple event and unpack the script result.
 *
 * (Note: error handling is omitted for simplicity.)
 */

#import <Foundation/Foundation.h>
#import "Appscript/Appscript.h"

int main (int argc, const char * argv[]) {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	// Create AEMApplication object for building AEMEvents
	AEMApplication *app = [[AEMApplication alloc] init];

	// Create AEMCodecs object for unpacking script results
	AEMCodecs *codecs = [[AEMCodecs alloc] init];

	// Build parameter list for script
	NSArray *params = [NSArray arrayWithObjects:@"Hello ", @"World!", nil];

	// Create 'ascrpsbr' (AppleScript subroutine) AEMEvent
	AEMEvent *evt = [app eventWithEventClass:kASAppleScriptSuite
									 eventID:kASSubroutineEvent];

	// Add subroutine name
	// (Note: unless enclosed in pipes, subroutine names are 
	// case-insensitive and should be all lowercase , e.g.:
	// 'FooBar' -> @"foobar", '|FooBar|' -> @"FooBar")
	[evt setParameter:@"jointext" forKeyword:keyASSubroutineName];

	// Add parameter list to AEMEvent
	[evt setParameter:params forKeyword:keyDirectObject];

	// Get an NSAppleEventDescriptor from AEMEvent
	NSAppleEventDescriptor *evtDesc = [evt appleEventDescriptor];

	// Compile (or load) the AppleScript
	NSAppleScript *scpt = [[NSAppleScript alloc] initWithSource:
			@"on joinText(arg1, arg2)\n"
			@"	return arg1 & arg2\n"
			@"end joinText"];

	// Send event to AppleScript
	NSDictionary *error;
	NSAppleEventDescriptor *resDesc = [scpt executeAppleEvent:evtDesc error:&error];

	// Unpack script result
	id res = [codecs unpack:resDesc];
	NSLog(@"Result = %@", res); // Result = 3

	[scpt release];
	[codecs release];
	[app release];
	[pool release];
	return 0;
}
