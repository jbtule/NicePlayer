/*
 * MLReferenceGlue.m
 *
 * /Applications/Mail.app
 * osaglue 0.2.0
 *
 */

#import "MLReferenceGlue.h"

@implementation MLReference

- (NSString *)description {
	return [MLReferenceRenderer render: AS_aemReference];
}

/* Commands */

- (MLGetURLCommand *)GetURL {
    return [MLGetURLCommand commandWithAppData: AS_appData
                         eventClass: 'emal'
                            eventID: 'emtg'
                    directParameter: nil
                    parentReference: self];
}

- (MLGetURLCommand *)GetURL:(id)directParameter {
    return [MLGetURLCommand commandWithAppData: AS_appData
                         eventClass: 'emal'
                            eventID: 'emtg'
                    directParameter: directParameter
                    parentReference: self];
}

- (MLActivateCommand *)activate {
    return [MLActivateCommand commandWithAppData: AS_appData
                         eventClass: 'misc'
                            eventID: 'actv'
                    directParameter: nil
                    parentReference: self];
}

- (MLActivateCommand *)activate:(id)directParameter {
    return [MLActivateCommand commandWithAppData: AS_appData
                         eventClass: 'misc'
                            eventID: 'actv'
                    directParameter: directParameter
                    parentReference: self];
}

- (MLBounceCommand *)bounce {
    return [MLBounceCommand commandWithAppData: AS_appData
                         eventClass: 'emal'
                            eventID: 'bcms'
                    directParameter: nil
                    parentReference: self];
}

- (MLBounceCommand *)bounce:(id)directParameter {
    return [MLBounceCommand commandWithAppData: AS_appData
                         eventClass: 'emal'
                            eventID: 'bcms'
                    directParameter: directParameter
                    parentReference: self];
}

- (MLCheckForNewMailCommand *)checkForNewMail {
    return [MLCheckForNewMailCommand commandWithAppData: AS_appData
                         eventClass: 'emal'
                            eventID: 'chma'
                    directParameter: nil
                    parentReference: self];
}

- (MLCheckForNewMailCommand *)checkForNewMail:(id)directParameter {
    return [MLCheckForNewMailCommand commandWithAppData: AS_appData
                         eventClass: 'emal'
                            eventID: 'chma'
                    directParameter: directParameter
                    parentReference: self];
}

- (MLCloseCommand *)close {
    return [MLCloseCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'clos'
                    directParameter: nil
                    parentReference: self];
}

- (MLCloseCommand *)close:(id)directParameter {
    return [MLCloseCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'clos'
                    directParameter: directParameter
                    parentReference: self];
}

- (MLCountCommand *)count {
    return [MLCountCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'cnte'
                    directParameter: nil
                    parentReference: self];
}

- (MLCountCommand *)count:(id)directParameter {
    return [MLCountCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'cnte'
                    directParameter: directParameter
                    parentReference: self];
}

- (MLDeleteCommand *)delete {
    return [MLDeleteCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'delo'
                    directParameter: nil
                    parentReference: self];
}

- (MLDeleteCommand *)delete:(id)directParameter {
    return [MLDeleteCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'delo'
                    directParameter: directParameter
                    parentReference: self];
}

- (MLDuplicateCommand *)duplicate {
    return [MLDuplicateCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'clon'
                    directParameter: nil
                    parentReference: self];
}

- (MLDuplicateCommand *)duplicate:(id)directParameter {
    return [MLDuplicateCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'clon'
                    directParameter: directParameter
                    parentReference: self];
}

- (MLExistsCommand *)exists {
    return [MLExistsCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'doex'
                    directParameter: nil
                    parentReference: self];
}

- (MLExistsCommand *)exists:(id)directParameter {
    return [MLExistsCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'doex'
                    directParameter: directParameter
                    parentReference: self];
}

- (MLExtractAddressFromCommand *)extractAddressFrom {
    return [MLExtractAddressFromCommand commandWithAppData: AS_appData
                         eventClass: 'emal'
                            eventID: 'eaua'
                    directParameter: nil
                    parentReference: self];
}

- (MLExtractAddressFromCommand *)extractAddressFrom:(id)directParameter {
    return [MLExtractAddressFromCommand commandWithAppData: AS_appData
                         eventClass: 'emal'
                            eventID: 'eaua'
                    directParameter: directParameter
                    parentReference: self];
}

- (MLExtractNameFromCommand *)extractNameFrom {
    return [MLExtractNameFromCommand commandWithAppData: AS_appData
                         eventClass: 'emal'
                            eventID: 'eafn'
                    directParameter: nil
                    parentReference: self];
}

- (MLExtractNameFromCommand *)extractNameFrom:(id)directParameter {
    return [MLExtractNameFromCommand commandWithAppData: AS_appData
                         eventClass: 'emal'
                            eventID: 'eafn'
                    directParameter: directParameter
                    parentReference: self];
}

- (MLForwardCommand *)forward {
    return [MLForwardCommand commandWithAppData: AS_appData
                         eventClass: 'emal'
                            eventID: 'fwms'
                    directParameter: nil
                    parentReference: self];
}

- (MLForwardCommand *)forward:(id)directParameter {
    return [MLForwardCommand commandWithAppData: AS_appData
                         eventClass: 'emal'
                            eventID: 'fwms'
                    directParameter: directParameter
                    parentReference: self];
}

- (MLGetCommand *)get {
    return [MLGetCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'getd'
                    directParameter: nil
                    parentReference: self];
}

- (MLGetCommand *)get:(id)directParameter {
    return [MLGetCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'getd'
                    directParameter: directParameter
                    parentReference: self];
}

- (MLImportMailMailboxCommand *)importMailMailbox {
    return [MLImportMailMailboxCommand commandWithAppData: AS_appData
                         eventClass: 'emal'
                            eventID: 'immx'
                    directParameter: nil
                    parentReference: self];
}

- (MLImportMailMailboxCommand *)importMailMailbox:(id)directParameter {
    return [MLImportMailMailboxCommand commandWithAppData: AS_appData
                         eventClass: 'emal'
                            eventID: 'immx'
                    directParameter: directParameter
                    parentReference: self];
}

- (MLLaunchCommand *)launch {
    return [MLLaunchCommand commandWithAppData: AS_appData
                         eventClass: 'ascr'
                            eventID: 'noop'
                    directParameter: nil
                    parentReference: self];
}

- (MLLaunchCommand *)launch:(id)directParameter {
    return [MLLaunchCommand commandWithAppData: AS_appData
                         eventClass: 'ascr'
                            eventID: 'noop'
                    directParameter: directParameter
                    parentReference: self];
}

- (MLMailtoCommand *)mailto {
    return [MLMailtoCommand commandWithAppData: AS_appData
                         eventClass: 'emal'
                            eventID: 'emto'
                    directParameter: nil
                    parentReference: self];
}

- (MLMailtoCommand *)mailto:(id)directParameter {
    return [MLMailtoCommand commandWithAppData: AS_appData
                         eventClass: 'emal'
                            eventID: 'emto'
                    directParameter: directParameter
                    parentReference: self];
}

- (MLMakeCommand *)make {
    return [MLMakeCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'crel'
                    directParameter: nil
                    parentReference: self];
}

- (MLMakeCommand *)make:(id)directParameter {
    return [MLMakeCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'crel'
                    directParameter: directParameter
                    parentReference: self];
}

- (MLMoveCommand *)move {
    return [MLMoveCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'move'
                    directParameter: nil
                    parentReference: self];
}

- (MLMoveCommand *)move:(id)directParameter {
    return [MLMoveCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'move'
                    directParameter: directParameter
                    parentReference: self];
}

- (MLOpenCommand *)open {
    return [MLOpenCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'odoc'
                    directParameter: nil
                    parentReference: self];
}

- (MLOpenCommand *)open:(id)directParameter {
    return [MLOpenCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'odoc'
                    directParameter: directParameter
                    parentReference: self];
}

- (MLOpenLocationCommand *)openLocation {
    return [MLOpenLocationCommand commandWithAppData: AS_appData
                         eventClass: 'GURL'
                            eventID: 'GURL'
                    directParameter: nil
                    parentReference: self];
}

- (MLOpenLocationCommand *)openLocation:(id)directParameter {
    return [MLOpenLocationCommand commandWithAppData: AS_appData
                         eventClass: 'GURL'
                            eventID: 'GURL'
                    directParameter: directParameter
                    parentReference: self];
}

- (MLPerformMailActionWithMessagesCommand *)performMailActionWithMessages {
    return [MLPerformMailActionWithMessagesCommand commandWithAppData: AS_appData
                         eventClass: 'emal'
                            eventID: 'cpma'
                    directParameter: nil
                    parentReference: self];
}

- (MLPerformMailActionWithMessagesCommand *)performMailActionWithMessages:(id)directParameter {
    return [MLPerformMailActionWithMessagesCommand commandWithAppData: AS_appData
                         eventClass: 'emal'
                            eventID: 'cpma'
                    directParameter: directParameter
                    parentReference: self];
}

- (MLPrintCommand *)print {
    return [MLPrintCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'pdoc'
                    directParameter: nil
                    parentReference: self];
}

- (MLPrintCommand *)print:(id)directParameter {
    return [MLPrintCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'pdoc'
                    directParameter: directParameter
                    parentReference: self];
}

- (MLQuitCommand *)quit {
    return [MLQuitCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'quit'
                    directParameter: nil
                    parentReference: self];
}

- (MLQuitCommand *)quit:(id)directParameter {
    return [MLQuitCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'quit'
                    directParameter: directParameter
                    parentReference: self];
}

- (MLRedirectCommand *)redirect {
    return [MLRedirectCommand commandWithAppData: AS_appData
                         eventClass: 'emal'
                            eventID: 'rdms'
                    directParameter: nil
                    parentReference: self];
}

- (MLRedirectCommand *)redirect:(id)directParameter {
    return [MLRedirectCommand commandWithAppData: AS_appData
                         eventClass: 'emal'
                            eventID: 'rdms'
                    directParameter: directParameter
                    parentReference: self];
}

- (MLReopenCommand *)reopen {
    return [MLReopenCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'rapp'
                    directParameter: nil
                    parentReference: self];
}

- (MLReopenCommand *)reopen:(id)directParameter {
    return [MLReopenCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'rapp'
                    directParameter: directParameter
                    parentReference: self];
}

- (MLReplyCommand *)reply {
    return [MLReplyCommand commandWithAppData: AS_appData
                         eventClass: 'emal'
                            eventID: 'rpms'
                    directParameter: nil
                    parentReference: self];
}

- (MLReplyCommand *)reply:(id)directParameter {
    return [MLReplyCommand commandWithAppData: AS_appData
                         eventClass: 'emal'
                            eventID: 'rpms'
                    directParameter: directParameter
                    parentReference: self];
}

- (MLRunCommand *)run {
    return [MLRunCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'oapp'
                    directParameter: nil
                    parentReference: self];
}

- (MLRunCommand *)run:(id)directParameter {
    return [MLRunCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'oapp'
                    directParameter: directParameter
                    parentReference: self];
}

- (MLSaveCommand *)save {
    return [MLSaveCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'save'
                    directParameter: nil
                    parentReference: self];
}

- (MLSaveCommand *)save:(id)directParameter {
    return [MLSaveCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'save'
                    directParameter: directParameter
                    parentReference: self];
}

- (MLSend_Command *)send_ {
    return [MLSend_Command commandWithAppData: AS_appData
                         eventClass: 'emsg'
                            eventID: 'send'
                    directParameter: nil
                    parentReference: self];
}

- (MLSend_Command *)send_:(id)directParameter {
    return [MLSend_Command commandWithAppData: AS_appData
                         eventClass: 'emsg'
                            eventID: 'send'
                    directParameter: directParameter
                    parentReference: self];
}

- (MLSetCommand *)set {
    return [MLSetCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'setd'
                    directParameter: nil
                    parentReference: self];
}

- (MLSetCommand *)set:(id)directParameter {
    return [MLSetCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'setd'
                    directParameter: directParameter
                    parentReference: self];
}

- (MLSynchronizeCommand *)synchronize {
    return [MLSynchronizeCommand commandWithAppData: AS_appData
                         eventClass: 'emal'
                            eventID: 'syac'
                    directParameter: nil
                    parentReference: self];
}

- (MLSynchronizeCommand *)synchronize:(id)directParameter {
    return [MLSynchronizeCommand commandWithAppData: AS_appData
                         eventClass: 'emal'
                            eventID: 'syac'
                    directParameter: directParameter
                    parentReference: self];
}


/* Elements */

- (MLReference *)MacAccounts {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'itac']];
}

- (MLReference *)accounts {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'mact']];
}

- (MLReference *)applications {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'capp']];
}

- (MLReference *)attachment {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'atts']];
}

- (MLReference *)attributeRuns {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'catr']];
}

- (MLReference *)bccRecipients {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'brcp']];
}

- (MLReference *)ccRecipients {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'crcp']];
}

- (MLReference *)characters {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cha ']];
}

- (MLReference *)colors {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'colr']];
}

- (MLReference *)containers {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'mbxc']];
}

- (MLReference *)documents {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'docu']];
}

- (MLReference *)headers {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'mhdr']];
}

- (MLReference *)imapAccounts {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'iact']];
}

- (MLReference *)items {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cobj']];
}

- (MLReference *)ldapServers {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'ldse']];
}

- (MLReference *)mailAttachments {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'attc']];
}

- (MLReference *)mailboxes {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'mbxp']];
}

- (MLReference *)messageViewers {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'mvwr']];
}

- (MLReference *)messages {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'mssg']];
}

- (MLReference *)outgoingMessages {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'bcke']];
}

- (MLReference *)paragraphs {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cpar']];
}

- (MLReference *)popAccounts {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'pact']];
}

- (MLReference *)printSettings {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'pset']];
}

- (MLReference *)recipients {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'rcpt']];
}

- (MLReference *)ruleConditions {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'rucr']];
}

- (MLReference *)rules {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'rule']];
}

- (MLReference *)signatures {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'situ']];
}

- (MLReference *)smtpServers {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'dact']];
}

- (MLReference *)text {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'ctxt']];
}

- (MLReference *)toRecipients {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'trcp']];
}

- (MLReference *)windows {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cwin']];
}

- (MLReference *)words {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cwor']];
}


/* Properties */

- (MLReference *)MIMEType {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'attp']];
}

- (MLReference *)account {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'mact']];
}

- (MLReference *)accountDirectory {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'path']];
}

- (MLReference *)accountType {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'atyp']];
}

- (MLReference *)address {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'radd']];
}

- (MLReference *)allConditionsMustBeMet {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'racm']];
}

- (MLReference *)allHeaders {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'alhe']];
}

- (MLReference *)alwaysBccMyself {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'abcm']];
}

- (MLReference *)alwaysCcMyself {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'accm']];
}

- (MLReference *)applicationVersion {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'apve']];
}

- (MLReference *)authentication {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'paus']];
}

- (MLReference *)backgroundActivityCount {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'bthc']];
}

- (MLReference *)backgroundColor {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'mcol']];
}

- (MLReference *)bigMessageWarningSize {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'bmws']];
}

- (MLReference *)bounds {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pbnd']];
}

- (MLReference *)checkSpellingWhileTyping {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'chsp']];
}

- (MLReference *)chooseSignatureWhenComposing {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'cswc']];
}

- (MLReference *)class_ {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pcls']];
}

- (MLReference *)closeable {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'hclb']];
}

- (MLReference *)collating {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwcl']];
}

- (MLReference *)color {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'colr']];
}

- (MLReference *)colorMessage {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'rcme']];
}

- (MLReference *)colorQuotedText {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'mcct']];
}

- (MLReference *)compactMailboxesWhenClosing {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'cwcm']];
}

- (MLReference *)container {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'mbxc']];
}

- (MLReference *)content {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ctnt']];
}

- (MLReference *)copies {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwcp']];
}

- (MLReference *)copyMessage {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'rcmb']];
}

- (MLReference *)dateReceived {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'rdrc']];
}

- (MLReference *)dateSent {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'drcv']];
}

- (MLReference *)defaultMessageFormat {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'demf']];
}

- (MLReference *)delayedMessageDeletionInterval {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dmdi']];
}

- (MLReference *)deleteMailOnServer {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dmos']];
}

- (MLReference *)deleteMessage {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'rdme']];
}

- (MLReference *)deleteMessagesWhenMovedFromInbox {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dmwm']];
}

- (MLReference *)deletedStatus {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'isdl']];
}

- (MLReference *)deliveryAccount {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dact']];
}

- (MLReference *)document {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'docu']];
}

- (MLReference *)downloadHtmlAttachments {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dhta']];
}

- (MLReference *)downloaded {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'atdn']];
}

- (MLReference *)draftsMailbox {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'drmb']];
}

- (MLReference *)emailAddresses {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'emad']];
}

- (MLReference *)emptyJunkMessagesFrequency {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ejmf']];
}

- (MLReference *)emptyJunkMessagesOnQuit {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ejmo']];
}

- (MLReference *)emptySentMessagesFrequency {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'esmf']];
}

- (MLReference *)emptySentMessagesOnQuit {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'esmo']];
}

- (MLReference *)emptyTrashFrequency {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'etrf']];
}

- (MLReference *)emptyTrashOnQuit {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'etoq']];
}

- (MLReference *)enabled {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'isac']];
}

- (MLReference *)endingPage {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwlp']];
}

- (MLReference *)errorHandling {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lweh']];
}

- (MLReference *)expandGroupAddresses {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'exga']];
}

- (MLReference *)expression {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'rexp']];
}

- (MLReference *)faxNumber {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'faxn']];
}

- (MLReference *)fetchInterval {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'affq']];
}

- (MLReference *)fetchesAutomatically {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'saft']];
}

- (MLReference *)fileName {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'atfn']];
}

- (MLReference *)fixedWidthFont {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'mptf']];
}

- (MLReference *)fixedWidthFontSize {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ptfs']];
}

- (MLReference *)flaggedStatus {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'isfl']];
}

- (MLReference *)floating {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'isfl']];
}

- (MLReference *)font {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'font']];
}

- (MLReference *)forwardMessage {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'rfad']];
}

- (MLReference *)forwardText {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'rfte']];
}

- (MLReference *)frameworkVersion {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'frve']];
}

- (MLReference *)frontmost {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pisf']];
}

- (MLReference *)fullName {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'flln']];
}

- (MLReference *)header {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'rhed']];
}

- (MLReference *)headerDetail {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'hedl']];
}

- (MLReference *)highlightSelectedThread {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'shht']];
}

- (MLReference *)highlightTextUsingColor {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'htuc']];
}

- (MLReference *)hostName {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ldsa']];
}

- (MLReference *)id_ {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ID  ']];
}

- (MLReference *)inbox {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'inmb']];
}

- (MLReference *)includeAllOriginalMessageText {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'iaoo']];
}

- (MLReference *)includeWhenGettingNewMail {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'iwgm']];
}

- (MLReference *)index {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pidx']];
}

- (MLReference *)junkMailStatus {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'isjk']];
}

- (MLReference *)junkMailbox {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'jkmb']];
}

- (MLReference *)levelOneQuotingColor {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'loqc']];
}

- (MLReference *)levelThreeQuotingColor {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lhqc']];
}

- (MLReference *)levelTwoQuotingColor {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwqc']];
}

- (MLReference *)mailbox {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'mbxp']];
}

- (MLReference *)mailboxListVisible {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'mlsh']];
}

- (MLReference *)markFlagged {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'rmfl']];
}

- (MLReference *)markRead {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'rmre']];
}

- (MLReference *)messageCaching {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'msgc']];
}

- (MLReference *)messageFont {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'mmfn']];
}

- (MLReference *)messageFontSize {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'mmfs']];
}

- (MLReference *)messageId {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'meid']];
}

- (MLReference *)messageListFont {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'mmlf']];
}

- (MLReference *)messageListFontSize {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'mlfs']];
}

- (MLReference *)messageSignature {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'tnrg']];
}

- (MLReference *)messageSize {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'msze']];
}

- (MLReference *)miniaturizable {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ismn']];
}

- (MLReference *)miniaturized {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pmnd']];
}

- (MLReference *)modal {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pmod']];
}

- (MLReference *)modified {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'imod']];
}

- (MLReference *)moveDeletedMessagesToTrash {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'smdm']];
}

- (MLReference *)moveMessage {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'rtme']];
}

- (MLReference *)name {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pnam']];
}

- (MLReference *)newMailSound {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'mnms']];
}

- (MLReference *)outbox {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'oumb']];
}

- (MLReference *)pagesAcross {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwla']];
}

- (MLReference *)pagesDown {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwld']];
}

- (MLReference *)password {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'macp']];
}

- (MLReference *)path {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ppth']];
}

- (MLReference *)playSound {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'rpso']];
}

- (MLReference *)port {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'port']];
}

- (MLReference *)previewPaneIsVisible {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'mvpv']];
}

- (MLReference *)primaryEmail {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ueml']];
}

- (MLReference *)properties {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pALL']];
}

- (MLReference *)qualifier {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'rqua']];
}

- (MLReference *)quoteOriginalMessage {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'inom']];
}

- (MLReference *)readStatus {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'isrd']];
}

- (MLReference *)redirectMessage {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'rrad']];
}

- (MLReference *)replyText {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'rrte']];
}

- (MLReference *)replyTo {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'rpto']];
}

- (MLReference *)requestedPrintTime {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwqt']];
}

- (MLReference *)resizable {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'prsz']];
}

- (MLReference *)ruleType {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'rtyp']];
}

- (MLReference *)runScript {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'rras']];
}

- (MLReference *)sameReplyFormat {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'risf']];
}

- (MLReference *)scope {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ldsc']];
}

- (MLReference *)searchBase {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ldsb']];
}

- (MLReference *)selectedMailboxes {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'msbx']];
}

- (MLReference *)selectedMessages {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'smgs']];
}

- (MLReference *)selectedSignature {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'sesi']];
}

- (MLReference *)selection {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'slct']];
}

- (MLReference *)sender {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'sndr']];
}

- (MLReference *)sentMailbox {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'stmb']];
}

- (MLReference *)serverName {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'host']];
}

- (MLReference *)shouldCopyMessage {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'rscm']];
}

- (MLReference *)shouldMoveMessage {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'rstm']];
}

- (MLReference *)shouldPlayOtherMailSounds {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'poms']];
}

- (MLReference *)showOnlineBuddyStatus {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'shsp']];
}

- (MLReference *)size {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ptsz']];
}

- (MLReference *)sortColumn {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'mvsc']];
}

- (MLReference *)sortedAscending {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'mvsr']];
}

- (MLReference *)source {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'raso']];
}

- (MLReference *)startingPage {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwfp']];
}

- (MLReference *)stopEvaluatingRules {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'rser']];
}

- (MLReference *)storeDeletedMessagesOnServer {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'stos']];
}

- (MLReference *)storeDraftsOnServer {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'sdos']];
}

- (MLReference *)storeJunkMailOnServer {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'sjos']];
}

- (MLReference *)storeSentMessagesOnServer {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ssos']];
}

- (MLReference *)subject {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'subj']];
}

- (MLReference *)targetPrinter {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'trpr']];
}

- (MLReference *)titled {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ptit']];
}

- (MLReference *)trashMailbox {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'trmb']];
}

- (MLReference *)unreadCount {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'mbuc']];
}

- (MLReference *)useAddressCompletion {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'usla']];
}

- (MLReference *)useFixedWidthFont {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ufwf']];
}

- (MLReference *)userName {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'unme']];
}

- (MLReference *)usesSsl {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'usss']];
}

- (MLReference *)version_ {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'vers']];
}

- (MLReference *)visible {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pvis']];
}

- (MLReference *)visibleColumns {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'mvvc']];
}

- (MLReference *)visibleMessages {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'mvfm']];
}

- (MLReference *)wasForwarded {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'isfw']];
}

- (MLReference *)wasRedirected {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'isrc']];
}

- (MLReference *)wasRepliedTo {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'isrp']];
}

- (MLReference *)window {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'cwin']];
}

- (MLReference *)zoomable {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'iszm']];
}

- (MLReference *)zoomed {
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pzum']];
}


/***********************************/

// ordinal selectors

- (MLReference *)first {
    return [MLReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference first]];
}

- (MLReference *)middle {
    return [MLReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference middle]];
}

- (MLReference *)last {
    return [MLReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference last]];
}

- (MLReference *)any {
    return [MLReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference any]];
}

// by-index, by-name, by-id selectors
 
- (MLReference *)at:(long)index {
    return [MLReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference at: index]];
}

- (MLReference *)byIndex:(id)index { // index is normally NSNumber, but may occasionally be other types
    return [MLReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference byIndex: index]];
}

- (MLReference *)byName:(NSString *)name {
    return [MLReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference byName: name]];
}

- (MLReference *)byID:(id)id_ {
    return [MLReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference byID: id_]];
}

// by-relative-position selectors

- (MLReference *)previous:(ASConstant *)class_ {
    return [MLReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference previous: [class_ AS_code]]];
}

- (MLReference *)next:(ASConstant *)class_ {
    return [MLReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference next: [class_ AS_code]]];
}

// by-range selector

- (MLReference *)at:(long)fromIndex to:(long)toIndex {
    return [MLReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference at: fromIndex to: toIndex]];
}

- (MLReference *)byRange:(id)fromObject to:(id)toObject {
    // takes two con-based references, with other values being expanded as necessary
    if ([fromObject isKindOfClass: [MLReference class]])
        fromObject = [fromObject AS_aemReference];
    if ([toObject isKindOfClass: [MLReference class]])
        toObject = [toObject AS_aemReference];
    return [MLReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference byRange: fromObject to: toObject]];
}

// by-test selector

- (MLReference *)byTest:(MLReference *)testReference {
    // note: getting AS_aemReference won't work for ASDynamicReference
    return [MLReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference byTest: [testReference AS_aemReference]]];
}

// insertion location selectors

- (MLReference *)beginning {
    return [MLReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference beginning]];
}

- (MLReference *)end {
    return [MLReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference end]];
}

- (MLReference *)before {
    return [MLReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference before]];
}

- (MLReference *)after {
    return [MLReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference after]];
}

// Comparison and logic tests

- (MLReference *)greaterThan:(id)object {
    return [MLReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference greaterThan: object]];
}

- (MLReference *)greaterOrEquals:(id)object {
    return [MLReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference greaterOrEquals: object]];
}

- (MLReference *)equals:(id)object {
    return [MLReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference equals: object]];
}

- (MLReference *)notEquals:(id)object {
    return [MLReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference notEquals: object]];
}

- (MLReference *)lessThan:(id)object {
    return [MLReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference lessThan: object]];
}

- (MLReference *)lessOrEquals:(id)object {
    return [MLReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference lessOrEquals: object]];
}

- (MLReference *)beginsWith:(id)object {
    return [MLReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference beginsWith: object]];
}

- (MLReference *)endsWith:(id)object {
    return [MLReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference endsWith: object]];
}

- (MLReference *)contains:(id)object {
    return [MLReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference contains: object]];
}

- (MLReference *)isIn:(id)object {
    return [MLReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference isIn: object]];
}

- (MLReference *)AND:(id)remainingOperands {
    return [MLReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference AND: remainingOperands]];
}

- (MLReference *)OR:(id)remainingOperands {
    return [MLReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference OR: remainingOperands]];
}

- (MLReference *)NOT {
    return [MLReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference NOT]];
}

@end


