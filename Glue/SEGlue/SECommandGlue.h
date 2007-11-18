/*
 * SECommandGlue.h
 *
 * /System/Library/CoreServices/System Events.app
 * osaglue 0.2.0
 *
 */

#import <Foundation/Foundation.h>


#import "Appscript/Appscript.h"


@interface SEAbort_transactionCommand : ASCommand
@end


@interface SEActivateCommand : ASCommand
@end


@interface SEAttach_action_toCommand : ASCommand
- (SEAttach_action_toCommand *)using:(id)value;
@end


@interface SEAttached_scriptsCommand : ASCommand
@end


@interface SEBegin_transactionCommand : ASCommand
@end


@interface SECancelCommand : ASCommand
@end


@interface SEClickCommand : ASCommand
- (SEClickCommand *)at:(id)value;
@end


@interface SECloseCommand : ASCommand
- (SECloseCommand *)saving:(id)value;
- (SECloseCommand *)saving_in:(id)value;
@end


@interface SEConfirmCommand : ASCommand
@end


@interface SEConnectCommand : ASCommand
@end


@interface SECountCommand : ASCommand
- (SECountCommand *)each:(id)value;
@end


@interface SEDecrementCommand : ASCommand
@end


@interface SEDeleteCommand : ASCommand
@end


@interface SEDisconnectCommand : ASCommand
@end


@interface SEDo_folder_actionCommand : ASCommand
- (SEDo_folder_actionCommand *)folder_action_code:(id)value;
- (SEDo_folder_actionCommand *)with_item_list:(id)value;
- (SEDo_folder_actionCommand *)with_window_size:(id)value;
@end


@interface SEDo_scriptCommand : ASCommand
@end


@interface SEDuplicateCommand : ASCommand
- (SEDuplicateCommand *)to:(id)value;
- (SEDuplicateCommand *)with_properties:(id)value;
@end


@interface SEEdit_action_ofCommand : ASCommand
- (SEEdit_action_ofCommand *)using_action_name:(id)value;
- (SEEdit_action_ofCommand *)using_action_number:(id)value;
@end


@interface SEEnd_transactionCommand : ASCommand
@end


@interface SEExistsCommand : ASCommand
@end


@interface SEGetCommand : ASCommand
@end


@interface SEIncrementCommand : ASCommand
@end


@interface SEKey_codeCommand : ASCommand
- (SEKey_codeCommand *)using:(id)value;
@end


@interface SEKey_downCommand : ASCommand
@end


@interface SEKey_upCommand : ASCommand
@end


@interface SEKeystrokeCommand : ASCommand
- (SEKeystrokeCommand *)using:(id)value;
@end


@interface SELaunchCommand : ASCommand
@end


@interface SELog_outCommand : ASCommand
@end


@interface SEMakeCommand : ASCommand
- (SEMakeCommand *)at:(id)value;
- (SEMakeCommand *)new:(id)value;
- (SEMakeCommand *)with_data:(id)value;
- (SEMakeCommand *)with_properties:(id)value;
@end


@interface SEMoveCommand : ASCommand
- (SEMoveCommand *)to:(id)value;
@end


@interface SEOpenCommand : ASCommand
@end


@interface SEOpenLocationCommand : ASCommand
- (SEOpenLocationCommand *)window:(id)value;
@end


@interface SEPerformCommand : ASCommand
@end


@interface SEPickCommand : ASCommand
@end


@interface SEPrintCommand : ASCommand
@end


@interface SEPrint_Command : ASCommand
- (SEPrint_Command *)print_dialog:(id)value;
- (SEPrint_Command *)with_properties:(id)value;
@end


@interface SEQuitCommand : ASCommand
- (SEQuitCommand *)saving:(id)value;
@end


@interface SERemove_action_fromCommand : ASCommand
- (SERemove_action_fromCommand *)using_action_name:(id)value;
- (SERemove_action_fromCommand *)using_action_number:(id)value;
@end


@interface SEReopenCommand : ASCommand
@end


@interface SERestartCommand : ASCommand
@end


@interface SERunCommand : ASCommand
@end


@interface SESaveCommand : ASCommand
- (SESaveCommand *)as:(id)value;
- (SESaveCommand *)in_:(id)value;
@end


@interface SESelectCommand : ASCommand
@end


@interface SESetCommand : ASCommand
- (SESetCommand *)to:(id)value;
@end


@interface SEShut_downCommand : ASCommand
@end


@interface SESleepCommand : ASCommand
@end


