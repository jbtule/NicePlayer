
#import "aemexample.h"

void aemExample(void) {

    AEMApplication *textedit;
    AEMEvent *evt;
	NSError *error;
    id result;
    
    textedit = [[AEMApplication alloc]
                 initWithPath: @"/Applications/TextEdit.app"];
    NSLog(@"textedit:\n%@\n\n", textedit);
    
    // tell application "TextEdit" to \
    //     make new document with properties {text:"Hi!"}
    
	NSLog(@"make new document:\n");
    evt = [textedit eventWithEventClass: 'core' eventID: 'crel'];
    [evt setParameter: [AEMType typeWithCode: 'docu'] forKeyword: 'kocl'];
    [evt setParameter: [NSDictionary dictionaryWithObjectsAndKeys:
                        @"Hi!", [AEMType typeWithCode: 'ctxt'], nil]
           forKeyword: 'prdt'];
    result = [evt sendWithError: &error];
    if (result) 
        NSLog(@"result:\n%@\n\n", result);
    else
        NSLog(@"error:\n%@\n\n", error);

    // tell application "TextEdit" to get text of document 1
	
	NSLog(@"get text of document 1:\n");
    evt = [textedit eventWithEventClass: 'core' eventID: 'getd'];
    [evt setParameter: [[[AEMApp elements: 'docu'] at: 1] property: 'ctxt']
           forKeyword: keyDirectObject];
    result = [evt sendWithError: &error];
    if (result) 
        NSLog(@"result:\n%@\n\n", result);
    else
        NSLog(@"error:\n%@\n\n", error);

    // tell application "TextEdit" to get document 100
	
	NSLog(@"get document 100:\n");
    evt = [textedit eventWithEventClass: 'core' eventID: 'getd'];
    [evt setParameter: [[AEMApp elements: 'docu'] at: 100] forKeyword: keyDirectObject];
    result = [evt sendWithError: &error];
    if (result) 
        NSLog(@"result:\n%@\n\n", result);
    else
        NSLog(@"error:\n%@\n\n", error);
	
    // tell application "TextEdit" to get every document

	NSLog(@"get every document:\n");
    evt = [textedit eventWithEventClass: 'core' eventID: 'getd'];
    [evt setParameter: [AEMApp elements: 'docu'] forKeyword: keyDirectObject];
    result = [evt sendWithError: &error];
    if (result) 
        NSLog(@"result:\n%@\n\n", result);
    else
        NSLog(@"error:\n%@\n\n", error);

    [textedit release];

}