/*
 * MLConstantGlue.m
 *
 * /Applications/Mail.app
 * osaglue 0.2.0
 *
 */

#import "MLConstantGlue.h"

@implementation MLConstant

+ (id)constantWithCode:(OSType)code_ {
    switch (code_) {
        case 'attp': return [self MIMEType];
        case 'etit': return [self Mac];
        case 'itac': return [self MacAccount];
        case 'tacc': return [self account];
        case 'mact': return [self account];
        case 'path': return [self accountDirectory];
        case 'atyp': return [self accountType];
        case 'radd': return [self address];
        case 'hdal': return [self all];
        case 'racm': return [self allConditionsMustBeMet];
        case 'alhe': return [self allHeaders];
        case 'x9al': return [self allMessagesAndTheirAttachments];
        case 'x9bo': return [self allMessagesButOmitAttachments];
        case 'abcm': return [self alwaysBccMyself];
        case 'accm': return [self alwaysCcMyself];
        case 'tanr': return [self anyRecipient];
        case 'aapo': return [self apop];
        case 'capp': return [self application];
        case 'apve': return [self applicationVersion];
        case 'ask ': return [self ask];
        case 'atts': return [self attachment];
        case 'ecat': return [self attachmentsColumn];
        case 'catr': return [self attributeRun];
        case 'paus': return [self authentication];
        case 'bthc': return [self backgroundActivityCount];
        case 'mcol': return [self backgroundColor];
        case 'lsba': return [self base];
        case 'brcp': return [self bccRecipient];
        case 'rqbw': return [self beginsWithValue];
        case 'bmws': return [self bigMessageWarningSize];
        case 'ccbl': return [self blue];
        case 'pbnd': return [self bounds];
        case 'ecba': return [self buddyAvailabilityColumn];
        case 'tccc': return [self ccHeader];
        case 'crcp': return [self ccRecipient];
        case 'cha ': return [self character];
        case 'chsp': return [self checkSpellingWhileTyping];
        case 'cswc': return [self chooseSignatureWhenComposing];
        case 'pcls': return [self class_];
        case 'hclb': return [self closeable];
        case 'lwcl': return [self collating];
        case 'colr': return [self color];
        case 'rcme': return [self colorMessage];
        case 'mcct': return [self colorQuotedText];
        case 'cwcm': return [self compactMailboxesWhenClosing];
        case 'mbxc': return [self container];
        case 'ctnt': return [self content];
        case 'lwcp': return [self copies];
        case 'rcmb': return [self copyMessage];
        case 'hdcu': return [self custom];
        case 'rdrc': return [self dateReceived];
        case 'ecdr': return [self dateReceivedColumn];
        case 'drcv': return [self dateSent];
        case 'ecds': return [self dateSentColumn];
        case 'demf': return [self defaultMessageFormat];
        case 'hdde': return [self default_];
        case 'dmdi': return [self delayedMessageDeletionInterval];
        case 'dmos': return [self deleteMailOnServer];
        case 'rdme': return [self deleteMessage];
        case 'dmwm': return [self deleteMessagesWhenMovedFromInbox];
        case 'isdl': return [self deletedStatus];
        case 'lwdt': return [self detailed];
        case 'x9no': return [self doNotKeepCopiesOfAnyMessages];
        case 'docu': return [self document];
        case 'rqco': return [self doesContainValue];
        case 'rqdn': return [self doesNotContainValue];
        case 'dhta': return [self downloadHtmlAttachments];
        case 'atdn': return [self downloaded];
        case 'drmb': return [self draftsMailbox];
        case 'emad': return [self emailAddresses];
        case 'ejmf': return [self emptyJunkMessagesFrequency];
        case 'ejmo': return [self emptyJunkMessagesOnQuit];
        case 'esmf': return [self emptySentMessagesFrequency];
        case 'esmo': return [self emptySentMessagesOnQuit];
        case 'etrf': return [self emptyTrashFrequency];
        case 'etoq': return [self emptyTrashOnQuit];
        case 'isac': return [self enabled];
        case 'lwlp': return [self endingPage];
        case 'rqew': return [self endsWithValue];
        case 'rqie': return [self equalToValue];
        case 'lweh': return [self errorHandling];
        case 'exga': return [self expandGroupAddresses];
        case 'rexp': return [self expression];
        case 'faxn': return [self faxNumber];
        case 'affq': return [self fetchInterval];
        case 'saft': return [self fetchesAutomatically];
        case 'atfn': return [self fileName];
        case 'mptf': return [self fixedWidthFont];
        case 'ptfs': return [self fixedWidthFontSize];
        case 'isfl': return [self flaggedStatus];
        case 'ecfl': return [self flagsColumn];
        case 'font': return [self font];
        case 'rfad': return [self forwardMessage];
        case 'rfte': return [self forwardText];
        case 'frve': return [self frameworkVersion];
        case 'ecfr': return [self fromColumn];
        case 'tfro': return [self fromHeader];
        case 'pisf': return [self frontmost];
        case 'flln': return [self fullName];
        case 'ccgy': return [self gray];
        case 'rqgt': return [self greaterThanValue];
        case 'ccgr': return [self green];
        case 'mhdr': return [self header];
        case 'rhed': return [self header];
        case 'hedl': return [self headerDetail];
        case 'thdk': return [self headerKey];
        case 'shht': return [self highlightSelectedThread];
        case 'htuc': return [self highlightTextUsingColor];
        case 'ldsa': return [self hostName];
        case 'ID  ': return [self id_];
        case 'etim': return [self imap];
        case 'iact': return [self imapAccount];
        case 'inmb': return [self inbox];
        case 'iaoo': return [self includeAllOriginalMessageText];
        case 'iwgm': return [self includeWhenGettingNewMail];
        case 'pidx': return [self index];
        case 'cobj': return [self item];
        case 'isjk': return [self junkMailStatus];
        case 'jkmb': return [self junkMailbox];
        case 'axk5': return [self kerberos5];
        case 'ldse': return [self ldapServer];
        case 'rqlt': return [self lessThanValue];
        case 'loqc': return [self levelOneQuotingColor];
        case 'lhqc': return [self levelThreeQuotingColor];
        case 'lwqc': return [self levelTwoQuotingColor];
        case 'attc': return [self mailAttachment];
        case 'mbxp': return [self mailbox];
        case 'ecmb': return [self mailboxColumn];
        case 'mlsh': return [self mailboxListVisible];
        case 'rmfl': return [self markFlagged];
        case 'rmre': return [self markRead];
        case 'tevm': return [self matchesEveryMessage];
        case 'axmd': return [self md5];
        case 'mssg': return [self message];
        case 'msgc': return [self messageCaching];
        case 'eccl': return [self messageColor];
        case 'tmec': return [self messageContent];
        case 'mmfn': return [self messageFont];
        case 'mmfs': return [self messageFontSize];
        case 'meid': return [self messageId];
        case 'tmij': return [self messageIsJunkMail];
        case 'mmlf': return [self messageListFont];
        case 'mlfs': return [self messageListFontSize];
        case 'tnrg': return [self messageSignature];
        case 'msze': return [self messageSize];
        case 'ecms': return [self messageStatusColumn];
        case 'mvwr': return [self messageViewer];
        case 'ismn': return [self miniaturizable];
        case 'pmnd': return [self miniaturized];
        case 'pmod': return [self modal];
        case 'imod': return [self modified];
        case 'smdm': return [self moveDeletedMessagesToTrash];
        case 'rtme': return [self moveMessage];
        case 'pnam': return [self name];
        case 'mnms': return [self newMailSound];
        case 'no  ': return [self no];
        case 'hdnn': return [self noHeaders];
        case 'ccno': return [self none];
        case 'rqno': return [self none];
        case 'axnt': return [self ntlm];
        case 'ecnm': return [self numberColumn];
        case 'lsol': return [self oneLevel];
        case 'x9wr': return [self onlyMessagesIHaveRead];
        case 'ccor': return [self orange];
        case 'ccot': return [self other];
        case 'oumb': return [self outbox];
        case 'bcke': return [self outgoingMessage];
        case 'lwla': return [self pagesAcross];
        case 'lwld': return [self pagesDown];
        case 'cpar': return [self paragraph];
        case 'axct': return [self password];
        case 'macp': return [self password];
        case 'ppth': return [self path];
        case 'dmpt': return [self plainText];
        case 'rpso': return [self playSound];
        case 'etpo': return [self pop];
        case 'pact': return [self popAccount];
        case 'port': return [self port];
        case 'mvpv': return [self previewPaneIsVisible];
        case 'ueml': return [self primaryEmail];
        case 'pset': return [self printSettings];
        case 'pALL': return [self properties];
        case 'ccpu': return [self purple];
        case 'rqua': return [self qualifier];
        case 'inom': return [self quoteOriginalMessage];
        case 'isrd': return [self readStatus];
        case 'rcpt': return [self recipient];
        case 'ccre': return [self red];
        case 'rrad': return [self redirectMessage];
        case 'rrte': return [self replyText];
        case 'rpto': return [self replyTo];
        case 'lwqt': return [self requestedPrintTime];
        case 'prsz': return [self resizable];
        case 'dmrt': return [self richText];
        case 'rule': return [self rule];
        case 'rucr': return [self ruleCondition];
        case 'rtyp': return [self ruleType];
        case 'rras': return [self runScript];
        case 'risf': return [self sameReplyFormat];
        case 'ldsc': return [self scope];
        case 'ldsb': return [self searchBase];
        case 'msbx': return [self selectedMailboxes];
        case 'smgs': return [self selectedMessages];
        case 'sesi': return [self selectedSignature];
        case 'slct': return [self selection];
        case 'sndr': return [self sender];
        case 'tsii': return [self senderIsInMyAddressBook];
        case 'tsim': return [self senderIsMemberOfGroup];
        case 'tsin': return [self senderIsNotInMyAddressBook];
        case 'tsig': return [self senderIsNotMemberOfGroup];
        case 'stmb': return [self sentMailbox];
        case 'host': return [self serverName];
        case 'rscm': return [self shouldCopyMessage];
        case 'rstm': return [self shouldMoveMessage];
        case 'poms': return [self shouldPlayOtherMailSounds];
        case 'shsp': return [self showOnlineBuddyStatus];
        case 'situ': return [self signature];
        case 'ptsz': return [self size];
        case 'ecsz': return [self sizeColumn];
        case 'etsm': return [self smtp];
        case 'dact': return [self smtpServer];
        case 'mvsc': return [self sortColumn];
        case 'mvsr': return [self sortedAscending];
        case 'raso': return [self source];
        case 'lwst': return [self standard];
        case 'lwfp': return [self startingPage];
        case 'rser': return [self stopEvaluatingRules];
        case 'stos': return [self storeDeletedMessagesOnServer];
        case 'sdos': return [self storeDraftsOnServer];
        case 'sjos': return [self storeJunkMailOnServer];
        case 'ssos': return [self storeSentMessagesOnServer];
        case 'subj': return [self subject];
        case 'ecsu': return [self subjectColumn];
        case 'tsub': return [self subjectHeader];
        case 'lsst': return [self subtree];
        case 'trpr': return [self targetPrinter];
        case 'ctxt': return [self text];
        case 'ptit': return [self titled];
        case 'ecto': return [self toColumn];
        case 'ttoo': return [self toHeader];
        case 'ttoc': return [self toOrCcHeader];
        case 'trcp': return [self toRecipient];
        case 'trmb': return [self trashMailbox];
        case 'mbuc': return [self unreadCount];
        case 'usla': return [self useAddressCompletion];
        case 'ufwf': return [self useFixedWidthFont];
        case 'unme': return [self userName];
        case 'usss': return [self usesSsl];
        case 'vers': return [self version_];
        case 'pvis': return [self visible];
        case 'mvvc': return [self visibleColumns];
        case 'mvfm': return [self visibleMessages];
        case 'isfw': return [self wasForwarded];
        case 'isrc': return [self wasRedirected];
        case 'isrp': return [self wasRepliedTo];
        case 'cwin': return [self window];
        case 'cwor': return [self word];
        case 'ccye': return [self yellow];
        case 'yes ': return [self yes];
        case 'iszm': return [self zoomable];
        case 'pzum': return [self zoomed];
        default: return [[self superclass] constantWithCode: code_];
    }
}


/* Enumerators */

+ (MLConstant *)Mac {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"Mac" type: typeEnumerated code: 'etit'];
    return constantObj;
}

+ (MLConstant *)all {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"all" type: typeEnumerated code: 'hdal'];
    return constantObj;
}

+ (MLConstant *)allMessagesAndTheirAttachments {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"allMessagesAndTheirAttachments" type: typeEnumerated code: 'x9al'];
    return constantObj;
}

+ (MLConstant *)allMessagesButOmitAttachments {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"allMessagesButOmitAttachments" type: typeEnumerated code: 'x9bo'];
    return constantObj;
}

+ (MLConstant *)anyRecipient {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"anyRecipient" type: typeEnumerated code: 'tanr'];
    return constantObj;
}

+ (MLConstant *)apop {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"apop" type: typeEnumerated code: 'aapo'];
    return constantObj;
}

+ (MLConstant *)ask {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"ask" type: typeEnumerated code: 'ask '];
    return constantObj;
}

+ (MLConstant *)attachmentsColumn {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"attachmentsColumn" type: typeEnumerated code: 'ecat'];
    return constantObj;
}

+ (MLConstant *)base {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"base" type: typeEnumerated code: 'lsba'];
    return constantObj;
}

+ (MLConstant *)beginsWithValue {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"beginsWithValue" type: typeEnumerated code: 'rqbw'];
    return constantObj;
}

+ (MLConstant *)blue {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"blue" type: typeEnumerated code: 'ccbl'];
    return constantObj;
}

+ (MLConstant *)buddyAvailabilityColumn {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"buddyAvailabilityColumn" type: typeEnumerated code: 'ecba'];
    return constantObj;
}

+ (MLConstant *)ccHeader {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"ccHeader" type: typeEnumerated code: 'tccc'];
    return constantObj;
}

+ (MLConstant *)custom {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"custom" type: typeEnumerated code: 'hdcu'];
    return constantObj;
}

+ (MLConstant *)dateReceivedColumn {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"dateReceivedColumn" type: typeEnumerated code: 'ecdr'];
    return constantObj;
}

+ (MLConstant *)dateSentColumn {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"dateSentColumn" type: typeEnumerated code: 'ecds'];
    return constantObj;
}

+ (MLConstant *)default_ {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"default_" type: typeEnumerated code: 'hdde'];
    return constantObj;
}

+ (MLConstant *)detailed {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"detailed" type: typeEnumerated code: 'lwdt'];
    return constantObj;
}

+ (MLConstant *)doNotKeepCopiesOfAnyMessages {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"doNotKeepCopiesOfAnyMessages" type: typeEnumerated code: 'x9no'];
    return constantObj;
}

+ (MLConstant *)doesContainValue {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"doesContainValue" type: typeEnumerated code: 'rqco'];
    return constantObj;
}

+ (MLConstant *)doesNotContainValue {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"doesNotContainValue" type: typeEnumerated code: 'rqdn'];
    return constantObj;
}

+ (MLConstant *)endsWithValue {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"endsWithValue" type: typeEnumerated code: 'rqew'];
    return constantObj;
}

+ (MLConstant *)equalToValue {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"equalToValue" type: typeEnumerated code: 'rqie'];
    return constantObj;
}

+ (MLConstant *)flagsColumn {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"flagsColumn" type: typeEnumerated code: 'ecfl'];
    return constantObj;
}

+ (MLConstant *)fromColumn {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"fromColumn" type: typeEnumerated code: 'ecfr'];
    return constantObj;
}

+ (MLConstant *)fromHeader {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"fromHeader" type: typeEnumerated code: 'tfro'];
    return constantObj;
}

+ (MLConstant *)gray {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"gray" type: typeEnumerated code: 'ccgy'];
    return constantObj;
}

+ (MLConstant *)greaterThanValue {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"greaterThanValue" type: typeEnumerated code: 'rqgt'];
    return constantObj;
}

+ (MLConstant *)green {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"green" type: typeEnumerated code: 'ccgr'];
    return constantObj;
}

+ (MLConstant *)headerKey {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"headerKey" type: typeEnumerated code: 'thdk'];
    return constantObj;
}

+ (MLConstant *)imap {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"imap" type: typeEnumerated code: 'etim'];
    return constantObj;
}

+ (MLConstant *)kerberos5 {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"kerberos5" type: typeEnumerated code: 'axk5'];
    return constantObj;
}

+ (MLConstant *)lessThanValue {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"lessThanValue" type: typeEnumerated code: 'rqlt'];
    return constantObj;
}

+ (MLConstant *)mailboxColumn {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"mailboxColumn" type: typeEnumerated code: 'ecmb'];
    return constantObj;
}

+ (MLConstant *)matchesEveryMessage {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"matchesEveryMessage" type: typeEnumerated code: 'tevm'];
    return constantObj;
}

+ (MLConstant *)md5 {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"md5" type: typeEnumerated code: 'axmd'];
    return constantObj;
}

+ (MLConstant *)messageColor {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"messageColor" type: typeEnumerated code: 'eccl'];
    return constantObj;
}

+ (MLConstant *)messageContent {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"messageContent" type: typeEnumerated code: 'tmec'];
    return constantObj;
}

+ (MLConstant *)messageIsJunkMail {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"messageIsJunkMail" type: typeEnumerated code: 'tmij'];
    return constantObj;
}

+ (MLConstant *)messageStatusColumn {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"messageStatusColumn" type: typeEnumerated code: 'ecms'];
    return constantObj;
}

+ (MLConstant *)no {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"no" type: typeEnumerated code: 'no  '];
    return constantObj;
}

+ (MLConstant *)noHeaders {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"noHeaders" type: typeEnumerated code: 'hdnn'];
    return constantObj;
}

+ (MLConstant *)none {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"none" type: typeEnumerated code: 'rqno'];
    return constantObj;
}

+ (MLConstant *)ntlm {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"ntlm" type: typeEnumerated code: 'axnt'];
    return constantObj;
}

+ (MLConstant *)numberColumn {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"numberColumn" type: typeEnumerated code: 'ecnm'];
    return constantObj;
}

+ (MLConstant *)oneLevel {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"oneLevel" type: typeEnumerated code: 'lsol'];
    return constantObj;
}

+ (MLConstant *)onlyMessagesIHaveRead {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"onlyMessagesIHaveRead" type: typeEnumerated code: 'x9wr'];
    return constantObj;
}

+ (MLConstant *)orange {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"orange" type: typeEnumerated code: 'ccor'];
    return constantObj;
}

+ (MLConstant *)other {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"other" type: typeEnumerated code: 'ccot'];
    return constantObj;
}

+ (MLConstant *)password {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"password" type: typeEnumerated code: 'axct'];
    return constantObj;
}

+ (MLConstant *)plainText {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"plainText" type: typeEnumerated code: 'dmpt'];
    return constantObj;
}

+ (MLConstant *)pop {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"pop" type: typeEnumerated code: 'etpo'];
    return constantObj;
}

+ (MLConstant *)purple {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"purple" type: typeEnumerated code: 'ccpu'];
    return constantObj;
}

+ (MLConstant *)red {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"red" type: typeEnumerated code: 'ccre'];
    return constantObj;
}

+ (MLConstant *)richText {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"richText" type: typeEnumerated code: 'dmrt'];
    return constantObj;
}

+ (MLConstant *)senderIsInMyAddressBook {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"senderIsInMyAddressBook" type: typeEnumerated code: 'tsii'];
    return constantObj;
}

+ (MLConstant *)senderIsMemberOfGroup {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"senderIsMemberOfGroup" type: typeEnumerated code: 'tsim'];
    return constantObj;
}

+ (MLConstant *)senderIsNotInMyAddressBook {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"senderIsNotInMyAddressBook" type: typeEnumerated code: 'tsin'];
    return constantObj;
}

+ (MLConstant *)senderIsNotMemberOfGroup {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"senderIsNotMemberOfGroup" type: typeEnumerated code: 'tsig'];
    return constantObj;
}

+ (MLConstant *)sizeColumn {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"sizeColumn" type: typeEnumerated code: 'ecsz'];
    return constantObj;
}

+ (MLConstant *)smtp {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"smtp" type: typeEnumerated code: 'etsm'];
    return constantObj;
}

+ (MLConstant *)standard {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"standard" type: typeEnumerated code: 'lwst'];
    return constantObj;
}

+ (MLConstant *)subjectColumn {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"subjectColumn" type: typeEnumerated code: 'ecsu'];
    return constantObj;
}

+ (MLConstant *)subjectHeader {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"subjectHeader" type: typeEnumerated code: 'tsub'];
    return constantObj;
}

+ (MLConstant *)subtree {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"subtree" type: typeEnumerated code: 'lsst'];
    return constantObj;
}

+ (MLConstant *)toColumn {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"toColumn" type: typeEnumerated code: 'ecto'];
    return constantObj;
}

+ (MLConstant *)toHeader {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"toHeader" type: typeEnumerated code: 'ttoo'];
    return constantObj;
}

+ (MLConstant *)toOrCcHeader {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"toOrCcHeader" type: typeEnumerated code: 'ttoc'];
    return constantObj;
}

+ (MLConstant *)yellow {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"yellow" type: typeEnumerated code: 'ccye'];
    return constantObj;
}

+ (MLConstant *)yes {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"yes" type: typeEnumerated code: 'yes '];
    return constantObj;
}


/* Types and properties */

+ (MLConstant *)MIMEType {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"MIMEType" type: typeType code: 'attp'];
    return constantObj;
}

+ (MLConstant *)MacAccount {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"MacAccount" type: typeType code: 'itac'];
    return constantObj;
}

+ (MLConstant *)account {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"account" type: typeType code: 'mact'];
    return constantObj;
}

+ (MLConstant *)accountDirectory {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"accountDirectory" type: typeType code: 'path'];
    return constantObj;
}

+ (MLConstant *)accountType {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"accountType" type: typeType code: 'atyp'];
    return constantObj;
}

+ (MLConstant *)address {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"address" type: typeType code: 'radd'];
    return constantObj;
}

+ (MLConstant *)allConditionsMustBeMet {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"allConditionsMustBeMet" type: typeType code: 'racm'];
    return constantObj;
}

+ (MLConstant *)allHeaders {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"allHeaders" type: typeType code: 'alhe'];
    return constantObj;
}

+ (MLConstant *)alwaysBccMyself {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"alwaysBccMyself" type: typeType code: 'abcm'];
    return constantObj;
}

+ (MLConstant *)alwaysCcMyself {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"alwaysCcMyself" type: typeType code: 'accm'];
    return constantObj;
}

+ (MLConstant *)application {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"application" type: typeType code: 'capp'];
    return constantObj;
}

+ (MLConstant *)applicationVersion {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"applicationVersion" type: typeType code: 'apve'];
    return constantObj;
}

+ (MLConstant *)attachment {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"attachment" type: typeType code: 'atts'];
    return constantObj;
}

+ (MLConstant *)attributeRun {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"attributeRun" type: typeType code: 'catr'];
    return constantObj;
}

+ (MLConstant *)authentication {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"authentication" type: typeType code: 'paus'];
    return constantObj;
}

+ (MLConstant *)backgroundActivityCount {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"backgroundActivityCount" type: typeType code: 'bthc'];
    return constantObj;
}

+ (MLConstant *)backgroundColor {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"backgroundColor" type: typeType code: 'mcol'];
    return constantObj;
}

+ (MLConstant *)bccRecipient {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"bccRecipient" type: typeType code: 'brcp'];
    return constantObj;
}

+ (MLConstant *)bigMessageWarningSize {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"bigMessageWarningSize" type: typeType code: 'bmws'];
    return constantObj;
}

+ (MLConstant *)bounds {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"bounds" type: typeType code: 'pbnd'];
    return constantObj;
}

+ (MLConstant *)ccRecipient {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"ccRecipient" type: typeType code: 'crcp'];
    return constantObj;
}

+ (MLConstant *)character {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"character" type: typeType code: 'cha '];
    return constantObj;
}

+ (MLConstant *)checkSpellingWhileTyping {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"checkSpellingWhileTyping" type: typeType code: 'chsp'];
    return constantObj;
}

+ (MLConstant *)chooseSignatureWhenComposing {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"chooseSignatureWhenComposing" type: typeType code: 'cswc'];
    return constantObj;
}

+ (MLConstant *)class_ {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"class_" type: typeType code: 'pcls'];
    return constantObj;
}

+ (MLConstant *)closeable {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"closeable" type: typeType code: 'hclb'];
    return constantObj;
}

+ (MLConstant *)collating {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"collating" type: typeType code: 'lwcl'];
    return constantObj;
}

+ (MLConstant *)color {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"color" type: typeType code: 'colr'];
    return constantObj;
}

+ (MLConstant *)colorMessage {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"colorMessage" type: typeType code: 'rcme'];
    return constantObj;
}

+ (MLConstant *)colorQuotedText {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"colorQuotedText" type: typeType code: 'mcct'];
    return constantObj;
}

+ (MLConstant *)compactMailboxesWhenClosing {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"compactMailboxesWhenClosing" type: typeType code: 'cwcm'];
    return constantObj;
}

+ (MLConstant *)container {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"container" type: typeType code: 'mbxc'];
    return constantObj;
}

+ (MLConstant *)content {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"content" type: typeType code: 'ctnt'];
    return constantObj;
}

+ (MLConstant *)copies {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"copies" type: typeType code: 'lwcp'];
    return constantObj;
}

+ (MLConstant *)copyMessage {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"copyMessage" type: typeType code: 'rcmb'];
    return constantObj;
}

+ (MLConstant *)dateReceived {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"dateReceived" type: typeType code: 'rdrc'];
    return constantObj;
}

+ (MLConstant *)dateSent {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"dateSent" type: typeType code: 'drcv'];
    return constantObj;
}

+ (MLConstant *)defaultMessageFormat {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"defaultMessageFormat" type: typeType code: 'demf'];
    return constantObj;
}

+ (MLConstant *)delayedMessageDeletionInterval {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"delayedMessageDeletionInterval" type: typeType code: 'dmdi'];
    return constantObj;
}

+ (MLConstant *)deleteMailOnServer {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"deleteMailOnServer" type: typeType code: 'dmos'];
    return constantObj;
}

+ (MLConstant *)deleteMessage {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"deleteMessage" type: typeType code: 'rdme'];
    return constantObj;
}

+ (MLConstant *)deleteMessagesWhenMovedFromInbox {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"deleteMessagesWhenMovedFromInbox" type: typeType code: 'dmwm'];
    return constantObj;
}

+ (MLConstant *)deletedStatus {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"deletedStatus" type: typeType code: 'isdl'];
    return constantObj;
}

+ (MLConstant *)deliveryAccount {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"deliveryAccount" type: typeType code: 'dact'];
    return constantObj;
}

+ (MLConstant *)document {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"document" type: typeType code: 'docu'];
    return constantObj;
}

+ (MLConstant *)downloadHtmlAttachments {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"downloadHtmlAttachments" type: typeType code: 'dhta'];
    return constantObj;
}

+ (MLConstant *)downloaded {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"downloaded" type: typeType code: 'atdn'];
    return constantObj;
}

+ (MLConstant *)draftsMailbox {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"draftsMailbox" type: typeType code: 'drmb'];
    return constantObj;
}

+ (MLConstant *)emailAddresses {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"emailAddresses" type: typeType code: 'emad'];
    return constantObj;
}

+ (MLConstant *)emptyJunkMessagesFrequency {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"emptyJunkMessagesFrequency" type: typeType code: 'ejmf'];
    return constantObj;
}

+ (MLConstant *)emptyJunkMessagesOnQuit {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"emptyJunkMessagesOnQuit" type: typeType code: 'ejmo'];
    return constantObj;
}

+ (MLConstant *)emptySentMessagesFrequency {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"emptySentMessagesFrequency" type: typeType code: 'esmf'];
    return constantObj;
}

+ (MLConstant *)emptySentMessagesOnQuit {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"emptySentMessagesOnQuit" type: typeType code: 'esmo'];
    return constantObj;
}

+ (MLConstant *)emptyTrashFrequency {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"emptyTrashFrequency" type: typeType code: 'etrf'];
    return constantObj;
}

+ (MLConstant *)emptyTrashOnQuit {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"emptyTrashOnQuit" type: typeType code: 'etoq'];
    return constantObj;
}

+ (MLConstant *)enabled {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"enabled" type: typeType code: 'isac'];
    return constantObj;
}

+ (MLConstant *)endingPage {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"endingPage" type: typeType code: 'lwlp'];
    return constantObj;
}

+ (MLConstant *)errorHandling {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"errorHandling" type: typeType code: 'lweh'];
    return constantObj;
}

+ (MLConstant *)expandGroupAddresses {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"expandGroupAddresses" type: typeType code: 'exga'];
    return constantObj;
}

+ (MLConstant *)expression {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"expression" type: typeType code: 'rexp'];
    return constantObj;
}

+ (MLConstant *)faxNumber {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"faxNumber" type: typeType code: 'faxn'];
    return constantObj;
}

+ (MLConstant *)fetchInterval {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"fetchInterval" type: typeType code: 'affq'];
    return constantObj;
}

+ (MLConstant *)fetchesAutomatically {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"fetchesAutomatically" type: typeType code: 'saft'];
    return constantObj;
}

+ (MLConstant *)fileName {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"fileName" type: typeType code: 'atfn'];
    return constantObj;
}

+ (MLConstant *)fixedWidthFont {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"fixedWidthFont" type: typeType code: 'mptf'];
    return constantObj;
}

+ (MLConstant *)fixedWidthFontSize {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"fixedWidthFontSize" type: typeType code: 'ptfs'];
    return constantObj;
}

+ (MLConstant *)flaggedStatus {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"flaggedStatus" type: typeType code: 'isfl'];
    return constantObj;
}

+ (MLConstant *)floating {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"floating" type: typeType code: 'isfl'];
    return constantObj;
}

+ (MLConstant *)font {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"font" type: typeType code: 'font'];
    return constantObj;
}

+ (MLConstant *)forwardMessage {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"forwardMessage" type: typeType code: 'rfad'];
    return constantObj;
}

+ (MLConstant *)forwardText {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"forwardText" type: typeType code: 'rfte'];
    return constantObj;
}

+ (MLConstant *)frameworkVersion {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"frameworkVersion" type: typeType code: 'frve'];
    return constantObj;
}

+ (MLConstant *)frontmost {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"frontmost" type: typeType code: 'pisf'];
    return constantObj;
}

+ (MLConstant *)fullName {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"fullName" type: typeType code: 'flln'];
    return constantObj;
}

+ (MLConstant *)header {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"header" type: typeType code: 'mhdr'];
    return constantObj;
}

+ (MLConstant *)headerDetail {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"headerDetail" type: typeType code: 'hedl'];
    return constantObj;
}

+ (MLConstant *)highlightSelectedThread {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"highlightSelectedThread" type: typeType code: 'shht'];
    return constantObj;
}

+ (MLConstant *)highlightTextUsingColor {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"highlightTextUsingColor" type: typeType code: 'htuc'];
    return constantObj;
}

+ (MLConstant *)hostName {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"hostName" type: typeType code: 'ldsa'];
    return constantObj;
}

+ (MLConstant *)id_ {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"id_" type: typeType code: 'ID  '];
    return constantObj;
}

+ (MLConstant *)imapAccount {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"imapAccount" type: typeType code: 'iact'];
    return constantObj;
}

+ (MLConstant *)inbox {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"inbox" type: typeType code: 'inmb'];
    return constantObj;
}

+ (MLConstant *)includeAllOriginalMessageText {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"includeAllOriginalMessageText" type: typeType code: 'iaoo'];
    return constantObj;
}

+ (MLConstant *)includeWhenGettingNewMail {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"includeWhenGettingNewMail" type: typeType code: 'iwgm'];
    return constantObj;
}

+ (MLConstant *)index {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"index" type: typeType code: 'pidx'];
    return constantObj;
}

+ (MLConstant *)item {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"item" type: typeType code: 'cobj'];
    return constantObj;
}

+ (MLConstant *)junkMailStatus {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"junkMailStatus" type: typeType code: 'isjk'];
    return constantObj;
}

+ (MLConstant *)junkMailbox {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"junkMailbox" type: typeType code: 'jkmb'];
    return constantObj;
}

+ (MLConstant *)ldapServer {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"ldapServer" type: typeType code: 'ldse'];
    return constantObj;
}

+ (MLConstant *)levelOneQuotingColor {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"levelOneQuotingColor" type: typeType code: 'loqc'];
    return constantObj;
}

+ (MLConstant *)levelThreeQuotingColor {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"levelThreeQuotingColor" type: typeType code: 'lhqc'];
    return constantObj;
}

+ (MLConstant *)levelTwoQuotingColor {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"levelTwoQuotingColor" type: typeType code: 'lwqc'];
    return constantObj;
}

+ (MLConstant *)mailAttachment {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"mailAttachment" type: typeType code: 'attc'];
    return constantObj;
}

+ (MLConstant *)mailbox {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"mailbox" type: typeType code: 'mbxp'];
    return constantObj;
}

+ (MLConstant *)mailboxListVisible {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"mailboxListVisible" type: typeType code: 'mlsh'];
    return constantObj;
}

+ (MLConstant *)markFlagged {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"markFlagged" type: typeType code: 'rmfl'];
    return constantObj;
}

+ (MLConstant *)markRead {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"markRead" type: typeType code: 'rmre'];
    return constantObj;
}

+ (MLConstant *)message {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"message" type: typeType code: 'mssg'];
    return constantObj;
}

+ (MLConstant *)messageCaching {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"messageCaching" type: typeType code: 'msgc'];
    return constantObj;
}

+ (MLConstant *)messageFont {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"messageFont" type: typeType code: 'mmfn'];
    return constantObj;
}

+ (MLConstant *)messageFontSize {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"messageFontSize" type: typeType code: 'mmfs'];
    return constantObj;
}

+ (MLConstant *)messageId {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"messageId" type: typeType code: 'meid'];
    return constantObj;
}

+ (MLConstant *)messageListFont {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"messageListFont" type: typeType code: 'mmlf'];
    return constantObj;
}

+ (MLConstant *)messageListFontSize {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"messageListFontSize" type: typeType code: 'mlfs'];
    return constantObj;
}

+ (MLConstant *)messageSignature {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"messageSignature" type: typeType code: 'tnrg'];
    return constantObj;
}

+ (MLConstant *)messageSize {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"messageSize" type: typeType code: 'msze'];
    return constantObj;
}

+ (MLConstant *)messageViewer {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"messageViewer" type: typeType code: 'mvwr'];
    return constantObj;
}

+ (MLConstant *)miniaturizable {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"miniaturizable" type: typeType code: 'ismn'];
    return constantObj;
}

+ (MLConstant *)miniaturized {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"miniaturized" type: typeType code: 'pmnd'];
    return constantObj;
}

+ (MLConstant *)modal {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"modal" type: typeType code: 'pmod'];
    return constantObj;
}

+ (MLConstant *)modified {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"modified" type: typeType code: 'imod'];
    return constantObj;
}

+ (MLConstant *)moveDeletedMessagesToTrash {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"moveDeletedMessagesToTrash" type: typeType code: 'smdm'];
    return constantObj;
}

+ (MLConstant *)moveMessage {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"moveMessage" type: typeType code: 'rtme'];
    return constantObj;
}

+ (MLConstant *)name {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"name" type: typeType code: 'pnam'];
    return constantObj;
}

+ (MLConstant *)newMailSound {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"newMailSound" type: typeType code: 'mnms'];
    return constantObj;
}

+ (MLConstant *)outbox {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"outbox" type: typeType code: 'oumb'];
    return constantObj;
}

+ (MLConstant *)outgoingMessage {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"outgoingMessage" type: typeType code: 'bcke'];
    return constantObj;
}

+ (MLConstant *)pagesAcross {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"pagesAcross" type: typeType code: 'lwla'];
    return constantObj;
}

+ (MLConstant *)pagesDown {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"pagesDown" type: typeType code: 'lwld'];
    return constantObj;
}

+ (MLConstant *)paragraph {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"paragraph" type: typeType code: 'cpar'];
    return constantObj;
}

+ (MLConstant *)path {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"path" type: typeType code: 'ppth'];
    return constantObj;
}

+ (MLConstant *)playSound {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"playSound" type: typeType code: 'rpso'];
    return constantObj;
}

+ (MLConstant *)popAccount {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"popAccount" type: typeType code: 'pact'];
    return constantObj;
}

+ (MLConstant *)port {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"port" type: typeType code: 'port'];
    return constantObj;
}

+ (MLConstant *)previewPaneIsVisible {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"previewPaneIsVisible" type: typeType code: 'mvpv'];
    return constantObj;
}

+ (MLConstant *)primaryEmail {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"primaryEmail" type: typeType code: 'ueml'];
    return constantObj;
}

+ (MLConstant *)printSettings {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"printSettings" type: typeType code: 'pset'];
    return constantObj;
}

+ (MLConstant *)properties {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"properties" type: typeType code: 'pALL'];
    return constantObj;
}

+ (MLConstant *)qualifier {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"qualifier" type: typeType code: 'rqua'];
    return constantObj;
}

+ (MLConstant *)quoteOriginalMessage {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"quoteOriginalMessage" type: typeType code: 'inom'];
    return constantObj;
}

+ (MLConstant *)readStatus {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"readStatus" type: typeType code: 'isrd'];
    return constantObj;
}

+ (MLConstant *)recipient {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"recipient" type: typeType code: 'rcpt'];
    return constantObj;
}

+ (MLConstant *)redirectMessage {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"redirectMessage" type: typeType code: 'rrad'];
    return constantObj;
}

+ (MLConstant *)replyText {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"replyText" type: typeType code: 'rrte'];
    return constantObj;
}

+ (MLConstant *)replyTo {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"replyTo" type: typeType code: 'rpto'];
    return constantObj;
}

+ (MLConstant *)requestedPrintTime {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"requestedPrintTime" type: typeType code: 'lwqt'];
    return constantObj;
}

+ (MLConstant *)resizable {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"resizable" type: typeType code: 'prsz'];
    return constantObj;
}

+ (MLConstant *)rule {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"rule" type: typeType code: 'rule'];
    return constantObj;
}

+ (MLConstant *)ruleCondition {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"ruleCondition" type: typeType code: 'rucr'];
    return constantObj;
}

+ (MLConstant *)ruleType {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"ruleType" type: typeType code: 'rtyp'];
    return constantObj;
}

+ (MLConstant *)runScript {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"runScript" type: typeType code: 'rras'];
    return constantObj;
}

+ (MLConstant *)sameReplyFormat {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"sameReplyFormat" type: typeType code: 'risf'];
    return constantObj;
}

+ (MLConstant *)scope {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"scope" type: typeType code: 'ldsc'];
    return constantObj;
}

+ (MLConstant *)searchBase {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"searchBase" type: typeType code: 'ldsb'];
    return constantObj;
}

+ (MLConstant *)selectedMailboxes {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"selectedMailboxes" type: typeType code: 'msbx'];
    return constantObj;
}

+ (MLConstant *)selectedMessages {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"selectedMessages" type: typeType code: 'smgs'];
    return constantObj;
}

+ (MLConstant *)selectedSignature {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"selectedSignature" type: typeType code: 'sesi'];
    return constantObj;
}

+ (MLConstant *)selection {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"selection" type: typeType code: 'slct'];
    return constantObj;
}

+ (MLConstant *)sender {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"sender" type: typeType code: 'sndr'];
    return constantObj;
}

+ (MLConstant *)sentMailbox {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"sentMailbox" type: typeType code: 'stmb'];
    return constantObj;
}

+ (MLConstant *)serverName {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"serverName" type: typeType code: 'host'];
    return constantObj;
}

+ (MLConstant *)shouldCopyMessage {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"shouldCopyMessage" type: typeType code: 'rscm'];
    return constantObj;
}

+ (MLConstant *)shouldMoveMessage {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"shouldMoveMessage" type: typeType code: 'rstm'];
    return constantObj;
}

+ (MLConstant *)shouldPlayOtherMailSounds {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"shouldPlayOtherMailSounds" type: typeType code: 'poms'];
    return constantObj;
}

+ (MLConstant *)showOnlineBuddyStatus {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"showOnlineBuddyStatus" type: typeType code: 'shsp'];
    return constantObj;
}

+ (MLConstant *)signature {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"signature" type: typeType code: 'situ'];
    return constantObj;
}

+ (MLConstant *)size {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"size" type: typeType code: 'ptsz'];
    return constantObj;
}

+ (MLConstant *)smtpServer {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"smtpServer" type: typeType code: 'dact'];
    return constantObj;
}

+ (MLConstant *)sortColumn {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"sortColumn" type: typeType code: 'mvsc'];
    return constantObj;
}

+ (MLConstant *)sortedAscending {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"sortedAscending" type: typeType code: 'mvsr'];
    return constantObj;
}

+ (MLConstant *)source {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"source" type: typeType code: 'raso'];
    return constantObj;
}

+ (MLConstant *)startingPage {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"startingPage" type: typeType code: 'lwfp'];
    return constantObj;
}

+ (MLConstant *)stopEvaluatingRules {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"stopEvaluatingRules" type: typeType code: 'rser'];
    return constantObj;
}

+ (MLConstant *)storeDeletedMessagesOnServer {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"storeDeletedMessagesOnServer" type: typeType code: 'stos'];
    return constantObj;
}

+ (MLConstant *)storeDraftsOnServer {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"storeDraftsOnServer" type: typeType code: 'sdos'];
    return constantObj;
}

+ (MLConstant *)storeJunkMailOnServer {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"storeJunkMailOnServer" type: typeType code: 'sjos'];
    return constantObj;
}

+ (MLConstant *)storeSentMessagesOnServer {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"storeSentMessagesOnServer" type: typeType code: 'ssos'];
    return constantObj;
}

+ (MLConstant *)subject {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"subject" type: typeType code: 'subj'];
    return constantObj;
}

+ (MLConstant *)targetPrinter {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"targetPrinter" type: typeType code: 'trpr'];
    return constantObj;
}

+ (MLConstant *)text {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"text" type: typeType code: 'ctxt'];
    return constantObj;
}

+ (MLConstant *)titled {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"titled" type: typeType code: 'ptit'];
    return constantObj;
}

+ (MLConstant *)toRecipient {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"toRecipient" type: typeType code: 'trcp'];
    return constantObj;
}

+ (MLConstant *)trashMailbox {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"trashMailbox" type: typeType code: 'trmb'];
    return constantObj;
}

+ (MLConstant *)unreadCount {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"unreadCount" type: typeType code: 'mbuc'];
    return constantObj;
}

+ (MLConstant *)useAddressCompletion {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"useAddressCompletion" type: typeType code: 'usla'];
    return constantObj;
}

+ (MLConstant *)useFixedWidthFont {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"useFixedWidthFont" type: typeType code: 'ufwf'];
    return constantObj;
}

+ (MLConstant *)userName {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"userName" type: typeType code: 'unme'];
    return constantObj;
}

+ (MLConstant *)usesSsl {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"usesSsl" type: typeType code: 'usss'];
    return constantObj;
}

+ (MLConstant *)version_ {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"version_" type: typeType code: 'vers'];
    return constantObj;
}

+ (MLConstant *)visible {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"visible" type: typeType code: 'pvis'];
    return constantObj;
}

+ (MLConstant *)visibleColumns {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"visibleColumns" type: typeType code: 'mvvc'];
    return constantObj;
}

+ (MLConstant *)visibleMessages {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"visibleMessages" type: typeType code: 'mvfm'];
    return constantObj;
}

+ (MLConstant *)wasForwarded {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"wasForwarded" type: typeType code: 'isfw'];
    return constantObj;
}

+ (MLConstant *)wasRedirected {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"wasRedirected" type: typeType code: 'isrc'];
    return constantObj;
}

+ (MLConstant *)wasRepliedTo {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"wasRepliedTo" type: typeType code: 'isrp'];
    return constantObj;
}

+ (MLConstant *)window {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"window" type: typeType code: 'cwin'];
    return constantObj;
}

+ (MLConstant *)word {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"word" type: typeType code: 'cwor'];
    return constantObj;
}

+ (MLConstant *)zoomable {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"zoomable" type: typeType code: 'iszm'];
    return constantObj;
}

+ (MLConstant *)zoomed {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"zoomed" type: typeType code: 'pzum'];
    return constantObj;
}

@end


