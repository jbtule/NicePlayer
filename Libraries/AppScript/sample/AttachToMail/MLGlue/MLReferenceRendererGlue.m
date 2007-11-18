/*
 * MLReferenceRendererGlue.m
 *
 * /Applications/Mail.app
 * osaglue 0.2.0
 *
 */

#import "MLReferenceRendererGlue.h"

@implementation MLReferenceRenderer

- (NSString *)propertyByCode:(OSType)code {
    switch (code) {
        case 'attp': return @"MIMEType";
        case 'mact': return @"account";
        case 'path': return @"accountDirectory";
        case 'atyp': return @"accountType";
        case 'radd': return @"address";
        case 'racm': return @"allConditionsMustBeMet";
        case 'alhe': return @"allHeaders";
        case 'abcm': return @"alwaysBccMyself";
        case 'accm': return @"alwaysCcMyself";
        case 'apve': return @"applicationVersion";
        case 'paus': return @"authentication";
        case 'bthc': return @"backgroundActivityCount";
        case 'mcol': return @"backgroundColor";
        case 'bmws': return @"bigMessageWarningSize";
        case 'pbnd': return @"bounds";
        case 'chsp': return @"checkSpellingWhileTyping";
        case 'cswc': return @"chooseSignatureWhenComposing";
        case 'pcls': return @"class_";
        case 'hclb': return @"closeable";
        case 'lwcl': return @"collating";
        case 'colr': return @"color";
        case 'rcme': return @"colorMessage";
        case 'mcct': return @"colorQuotedText";
        case 'cwcm': return @"compactMailboxesWhenClosing";
        case 'mbxc': return @"container";
        case 'ctnt': return @"content";
        case 'lwcp': return @"copies";
        case 'rcmb': return @"copyMessage";
        case 'rdrc': return @"dateReceived";
        case 'drcv': return @"dateSent";
        case 'demf': return @"defaultMessageFormat";
        case 'dmdi': return @"delayedMessageDeletionInterval";
        case 'dmos': return @"deleteMailOnServer";
        case 'rdme': return @"deleteMessage";
        case 'dmwm': return @"deleteMessagesWhenMovedFromInbox";
        case 'isdl': return @"deletedStatus";
        case 'dact': return @"deliveryAccount";
        case 'docu': return @"document";
        case 'dhta': return @"downloadHtmlAttachments";
        case 'atdn': return @"downloaded";
        case 'drmb': return @"draftsMailbox";
        case 'emad': return @"emailAddresses";
        case 'ejmf': return @"emptyJunkMessagesFrequency";
        case 'ejmo': return @"emptyJunkMessagesOnQuit";
        case 'esmf': return @"emptySentMessagesFrequency";
        case 'esmo': return @"emptySentMessagesOnQuit";
        case 'etrf': return @"emptyTrashFrequency";
        case 'etoq': return @"emptyTrashOnQuit";
        case 'isac': return @"enabled";
        case 'lwlp': return @"endingPage";
        case 'lweh': return @"errorHandling";
        case 'exga': return @"expandGroupAddresses";
        case 'rexp': return @"expression";
        case 'faxn': return @"faxNumber";
        case 'affq': return @"fetchInterval";
        case 'saft': return @"fetchesAutomatically";
        case 'atfn': return @"fileName";
        case 'mptf': return @"fixedWidthFont";
        case 'ptfs': return @"fixedWidthFontSize";
        case 'isfl': return @"flaggedStatus";
        case 'font': return @"font";
        case 'rfad': return @"forwardMessage";
        case 'rfte': return @"forwardText";
        case 'frve': return @"frameworkVersion";
        case 'pisf': return @"frontmost";
        case 'flln': return @"fullName";
        case 'rhed': return @"header";
        case 'hedl': return @"headerDetail";
        case 'shht': return @"highlightSelectedThread";
        case 'htuc': return @"highlightTextUsingColor";
        case 'ldsa': return @"hostName";
        case 'ID  ': return @"id_";
        case 'inmb': return @"inbox";
        case 'iaoo': return @"includeAllOriginalMessageText";
        case 'iwgm': return @"includeWhenGettingNewMail";
        case 'pidx': return @"index";
        case 'isjk': return @"junkMailStatus";
        case 'jkmb': return @"junkMailbox";
        case 'loqc': return @"levelOneQuotingColor";
        case 'lhqc': return @"levelThreeQuotingColor";
        case 'lwqc': return @"levelTwoQuotingColor";
        case 'mbxp': return @"mailbox";
        case 'mlsh': return @"mailboxListVisible";
        case 'rmfl': return @"markFlagged";
        case 'rmre': return @"markRead";
        case 'msgc': return @"messageCaching";
        case 'mmfn': return @"messageFont";
        case 'mmfs': return @"messageFontSize";
        case 'meid': return @"messageId";
        case 'mmlf': return @"messageListFont";
        case 'mlfs': return @"messageListFontSize";
        case 'tnrg': return @"messageSignature";
        case 'msze': return @"messageSize";
        case 'ismn': return @"miniaturizable";
        case 'pmnd': return @"miniaturized";
        case 'pmod': return @"modal";
        case 'imod': return @"modified";
        case 'smdm': return @"moveDeletedMessagesToTrash";
        case 'rtme': return @"moveMessage";
        case 'pnam': return @"name";
        case 'mnms': return @"newMailSound";
        case 'oumb': return @"outbox";
        case 'lwla': return @"pagesAcross";
        case 'lwld': return @"pagesDown";
        case 'macp': return @"password";
        case 'ppth': return @"path";
        case 'rpso': return @"playSound";
        case 'port': return @"port";
        case 'mvpv': return @"previewPaneIsVisible";
        case 'ueml': return @"primaryEmail";
        case 'pALL': return @"properties";
        case 'rqua': return @"qualifier";
        case 'inom': return @"quoteOriginalMessage";
        case 'isrd': return @"readStatus";
        case 'rrad': return @"redirectMessage";
        case 'rrte': return @"replyText";
        case 'rpto': return @"replyTo";
        case 'lwqt': return @"requestedPrintTime";
        case 'prsz': return @"resizable";
        case 'rtyp': return @"ruleType";
        case 'rras': return @"runScript";
        case 'risf': return @"sameReplyFormat";
        case 'ldsc': return @"scope";
        case 'ldsb': return @"searchBase";
        case 'msbx': return @"selectedMailboxes";
        case 'smgs': return @"selectedMessages";
        case 'sesi': return @"selectedSignature";
        case 'slct': return @"selection";
        case 'sndr': return @"sender";
        case 'stmb': return @"sentMailbox";
        case 'host': return @"serverName";
        case 'rscm': return @"shouldCopyMessage";
        case 'rstm': return @"shouldMoveMessage";
        case 'poms': return @"shouldPlayOtherMailSounds";
        case 'shsp': return @"showOnlineBuddyStatus";
        case 'ptsz': return @"size";
        case 'mvsc': return @"sortColumn";
        case 'mvsr': return @"sortedAscending";
        case 'raso': return @"source";
        case 'lwfp': return @"startingPage";
        case 'rser': return @"stopEvaluatingRules";
        case 'stos': return @"storeDeletedMessagesOnServer";
        case 'sdos': return @"storeDraftsOnServer";
        case 'sjos': return @"storeJunkMailOnServer";
        case 'ssos': return @"storeSentMessagesOnServer";
        case 'subj': return @"subject";
        case 'trpr': return @"targetPrinter";
        case 'ptit': return @"titled";
        case 'trmb': return @"trashMailbox";
        case 'mbuc': return @"unreadCount";
        case 'usla': return @"useAddressCompletion";
        case 'ufwf': return @"useFixedWidthFont";
        case 'unme': return @"userName";
        case 'usss': return @"usesSsl";
        case 'vers': return @"version_";
        case 'pvis': return @"visible";
        case 'mvvc': return @"visibleColumns";
        case 'mvfm': return @"visibleMessages";
        case 'isfw': return @"wasForwarded";
        case 'isrc': return @"wasRedirected";
        case 'isrp': return @"wasRepliedTo";
        case 'cwin': return @"window";
        case 'iszm': return @"zoomable";
        case 'pzum': return @"zoomed";

        default: return nil;
    }
}

- (NSString *)elementByCode:(OSType)code {
    switch (code) {
        case 'itac': return @"MacAccounts";
        case 'mact': return @"accounts";
        case 'capp': return @"applications";
        case 'atts': return @"attachment";
        case 'catr': return @"attributeRuns";
        case 'brcp': return @"bccRecipients";
        case 'crcp': return @"ccRecipients";
        case 'cha ': return @"characters";
        case 'colr': return @"colors";
        case 'mbxc': return @"containers";
        case 'docu': return @"documents";
        case 'mhdr': return @"headers";
        case 'iact': return @"imapAccounts";
        case 'cobj': return @"items";
        case 'ldse': return @"ldapServers";
        case 'attc': return @"mailAttachments";
        case 'mbxp': return @"mailboxes";
        case 'mvwr': return @"messageViewers";
        case 'mssg': return @"messages";
        case 'bcke': return @"outgoingMessages";
        case 'cpar': return @"paragraphs";
        case 'pact': return @"popAccounts";
        case 'pset': return @"printSettings";
        case 'rcpt': return @"recipients";
        case 'rucr': return @"ruleConditions";
        case 'rule': return @"rules";
        case 'situ': return @"signatures";
        case 'dact': return @"smtpServers";
        case 'ctxt': return @"text";
        case 'trcp': return @"toRecipients";
        case 'cwin': return @"windows";
        case 'cwor': return @"words";

        default: return nil;
    }
}

+ (NSString *)render:(id)object {
    return [MLReferenceRenderer render: object withPrefix: @"ML"];
}

@end
