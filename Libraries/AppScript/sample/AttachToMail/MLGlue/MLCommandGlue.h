/*
 * MLCommandGlue.h
 *
 * /Applications/Mail.app
 * osaglue 0.2.0
 *
 */

#import <Foundation/Foundation.h>


#import "Appscript/Appscript.h"


@interface MLGetURLCommand : ASCommand
@end


@interface MLActivateCommand : ASCommand
@end


@interface MLBounceCommand : ASCommand
@end


@interface MLCheckForNewMailCommand : ASCommand
- (MLCheckForNewMailCommand *)for_:(id)value;
@end


@interface MLCloseCommand : ASCommand
- (MLCloseCommand *)saving:(id)value;
- (MLCloseCommand *)savingIn:(id)value;
@end


@interface MLCountCommand : ASCommand
- (MLCountCommand *)each:(id)value;
@end


@interface MLDeleteCommand : ASCommand
@end


@interface MLDuplicateCommand : ASCommand
- (MLDuplicateCommand *)to:(id)value;
@end


@interface MLExistsCommand : ASCommand
@end


@interface MLExtractAddressFromCommand : ASCommand
@end


@interface MLExtractNameFromCommand : ASCommand
@end


@interface MLForwardCommand : ASCommand
- (MLForwardCommand *)openingWindow:(id)value;
@end


@interface MLGetCommand : ASCommand
@end


@interface MLImportMailMailboxCommand : ASCommand
- (MLImportMailMailboxCommand *)at:(id)value;
@end


@interface MLLaunchCommand : ASCommand
@end


@interface MLMailtoCommand : ASCommand
@end


@interface MLMakeCommand : ASCommand
- (MLMakeCommand *)at:(id)value;
- (MLMakeCommand *)new_:(id)value;
- (MLMakeCommand *)withData:(id)value;
- (MLMakeCommand *)withProperties:(id)value;
@end


@interface MLMoveCommand : ASCommand
- (MLMoveCommand *)to:(id)value;
@end


@interface MLOpenCommand : ASCommand
@end


@interface MLOpenLocationCommand : ASCommand
- (MLOpenLocationCommand *)window:(id)value;
@end


@interface MLPerformMailActionWithMessagesCommand : ASCommand
- (MLPerformMailActionWithMessagesCommand *)forRule:(id)value;
- (MLPerformMailActionWithMessagesCommand *)inMailboxes:(id)value;
@end


@interface MLPrintCommand : ASCommand
- (MLPrintCommand *)printDialog:(id)value;
- (MLPrintCommand *)withProperties:(id)value;
@end


@interface MLQuitCommand : ASCommand
- (MLQuitCommand *)saving:(id)value;
@end


@interface MLRedirectCommand : ASCommand
- (MLRedirectCommand *)openingWindow:(id)value;
@end


@interface MLReopenCommand : ASCommand
@end


@interface MLReplyCommand : ASCommand
- (MLReplyCommand *)openingWindow:(id)value;
- (MLReplyCommand *)replyToAll:(id)value;
@end


@interface MLRunCommand : ASCommand
@end


@interface MLSaveCommand : ASCommand
- (MLSaveCommand *)as:(id)value;
- (MLSaveCommand *)in:(id)value;
@end


@interface MLSend_Command : ASCommand
@end


@interface MLSetCommand : ASCommand
- (MLSetCommand *)to:(id)value;
@end


@interface MLSynchronizeCommand : ASCommand
- (MLSynchronizeCommand *)with:(id)value;
@end


