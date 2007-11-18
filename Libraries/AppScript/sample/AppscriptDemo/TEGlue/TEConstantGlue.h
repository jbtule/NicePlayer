/*
 * TEConstantGlue.h
 *
 * /applications/textedit.app
 * osaglue 0.2.0
 *
 */

#import <Foundation/Foundation.h>


#import "Appscript/Appscript.h"


@interface TEConstant : ASConstant
+ (id)constantWithCode:(OSType)code_;

/* Enumerators */

+ (TEConstant *)ask;
+ (TEConstant *)detailed;
+ (TEConstant *)no;
+ (TEConstant *)standard;
+ (TEConstant *)yes;

/* Types and properties */

+ (TEConstant *)application;
+ (TEConstant *)attachment;
+ (TEConstant *)attributeRun;
+ (TEConstant *)bounds;
+ (TEConstant *)character;
+ (TEConstant *)class_;
+ (TEConstant *)closeable;
+ (TEConstant *)collating;
+ (TEConstant *)color;
+ (TEConstant *)copies;
+ (TEConstant *)document;
+ (TEConstant *)endingPage;
+ (TEConstant *)errorHandling;
+ (TEConstant *)faxNumber;
+ (TEConstant *)fileName;
+ (TEConstant *)floating;
+ (TEConstant *)font;
+ (TEConstant *)frontmost;
+ (TEConstant *)id_;
+ (TEConstant *)index;
+ (TEConstant *)item;
+ (TEConstant *)miniaturizable;
+ (TEConstant *)miniaturized;
+ (TEConstant *)modal;
+ (TEConstant *)modified;
+ (TEConstant *)name;
+ (TEConstant *)pagesAcross;
+ (TEConstant *)pagesDown;
+ (TEConstant *)paragraph;
+ (TEConstant *)path;
+ (TEConstant *)printSettings;
+ (TEConstant *)properties;
+ (TEConstant *)requestedPrintTime;
+ (TEConstant *)resizable;
+ (TEConstant *)size;
+ (TEConstant *)startingPage;
+ (TEConstant *)targetPrinter;
+ (TEConstant *)text;
+ (TEConstant *)titled;
+ (TEConstant *)version_;
+ (TEConstant *)visible;
+ (TEConstant *)window;
+ (TEConstant *)word;
+ (TEConstant *)zoomable;
+ (TEConstant *)zoomed;
@end


