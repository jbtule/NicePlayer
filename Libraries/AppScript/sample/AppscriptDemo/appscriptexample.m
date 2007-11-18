
#import "appscriptexample.h"

void appscriptExample(void) {

    TEApplication *textedit;
	TEMakeCommand *makeCmd;
	TEGetCommand *getCmd;
	NSError *error;
    id result;
    
    textedit = [[TEApplication alloc]
                 initWithName: @"TextEdit.app"];
    NSLog(@"textedit:\n%@\n\n", textedit);
    
    // tell application "TextEdit" to \
    //     make new document with properties {text:"Hi!"}
    
	NSLog(@"make new document:\n");
    makeCmd = [[[textedit make] new_: [TEConstant document]]
					 withProperties: [NSDictionary dictionaryWithObjectsAndKeys:
											@"Hi 2!", [TEConstant text], nil]];
	result = [makeCmd sendWithError: &error];
    if (result) 
        NSLog(@"result:\n%@\n\n", result);
    else
        NSLog(@"error:\n%@\n\n", [error description]);

    // tell application "TextEdit" to get text of document 1
	
	NSLog(@"get text of document 1:\n");
    getCmd = [[[[textedit documents] at: 1] text] get];
	result = [getCmd sendWithError: &error];
    if (result) 
        NSLog(@"result:\n%@\n\n", result);
    else
        NSLog(@"error:\n%@\n\n", error);

    // tell application "TextEdit" to get document 100
	
	NSLog(@"get document 100:\n");
    getCmd = [[[[textedit documents] at: 100] text] get];
	result = [getCmd sendWithError: &error];
    if (result) 
        NSLog(@"result:\n%@\n\n", result);
    else
        NSLog(@"error:\n%@\n\n", error);
	
    // tell application "TextEdit" to get every document

	NSLog(@"get every document:\n");
    getCmd = [[textedit documents] get];
	result = [getCmd sendWithError: &error];
    if (result) 
        NSLog(@"result:\n%@\n\n", result);
    else
        NSLog(@"error:\n%@\n\n", error);

    [textedit release];

}