/*
 * TECommandGlue.m
 *
 * /applications/textedit.app
 * osaglue 0.2.0
 *
 */

#import "TECommandGlue.h"

@implementation TEActivateCommand

@end


@implementation TECloseCommand

- (TECloseCommand *)saving:(id)value {
    [AS_event setParameter: value forKeyword: 'savo'];
    return self;
}

- (TECloseCommand *)savingIn:(id)value {
    [AS_event setParameter: value forKeyword: 'kfil'];
    return self;
}

@end


@implementation TECountCommand

- (TECountCommand *)each:(id)value {
    [AS_event setParameter: value forKeyword: 'kocl'];
    return self;
}

@end


@implementation TEDeleteCommand

@end


@implementation TEDuplicateCommand

- (TEDuplicateCommand *)to:(id)value {
    [AS_event setParameter: value forKeyword: 'insh'];
    return self;
}

- (TEDuplicateCommand *)withProperties:(id)value {
    [AS_event setParameter: value forKeyword: 'prdt'];
    return self;
}

@end


@implementation TEExistsCommand

@end


@implementation TEGetCommand

@end


@implementation TELaunchCommand

@end


@implementation TEMakeCommand

- (TEMakeCommand *)at:(id)value {
    [AS_event setParameter: value forKeyword: 'insh'];
    return self;
}

- (TEMakeCommand *)new_:(id)value {
    [AS_event setParameter: value forKeyword: 'kocl'];
    return self;
}

- (TEMakeCommand *)withData:(id)value {
    [AS_event setParameter: value forKeyword: 'data'];
    return self;
}

- (TEMakeCommand *)withProperties:(id)value {
    [AS_event setParameter: value forKeyword: 'prdt'];
    return self;
}

@end


@implementation TEMoveCommand

- (TEMoveCommand *)to:(id)value {
    [AS_event setParameter: value forKeyword: 'insh'];
    return self;
}

@end


@implementation TEOpenCommand

@end


@implementation TEOpenLocationCommand

- (TEOpenLocationCommand *)window:(id)value {
    [AS_event setParameter: value forKeyword: 'WIND'];
    return self;
}

@end


@implementation TEPrintCommand

- (TEPrintCommand *)printDialog:(id)value {
    [AS_event setParameter: value forKeyword: 'pdlg'];
    return self;
}

- (TEPrintCommand *)withProperties:(id)value {
    [AS_event setParameter: value forKeyword: 'prdt'];
    return self;
}

@end


@implementation TEQuitCommand

- (TEQuitCommand *)saving:(id)value {
    [AS_event setParameter: value forKeyword: 'savo'];
    return self;
}

@end


@implementation TEReopenCommand

@end


@implementation TERunCommand

@end


@implementation TESaveCommand

- (TESaveCommand *)as:(id)value {
    [AS_event setParameter: value forKeyword: 'fltp'];
    return self;
}

- (TESaveCommand *)in:(id)value {
    [AS_event setParameter: value forKeyword: 'kfil'];
    return self;
}

@end


@implementation TESetCommand

- (TESetCommand *)to:(id)value {
    [AS_event setParameter: value forKeyword: 'data'];
    return self;
}

@end


