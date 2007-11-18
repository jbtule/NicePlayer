/*
 * SECommandGlue.m
 *
 * /System/Library/CoreServices/System Events.app
 * osaglue 0.2.0
 *
 */

#import "SECommandGlue.h"

@implementation SEAbort_transactionCommand

@end


@implementation SEActivateCommand

@end


@implementation SEAttach_action_toCommand

- (SEAttach_action_toCommand *)using:(id)value {
    [AS_event setParameter: value forKeyword: 'faal'];
    return self;
}

@end


@implementation SEAttached_scriptsCommand

@end


@implementation SEBegin_transactionCommand

@end


@implementation SECancelCommand

@end


@implementation SEClickCommand

- (SEClickCommand *)at:(id)value {
    [AS_event setParameter: value forKeyword: 'insh'];
    return self;
}

@end


@implementation SECloseCommand

- (SECloseCommand *)saving:(id)value {
    [AS_event setParameter: value forKeyword: 'savo'];
    return self;
}

- (SECloseCommand *)saving_in:(id)value {
    [AS_event setParameter: value forKeyword: 'kfil'];
    return self;
}

@end


@implementation SEConfirmCommand

@end


@implementation SEConnectCommand

@end


@implementation SECountCommand

- (SECountCommand *)each:(id)value {
    [AS_event setParameter: value forKeyword: 'kocl'];
    return self;
}

@end


@implementation SEDecrementCommand

@end


@implementation SEDeleteCommand

@end


@implementation SEDisconnectCommand

@end


@implementation SEDo_folder_actionCommand

- (SEDo_folder_actionCommand *)folder_action_code:(id)value {
    [AS_event setParameter: value forKeyword: 'actn'];
    return self;
}

- (SEDo_folder_actionCommand *)with_item_list:(id)value {
    [AS_event setParameter: value forKeyword: 'flst'];
    return self;
}

- (SEDo_folder_actionCommand *)with_window_size:(id)value {
    [AS_event setParameter: value forKeyword: 'fnsz'];
    return self;
}

@end


@implementation SEDo_scriptCommand

@end


@implementation SEDuplicateCommand

- (SEDuplicateCommand *)to:(id)value {
    [AS_event setParameter: value forKeyword: 'insh'];
    return self;
}

- (SEDuplicateCommand *)with_properties:(id)value {
    [AS_event setParameter: value forKeyword: 'prdt'];
    return self;
}

@end


@implementation SEEdit_action_ofCommand

- (SEEdit_action_ofCommand *)using_action_name:(id)value {
    [AS_event setParameter: value forKeyword: 'snam'];
    return self;
}

- (SEEdit_action_ofCommand *)using_action_number:(id)value {
    [AS_event setParameter: value forKeyword: 'indx'];
    return self;
}

@end


@implementation SEEnd_transactionCommand

@end


@implementation SEExistsCommand

@end


@implementation SEGetCommand

@end


@implementation SEIncrementCommand

@end


@implementation SEKey_codeCommand

- (SEKey_codeCommand *)using:(id)value {
    [AS_event setParameter: value forKeyword: 'faal'];
    return self;
}

@end


@implementation SEKey_downCommand

@end


@implementation SEKey_upCommand

@end


@implementation SEKeystrokeCommand

- (SEKeystrokeCommand *)using:(id)value {
    [AS_event setParameter: value forKeyword: 'faal'];
    return self;
}

@end


@implementation SELaunchCommand

@end


@implementation SELog_outCommand

@end


@implementation SEMakeCommand

- (SEMakeCommand *)at:(id)value {
    [AS_event setParameter: value forKeyword: 'insh'];
    return self;
}

- (SEMakeCommand *)new:(id)value {
    [AS_event setParameter: value forKeyword: 'kocl'];
    return self;
}

- (SEMakeCommand *)with_data:(id)value {
    [AS_event setParameter: value forKeyword: 'data'];
    return self;
}

- (SEMakeCommand *)with_properties:(id)value {
    [AS_event setParameter: value forKeyword: 'prdt'];
    return self;
}

@end


@implementation SEMoveCommand

- (SEMoveCommand *)to:(id)value {
    [AS_event setParameter: value forKeyword: 'insh'];
    return self;
}

@end


@implementation SEOpenCommand

@end


@implementation SEOpenLocationCommand

- (SEOpenLocationCommand *)window:(id)value {
    [AS_event setParameter: value forKeyword: 'WIND'];
    return self;
}

@end


@implementation SEPerformCommand

@end


@implementation SEPickCommand

@end


@implementation SEPrintCommand

@end


@implementation SEPrint_Command

- (SEPrint_Command *)print_dialog:(id)value {
    [AS_event setParameter: value forKeyword: 'pdlg'];
    return self;
}

- (SEPrint_Command *)with_properties:(id)value {
    [AS_event setParameter: value forKeyword: 'prdt'];
    return self;
}

@end


@implementation SEQuitCommand

- (SEQuitCommand *)saving:(id)value {
    [AS_event setParameter: value forKeyword: 'savo'];
    return self;
}

@end


@implementation SERemove_action_fromCommand

- (SERemove_action_fromCommand *)using_action_name:(id)value {
    [AS_event setParameter: value forKeyword: 'snam'];
    return self;
}

- (SERemove_action_fromCommand *)using_action_number:(id)value {
    [AS_event setParameter: value forKeyword: 'indx'];
    return self;
}

@end


@implementation SEReopenCommand

@end


@implementation SERestartCommand

@end


@implementation SERunCommand

@end


@implementation SESaveCommand

- (SESaveCommand *)as:(id)value {
    [AS_event setParameter: value forKeyword: 'fltp'];
    return self;
}

- (SESaveCommand *)in_:(id)value {
    [AS_event setParameter: value forKeyword: 'kfil'];
    return self;
}

@end


@implementation SESelectCommand

@end


@implementation SESetCommand

- (SESetCommand *)to:(id)value {
    [AS_event setParameter: value forKeyword: 'data'];
    return self;
}

@end


@implementation SEShut_downCommand

@end


@implementation SESleepCommand

@end


