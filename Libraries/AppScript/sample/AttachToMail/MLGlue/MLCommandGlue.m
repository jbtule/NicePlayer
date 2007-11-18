/*
 * MLCommandGlue.m
 *
 * /Applications/Mail.app
 * osaglue 0.2.0
 *
 */

#import "MLCommandGlue.h"

@implementation MLGetURLCommand

@end


@implementation MLActivateCommand

@end


@implementation MLBounceCommand

@end


@implementation MLCheckForNewMailCommand

- (MLCheckForNewMailCommand *)for_:(id)value {
    [AS_event setParameter: value forKeyword: 'acna'];
    return self;
}

@end


@implementation MLCloseCommand

- (MLCloseCommand *)saving:(id)value {
    [AS_event setParameter: value forKeyword: 'savo'];
    return self;
}

- (MLCloseCommand *)savingIn:(id)value {
    [AS_event setParameter: value forKeyword: 'kfil'];
    return self;
}

@end


@implementation MLCountCommand

- (MLCountCommand *)each:(id)value {
    [AS_event setParameter: value forKeyword: 'kocl'];
    return self;
}

@end


@implementation MLDeleteCommand

@end


@implementation MLDuplicateCommand

- (MLDuplicateCommand *)to:(id)value {
    [AS_event setParameter: value forKeyword: 'insh'];
    return self;
}

@end


@implementation MLExistsCommand

@end


@implementation MLExtractAddressFromCommand

@end


@implementation MLExtractNameFromCommand

@end


@implementation MLForwardCommand

- (MLForwardCommand *)openingWindow:(id)value {
    [AS_event setParameter: value forKeyword: 'ropw'];
    return self;
}

@end


@implementation MLGetCommand

@end


@implementation MLImportMailMailboxCommand

- (MLImportMailMailboxCommand *)at:(id)value {
    [AS_event setParameter: value forKeyword: 'mbpt'];
    return self;
}

@end


@implementation MLLaunchCommand

@end


@implementation MLMailtoCommand

@end


@implementation MLMakeCommand

- (MLMakeCommand *)at:(id)value {
    [AS_event setParameter: value forKeyword: 'insh'];
    return self;
}

- (MLMakeCommand *)new_:(id)value {
    [AS_event setParameter: value forKeyword: 'kocl'];
    return self;
}

- (MLMakeCommand *)withData:(id)value {
    [AS_event setParameter: value forKeyword: 'data'];
    return self;
}

- (MLMakeCommand *)withProperties:(id)value {
    [AS_event setParameter: value forKeyword: 'prdt'];
    return self;
}

@end


@implementation MLMoveCommand

- (MLMoveCommand *)to:(id)value {
    [AS_event setParameter: value forKeyword: 'insh'];
    return self;
}

@end


@implementation MLOpenCommand

@end


@implementation MLOpenLocationCommand

- (MLOpenLocationCommand *)window:(id)value {
    [AS_event setParameter: value forKeyword: 'WIND'];
    return self;
}

@end


@implementation MLPerformMailActionWithMessagesCommand

- (MLPerformMailActionWithMessagesCommand *)forRule:(id)value {
    [AS_event setParameter: value forKeyword: 'pmar'];
    return self;
}

- (MLPerformMailActionWithMessagesCommand *)inMailboxes:(id)value {
    [AS_event setParameter: value forKeyword: 'pmbx'];
    return self;
}

@end


@implementation MLPrintCommand

- (MLPrintCommand *)printDialog:(id)value {
    [AS_event setParameter: value forKeyword: 'pdlg'];
    return self;
}

- (MLPrintCommand *)withProperties:(id)value {
    [AS_event setParameter: value forKeyword: 'prdt'];
    return self;
}

@end


@implementation MLQuitCommand

- (MLQuitCommand *)saving:(id)value {
    [AS_event setParameter: value forKeyword: 'savo'];
    return self;
}

@end


@implementation MLRedirectCommand

- (MLRedirectCommand *)openingWindow:(id)value {
    [AS_event setParameter: value forKeyword: 'ropw'];
    return self;
}

@end


@implementation MLReopenCommand

@end


@implementation MLReplyCommand

- (MLReplyCommand *)openingWindow:(id)value {
    [AS_event setParameter: value forKeyword: 'ropw'];
    return self;
}

- (MLReplyCommand *)replyToAll:(id)value {
    [AS_event setParameter: value forKeyword: 'rpal'];
    return self;
}

@end


@implementation MLRunCommand

@end


@implementation MLSaveCommand

- (MLSaveCommand *)as:(id)value {
    [AS_event setParameter: value forKeyword: 'fltp'];
    return self;
}

- (MLSaveCommand *)in:(id)value {
    [AS_event setParameter: value forKeyword: 'kfil'];
    return self;
}

@end


@implementation MLSend_Command

@end


@implementation MLSetCommand

- (MLSetCommand *)to:(id)value {
    [AS_event setParameter: value forKeyword: 'data'];
    return self;
}

@end


@implementation MLSynchronizeCommand

- (MLSynchronizeCommand *)with:(id)value {
    [AS_event setParameter: value forKeyword: 'acna'];
    return self;
}

@end


