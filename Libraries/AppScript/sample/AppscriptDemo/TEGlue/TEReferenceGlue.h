/*
 * TEReferenceGlue.h
 *
 * /applications/textedit.app
 * osaglue 0.2.0
 *
 */

#import <Foundation/Foundation.h>


#import "Appscript/Appscript.h"
#import "TECommandGlue.h"
#import "TEReferenceRendererGlue.h"

#define TEApp ((TEReference *)[TEReference referenceWithAppData: nil aemReference: AEMApp])
#define TECon ((TEReference *)[TEReference referenceWithAppData: nil aemReference: AEMCon])
#define TEIts ((TEReference *)[TEReference referenceWithAppData: nil aemReference: AEMIts])


@interface TEReference : ASReference

/* Commands */

- (TEActivateCommand *)activate;
- (TEActivateCommand *)activate:(id)directParameter;
- (TECloseCommand *)close;
- (TECloseCommand *)close:(id)directParameter;
- (TECountCommand *)count;
- (TECountCommand *)count:(id)directParameter;
- (TEDeleteCommand *)delete;
- (TEDeleteCommand *)delete:(id)directParameter;
- (TEDuplicateCommand *)duplicate;
- (TEDuplicateCommand *)duplicate:(id)directParameter;
- (TEExistsCommand *)exists;
- (TEExistsCommand *)exists:(id)directParameter;
- (TEGetCommand *)get;
- (TEGetCommand *)get:(id)directParameter;
- (TELaunchCommand *)launch;
- (TELaunchCommand *)launch:(id)directParameter;
- (TEMakeCommand *)make;
- (TEMakeCommand *)make:(id)directParameter;
- (TEMoveCommand *)move;
- (TEMoveCommand *)move:(id)directParameter;
- (TEOpenCommand *)open;
- (TEOpenCommand *)open:(id)directParameter;
- (TEOpenLocationCommand *)openLocation;
- (TEOpenLocationCommand *)openLocation:(id)directParameter;
- (TEPrintCommand *)print;
- (TEPrintCommand *)print:(id)directParameter;
- (TEQuitCommand *)quit;
- (TEQuitCommand *)quit:(id)directParameter;
- (TEReopenCommand *)reopen;
- (TEReopenCommand *)reopen:(id)directParameter;
- (TERunCommand *)run;
- (TERunCommand *)run:(id)directParameter;
- (TESaveCommand *)save;
- (TESaveCommand *)save:(id)directParameter;
- (TESetCommand *)set;
- (TESetCommand *)set:(id)directParameter;

/* Elements */

- (TEReference *)applications;
- (TEReference *)attachment;
- (TEReference *)attributeRuns;
- (TEReference *)characters;
- (TEReference *)colors;
- (TEReference *)documents;
- (TEReference *)items;
- (TEReference *)paragraphs;
- (TEReference *)printSettings;
- (TEReference *)text;
- (TEReference *)windows;
- (TEReference *)words;

/* Properties */

- (TEReference *)bounds;
- (TEReference *)class_;
- (TEReference *)closeable;
- (TEReference *)collating;
- (TEReference *)color;
- (TEReference *)copies;
- (TEReference *)document;
- (TEReference *)endingPage;
- (TEReference *)errorHandling;
- (TEReference *)faxNumber;
- (TEReference *)fileName;
- (TEReference *)floating;
- (TEReference *)font;
- (TEReference *)frontmost;
- (TEReference *)id_;
- (TEReference *)index;
- (TEReference *)miniaturizable;
- (TEReference *)miniaturized;
- (TEReference *)modal;
- (TEReference *)modified;
- (TEReference *)name;
- (TEReference *)pagesAcross;
- (TEReference *)pagesDown;
- (TEReference *)path;
- (TEReference *)properties;
- (TEReference *)requestedPrintTime;
- (TEReference *)resizable;
- (TEReference *)size;
- (TEReference *)startingPage;
- (TEReference *)targetPrinter;
- (TEReference *)titled;
- (TEReference *)version_;
- (TEReference *)visible;
- (TEReference *)zoomable;
- (TEReference *)zoomed;
- (TEReference *)first;
- (TEReference *)middle;
- (TEReference *)last;
- (TEReference *)any;
- (TEReference *)at:(long)index;
- (TEReference *)byIndex:(id)index;
- (TEReference *)byName:(NSString *)name;
- (TEReference *)byID:(id)id_;
- (TEReference *)previous:(ASConstant *)class_;
- (TEReference *)next:(ASConstant *)class_;
- (TEReference *)at:(long)fromIndex to:(long)toIndex;
- (TEReference *)byRange:(id)fromObject to:(id)toObject;
- (TEReference *)byTest:(TEReference *)testReference;
- (TEReference *)beginning;
- (TEReference *)end;
- (TEReference *)before;
- (TEReference *)after;
- (TEReference *)greaterThan:(id)object;
- (TEReference *)greaterOrEquals:(id)object;
- (TEReference *)equals:(id)object;
- (TEReference *)notEquals:(id)object;
- (TEReference *)lessThan:(id)object;
- (TEReference *)lessOrEquals:(id)object;
- (TEReference *)beginsWith:(id)object;
- (TEReference *)endsWith:(id)object;
- (TEReference *)contains:(id)object;
- (TEReference *)isIn:(id)object;
- (TEReference *)AND:(id)remainingOperands;
- (TEReference *)OR:(id)remainingOperands;
- (TEReference *)NOT;
@end


