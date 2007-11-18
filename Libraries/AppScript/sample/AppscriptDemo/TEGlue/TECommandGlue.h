/*
 * TECommandGlue.h
 *
 * /applications/textedit.app
 * osaglue 0.2.0
 *
 */

#import <Foundation/Foundation.h>


#import "Appscript/Appscript.h"


@interface TEActivateCommand : ASCommand
@end


@interface TECloseCommand : ASCommand
- (TECloseCommand *)saving:(id)value;
- (TECloseCommand *)savingIn:(id)value;
@end


@interface TECountCommand : ASCommand
- (TECountCommand *)each:(id)value;
@end


@interface TEDeleteCommand : ASCommand
@end


@interface TEDuplicateCommand : ASCommand
- (TEDuplicateCommand *)to:(id)value;
- (TEDuplicateCommand *)withProperties:(id)value;
@end


@interface TEExistsCommand : ASCommand
@end


@interface TEGetCommand : ASCommand
@end


@interface TELaunchCommand : ASCommand
@end


@interface TEMakeCommand : ASCommand
- (TEMakeCommand *)at:(id)value;
- (TEMakeCommand *)new_:(id)value;
- (TEMakeCommand *)withData:(id)value;
- (TEMakeCommand *)withProperties:(id)value;
@end


@interface TEMoveCommand : ASCommand
- (TEMoveCommand *)to:(id)value;
@end


@interface TEOpenCommand : ASCommand
@end


@interface TEOpenLocationCommand : ASCommand
- (TEOpenLocationCommand *)window:(id)value;
@end


@interface TEPrintCommand : ASCommand
- (TEPrintCommand *)printDialog:(id)value;
- (TEPrintCommand *)withProperties:(id)value;
@end


@interface TEQuitCommand : ASCommand
- (TEQuitCommand *)saving:(id)value;
@end


@interface TEReopenCommand : ASCommand
@end


@interface TERunCommand : ASCommand
@end


@interface TESaveCommand : ASCommand
- (TESaveCommand *)as:(id)value;
- (TESaveCommand *)in:(id)value;
@end


@interface TESetCommand : ASCommand
- (TESetCommand *)to:(id)value;
@end


