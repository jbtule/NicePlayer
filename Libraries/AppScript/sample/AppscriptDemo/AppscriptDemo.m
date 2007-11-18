#import <Foundation/Foundation.h>
#import "aemexample.h"
#import "appscriptexample.h"

int main(int argc, char *argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSLog(@"\n======================================================================\n\n");
	
	aemExample();
	
	NSLog(@"\n======================================================================\n\n");
	
	appscriptExample();

	NSLog(@"\n======================================================================\n\n");
	
    [pool release];
    return 0;
}