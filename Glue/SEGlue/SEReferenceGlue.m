/*
 * SEReferenceGlue.m
 *
 * /System/Library/CoreServices/System Events.app
 * osaglue 0.2.0
 *
 */

#import "SEReferenceGlue.h"

@implementation SEReference

- (NSString *)description {
	return [SEReferenceRenderer render: AS_aemReference];
}

/* Commands */

- (SEAbort_transactionCommand *)abort_transaction {
    return [SEAbort_transactionCommand commandWithAppData: AS_appData
                         eventClass: 'misc'
                            eventID: 'ttrm'
                    directParameter: nil
                    parentReference: self];
}

- (SEAbort_transactionCommand *)abort_transaction:(id)directParameter {
    return [SEAbort_transactionCommand commandWithAppData: AS_appData
                         eventClass: 'misc'
                            eventID: 'ttrm'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEActivateCommand *)activate {
    return [SEActivateCommand commandWithAppData: AS_appData
                         eventClass: 'misc'
                            eventID: 'actv'
                    directParameter: nil
                    parentReference: self];
}

- (SEActivateCommand *)activate:(id)directParameter {
    return [SEActivateCommand commandWithAppData: AS_appData
                         eventClass: 'misc'
                            eventID: 'actv'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEAttach_action_toCommand *)attach_action_to {
    return [SEAttach_action_toCommand commandWithAppData: AS_appData
                         eventClass: 'faco'
                            eventID: 'atfa'
                    directParameter: nil
                    parentReference: self];
}

- (SEAttach_action_toCommand *)attach_action_to:(id)directParameter {
    return [SEAttach_action_toCommand commandWithAppData: AS_appData
                         eventClass: 'faco'
                            eventID: 'atfa'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEAttached_scriptsCommand *)attached_scripts {
    return [SEAttached_scriptsCommand commandWithAppData: AS_appData
                         eventClass: 'faco'
                            eventID: 'lact'
                    directParameter: nil
                    parentReference: self];
}

- (SEAttached_scriptsCommand *)attached_scripts:(id)directParameter {
    return [SEAttached_scriptsCommand commandWithAppData: AS_appData
                         eventClass: 'faco'
                            eventID: 'lact'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEBegin_transactionCommand *)begin_transaction {
    return [SEBegin_transactionCommand commandWithAppData: AS_appData
                         eventClass: 'misc'
                            eventID: 'begi'
                    directParameter: nil
                    parentReference: self];
}

- (SEBegin_transactionCommand *)begin_transaction:(id)directParameter {
    return [SEBegin_transactionCommand commandWithAppData: AS_appData
                         eventClass: 'misc'
                            eventID: 'begi'
                    directParameter: directParameter
                    parentReference: self];
}

- (SECancelCommand *)cancel {
    return [SECancelCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'cncl'
                    directParameter: nil
                    parentReference: self];
}

- (SECancelCommand *)cancel:(id)directParameter {
    return [SECancelCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'cncl'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEClickCommand *)click {
    return [SEClickCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'clic'
                    directParameter: nil
                    parentReference: self];
}

- (SEClickCommand *)click:(id)directParameter {
    return [SEClickCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'clic'
                    directParameter: directParameter
                    parentReference: self];
}

- (SECloseCommand *)close {
    return [SECloseCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'clos'
                    directParameter: nil
                    parentReference: self];
}

- (SECloseCommand *)close:(id)directParameter {
    return [SECloseCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'clos'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEConfirmCommand *)confirm {
    return [SEConfirmCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'cnfm'
                    directParameter: nil
                    parentReference: self];
}

- (SEConfirmCommand *)confirm:(id)directParameter {
    return [SEConfirmCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'cnfm'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEConnectCommand *)connect {
    return [SEConnectCommand commandWithAppData: AS_appData
                         eventClass: 'netz'
                            eventID: 'conn'
                    directParameter: nil
                    parentReference: self];
}

- (SEConnectCommand *)connect:(id)directParameter {
    return [SEConnectCommand commandWithAppData: AS_appData
                         eventClass: 'netz'
                            eventID: 'conn'
                    directParameter: directParameter
                    parentReference: self];
}

- (SECountCommand *)count {
    return [SECountCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'cnte'
                    directParameter: nil
                    parentReference: self];
}

- (SECountCommand *)count:(id)directParameter {
    return [SECountCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'cnte'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEDecrementCommand *)decrement {
    return [SEDecrementCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'decr'
                    directParameter: nil
                    parentReference: self];
}

- (SEDecrementCommand *)decrement:(id)directParameter {
    return [SEDecrementCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'decr'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEDeleteCommand *)delete {
    return [SEDeleteCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'delo'
                    directParameter: nil
                    parentReference: self];
}

- (SEDeleteCommand *)delete:(id)directParameter {
    return [SEDeleteCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'delo'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEDisconnectCommand *)disconnect {
    return [SEDisconnectCommand commandWithAppData: AS_appData
                         eventClass: 'netz'
                            eventID: 'dcon'
                    directParameter: nil
                    parentReference: self];
}

- (SEDisconnectCommand *)disconnect:(id)directParameter {
    return [SEDisconnectCommand commandWithAppData: AS_appData
                         eventClass: 'netz'
                            eventID: 'dcon'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEDo_folder_actionCommand *)do_folder_action {
    return [SEDo_folder_actionCommand commandWithAppData: AS_appData
                         eventClass: 'faco'
                            eventID: 'fola'
                    directParameter: nil
                    parentReference: self];
}

- (SEDo_folder_actionCommand *)do_folder_action:(id)directParameter {
    return [SEDo_folder_actionCommand commandWithAppData: AS_appData
                         eventClass: 'faco'
                            eventID: 'fola'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEDo_scriptCommand *)do_script {
    return [SEDo_scriptCommand commandWithAppData: AS_appData
                         eventClass: 'misc'
                            eventID: 'dosc'
                    directParameter: nil
                    parentReference: self];
}

- (SEDo_scriptCommand *)do_script:(id)directParameter {
    return [SEDo_scriptCommand commandWithAppData: AS_appData
                         eventClass: 'misc'
                            eventID: 'dosc'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEDuplicateCommand *)duplicate {
    return [SEDuplicateCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'clon'
                    directParameter: nil
                    parentReference: self];
}

- (SEDuplicateCommand *)duplicate:(id)directParameter {
    return [SEDuplicateCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'clon'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEEdit_action_ofCommand *)edit_action_of {
    return [SEEdit_action_ofCommand commandWithAppData: AS_appData
                         eventClass: 'faco'
                            eventID: 'edfa'
                    directParameter: nil
                    parentReference: self];
}

- (SEEdit_action_ofCommand *)edit_action_of:(id)directParameter {
    return [SEEdit_action_ofCommand commandWithAppData: AS_appData
                         eventClass: 'faco'
                            eventID: 'edfa'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEEnd_transactionCommand *)end_transaction {
    return [SEEnd_transactionCommand commandWithAppData: AS_appData
                         eventClass: 'misc'
                            eventID: 'endt'
                    directParameter: nil
                    parentReference: self];
}

- (SEEnd_transactionCommand *)end_transaction:(id)directParameter {
    return [SEEnd_transactionCommand commandWithAppData: AS_appData
                         eventClass: 'misc'
                            eventID: 'endt'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEExistsCommand *)exists {
    return [SEExistsCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'doex'
                    directParameter: nil
                    parentReference: self];
}

- (SEExistsCommand *)exists:(id)directParameter {
    return [SEExistsCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'doex'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEGetCommand *)get {
    return [SEGetCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'getd'
                    directParameter: nil
                    parentReference: self];
}

- (SEGetCommand *)get:(id)directParameter {
    return [SEGetCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'getd'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEIncrementCommand *)increment {
    return [SEIncrementCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'incE'
                    directParameter: nil
                    parentReference: self];
}

- (SEIncrementCommand *)increment:(id)directParameter {
    return [SEIncrementCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'incE'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEKey_codeCommand *)key_code {
    return [SEKey_codeCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'kcod'
                    directParameter: nil
                    parentReference: self];
}

- (SEKey_codeCommand *)key_code:(id)directParameter {
    return [SEKey_codeCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'kcod'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEKey_downCommand *)key_down {
    return [SEKey_downCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'keyF'
                    directParameter: nil
                    parentReference: self];
}

- (SEKey_downCommand *)key_down:(id)directParameter {
    return [SEKey_downCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'keyF'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEKey_upCommand *)key_up {
    return [SEKey_upCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'keyU'
                    directParameter: nil
                    parentReference: self];
}

- (SEKey_upCommand *)key_up:(id)directParameter {
    return [SEKey_upCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'keyU'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEKeystrokeCommand *)keystroke {
    return [SEKeystrokeCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'kprs'
                    directParameter: nil
                    parentReference: self];
}

- (SEKeystrokeCommand *)keystroke:(id)directParameter {
    return [SEKeystrokeCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'kprs'
                    directParameter: directParameter
                    parentReference: self];
}

- (SELaunchCommand *)launch {
    return [SELaunchCommand commandWithAppData: AS_appData
                         eventClass: 'ascr'
                            eventID: 'noop'
                    directParameter: nil
                    parentReference: self];
}

- (SELaunchCommand *)launch:(id)directParameter {
    return [SELaunchCommand commandWithAppData: AS_appData
                         eventClass: 'ascr'
                            eventID: 'noop'
                    directParameter: directParameter
                    parentReference: self];
}

- (SELog_outCommand *)log_out {
    return [SELog_outCommand commandWithAppData: AS_appData
                         eventClass: 'fndr'
                            eventID: 'logo'
                    directParameter: nil
                    parentReference: self];
}

- (SELog_outCommand *)log_out:(id)directParameter {
    return [SELog_outCommand commandWithAppData: AS_appData
                         eventClass: 'fndr'
                            eventID: 'logo'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEMakeCommand *)make {
    return [SEMakeCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'crel'
                    directParameter: nil
                    parentReference: self];
}

- (SEMakeCommand *)make:(id)directParameter {
    return [SEMakeCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'crel'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEMoveCommand *)move {
    return [SEMoveCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'move'
                    directParameter: nil
                    parentReference: self];
}

- (SEMoveCommand *)move:(id)directParameter {
    return [SEMoveCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'move'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEOpenCommand *)open {
    return [SEOpenCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'odoc'
                    directParameter: nil
                    parentReference: self];
}

- (SEOpenCommand *)open:(id)directParameter {
    return [SEOpenCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'odoc'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEOpenLocationCommand *)openLocation {
    return [SEOpenLocationCommand commandWithAppData: AS_appData
                         eventClass: 'GURL'
                            eventID: 'GURL'
                    directParameter: nil
                    parentReference: self];
}

- (SEOpenLocationCommand *)openLocation:(id)directParameter {
    return [SEOpenLocationCommand commandWithAppData: AS_appData
                         eventClass: 'GURL'
                            eventID: 'GURL'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEPerformCommand *)perform {
    return [SEPerformCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'perf'
                    directParameter: nil
                    parentReference: self];
}

- (SEPerformCommand *)perform:(id)directParameter {
    return [SEPerformCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'perf'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEPickCommand *)pick {
    return [SEPickCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'pick'
                    directParameter: nil
                    parentReference: self];
}

- (SEPickCommand *)pick:(id)directParameter {
    return [SEPickCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'pick'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEPrintCommand *)print {
    return [SEPrintCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'pdoc'
                    directParameter: nil
                    parentReference: self];
}

- (SEPrintCommand *)print:(id)directParameter {
    return [SEPrintCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'pdoc'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEPrint_Command *)print_ {
    return [SEPrint_Command commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'pdoc'
                    directParameter: nil
                    parentReference: self];
}

- (SEPrint_Command *)print_:(id)directParameter {
    return [SEPrint_Command commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'pdoc'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEQuitCommand *)quit {
    return [SEQuitCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'quit'
                    directParameter: nil
                    parentReference: self];
}

- (SEQuitCommand *)quit:(id)directParameter {
    return [SEQuitCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'quit'
                    directParameter: directParameter
                    parentReference: self];
}

- (SERemove_action_fromCommand *)remove_action_from {
    return [SERemove_action_fromCommand commandWithAppData: AS_appData
                         eventClass: 'faco'
                            eventID: 'rmfa'
                    directParameter: nil
                    parentReference: self];
}

- (SERemove_action_fromCommand *)remove_action_from:(id)directParameter {
    return [SERemove_action_fromCommand commandWithAppData: AS_appData
                         eventClass: 'faco'
                            eventID: 'rmfa'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEReopenCommand *)reopen {
    return [SEReopenCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'rapp'
                    directParameter: nil
                    parentReference: self];
}

- (SEReopenCommand *)reopen:(id)directParameter {
    return [SEReopenCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'rapp'
                    directParameter: directParameter
                    parentReference: self];
}

- (SERestartCommand *)restart {
    return [SERestartCommand commandWithAppData: AS_appData
                         eventClass: 'fndr'
                            eventID: 'rest'
                    directParameter: nil
                    parentReference: self];
}

- (SERestartCommand *)restart:(id)directParameter {
    return [SERestartCommand commandWithAppData: AS_appData
                         eventClass: 'fndr'
                            eventID: 'rest'
                    directParameter: directParameter
                    parentReference: self];
}

- (SERunCommand *)run {
    return [SERunCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'oapp'
                    directParameter: nil
                    parentReference: self];
}

- (SERunCommand *)run:(id)directParameter {
    return [SERunCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'oapp'
                    directParameter: directParameter
                    parentReference: self];
}

- (SESaveCommand *)save {
    return [SESaveCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'save'
                    directParameter: nil
                    parentReference: self];
}

- (SESaveCommand *)save:(id)directParameter {
    return [SESaveCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'save'
                    directParameter: directParameter
                    parentReference: self];
}

- (SESelectCommand *)select {
    return [SESelectCommand commandWithAppData: AS_appData
                         eventClass: 'misc'
                            eventID: 'slct'
                    directParameter: nil
                    parentReference: self];
}

- (SESelectCommand *)select:(id)directParameter {
    return [SESelectCommand commandWithAppData: AS_appData
                         eventClass: 'misc'
                            eventID: 'slct'
                    directParameter: directParameter
                    parentReference: self];
}

- (SESetCommand *)set {
    return [SESetCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'setd'
                    directParameter: nil
                    parentReference: self];
}

- (SESetCommand *)set:(id)directParameter {
    return [SESetCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'setd'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEShut_downCommand *)shut_down {
    return [SEShut_downCommand commandWithAppData: AS_appData
                         eventClass: 'fndr'
                            eventID: 'shut'
                    directParameter: nil
                    parentReference: self];
}

- (SEShut_downCommand *)shut_down:(id)directParameter {
    return [SEShut_downCommand commandWithAppData: AS_appData
                         eventClass: 'fndr'
                            eventID: 'shut'
                    directParameter: directParameter
                    parentReference: self];
}

- (SESleepCommand *)sleep {
    return [SESleepCommand commandWithAppData: AS_appData
                         eventClass: 'fndr'
                            eventID: 'slep'
                    directParameter: nil
                    parentReference: self];
}

- (SESleepCommand *)sleep:(id)directParameter {
    return [SESleepCommand commandWithAppData: AS_appData
                         eventClass: 'fndr'
                            eventID: 'slep'
                    directParameter: directParameter
                    parentReference: self];
}


/* Elements */

- (SEReference *)CD_and_DVD_preferences_object {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'dhao']];
}

- (SEReference *)Classic_domain_objects {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'domc']];
}

- (SEReference *)QuickTime_data {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'qtfd']];
}

- (SEReference *)QuickTime_files {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'qtff']];
}

- (SEReference *)UI_elements {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'uiel']];
}

- (SEReference *)XML_attributes {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'xmla']];
}

- (SEReference *)XML_data {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'xmld']];
}

- (SEReference *)XML_elements {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'xmle']];
}

- (SEReference *)XML_files {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'xmlf']];
}

- (SEReference *)actions {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'actT']];
}

- (SEReference *)aliases {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'alis']];
}

- (SEReference *)annotation {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'anno']];
}

- (SEReference *)appearance_preferences_object {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'apro']];
}

- (SEReference *)application_processes {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'pcap']];
}

- (SEReference *)applications {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'capp']];
}

- (SEReference *)attachment {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'atts']];
}

- (SEReference *)attribute_runs {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'catr']];
}

- (SEReference *)attributes {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'attr']];
}

- (SEReference *)audio_data {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'audd']];
}

- (SEReference *)audio_files {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'audf']];
}

- (SEReference *)browsers {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'broW']];
}

- (SEReference *)busy_indicators {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'busi']];
}

- (SEReference *)buttons {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'butT']];
}

- (SEReference *)characters {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cha ']];
}

- (SEReference *)checkboxes {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'chbx']];
}

- (SEReference *)color_wells {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'colW']];
}

- (SEReference *)colors {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'colr']];
}

- (SEReference *)columns {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'ccol']];
}

- (SEReference *)combo_boxes {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'comB']];
}

- (SEReference *)configurations {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'conF']];
}

- (SEReference *)desk_accessory_processes {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'pcda']];
}

- (SEReference *)desktops {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'dskp']];
}

- (SEReference *)disk_items {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'ditm']];
}

- (SEReference *)disks {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cdis']];
}

- (SEReference *)dock_preferences_object {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'dpao']];
}

- (SEReference *)documents {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'docu']];
}

- (SEReference *)domains {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'doma']];
}

- (SEReference *)drawers {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'draA']];
}

- (SEReference *)expose_preferences_object {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'epao']];
}

- (SEReference *)file_packages {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cpkg']];
}

- (SEReference *)files {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'file']];
}

- (SEReference *)folder_actions {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'foac']];
}

- (SEReference *)folders {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cfol']];
}

- (SEReference *)groups {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'sgrp']];
}

- (SEReference *)grow_areas {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'grow']];
}

- (SEReference *)images {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'imaA']];
}

- (SEReference *)incrementors {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'incr']];
}

- (SEReference *)insertion_preference {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'dhip']];
}

- (SEReference *)interfaces {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'intf']];
}

- (SEReference *)items {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cobj']];
}

- (SEReference *)lists {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'list']];
}

- (SEReference *)local_domain_objects {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'doml']];
}

- (SEReference *)locations {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'loca']];
}

- (SEReference *)login_items {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'logi']];
}

- (SEReference *)menu_bar_items {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'mbri']];
}

- (SEReference *)menu_bars {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'mbar']];
}

- (SEReference *)menu_buttons {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'menB']];
}

- (SEReference *)menu_items {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'menI']];
}

- (SEReference *)menus {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'menE']];
}

- (SEReference *)movie_data {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'movd']];
}

- (SEReference *)movie_files {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'movf']];
}

- (SEReference *)network_domain_objects {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'domn']];
}

- (SEReference *)network_preferences_object {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'neto']];
}

- (SEReference *)outlines {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'outl']];
}

- (SEReference *)paragraphs {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cpar']];
}

- (SEReference *)pop_up_buttons {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'popB']];
}

- (SEReference *)print_settings {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'pset']];
}

- (SEReference *)processes {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'prcs']];
}

- (SEReference *)progress_indicators {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'proI']];
}

- (SEReference *)property_list_files {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'plif']];
}

- (SEReference *)property_list_items {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'plii']];
}

- (SEReference *)radio_buttons {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'radB']];
}

- (SEReference *)radio_groups {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'rgrp']];
}

- (SEReference *)relevance_indicators {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'reli']];
}

- (SEReference *)rows {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'crow']];
}

- (SEReference *)screen_corner {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'epsc']];
}

- (SEReference *)scripts {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'scpt']];
}

- (SEReference *)scroll_areas {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'scra']];
}

- (SEReference *)scroll_bars {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'scrb']];
}

- (SEReference *)security_preferences_object {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'seco']];
}

- (SEReference *)services {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'svce']];
}

- (SEReference *)sheets {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'sheE']];
}

- (SEReference *)shortcut {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'epst']];
}

- (SEReference *)sliders {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'sliI']];
}

- (SEReference *)spaces_preferences_object {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'spsp']];
}

- (SEReference *)spaces_shortcut {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'spst']];
}

- (SEReference *)splitter_groups {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'splg']];
}

- (SEReference *)splitters {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'splr']];
}

- (SEReference *)static_texts {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'sttx']];
}

- (SEReference *)system_domain_objects {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'doms']];
}

- (SEReference *)tab_groups {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'tabg']];
}

- (SEReference *)tables {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'tabB']];
}

- (SEReference *)text {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'ctxt']];
}

- (SEReference *)text_areas {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'txta']];
}

- (SEReference *)text_fields {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'txtf']];
}

- (SEReference *)tool_bars {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'tbar']];
}

- (SEReference *)tracks {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'trak']];
}

- (SEReference *)user_domain_objects {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'domu']];
}

- (SEReference *)users {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'uacc']];
}

- (SEReference *)value_indicators {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'vali']];
}

- (SEReference *)windows {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cwin']];
}

- (SEReference *)words {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cwor']];
}


/* Properties */

- (SEReference *)CD_and_DVD_preferences {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dhas']];
}

- (SEReference *)Classic {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'clsc']];
}

- (SEReference *)Classic_domain {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'fldc']];
}

- (SEReference *)Folder_Action_scripts_folder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'fasf']];
}

- (SEReference *)MAC_address {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'maca']];
}

- (SEReference *)POSIX_path {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'posx']];
}

- (SEReference *)UI_elements_enabled {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'uien']];
}

- (SEReference *)URL {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'url ']];
}

- (SEReference *)accepts_high_level_events {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'isab']];
}

- (SEReference *)accepts_remote_events {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'revt']];
}

- (SEReference *)account_name {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'user']];
}

- (SEReference *)active {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'acti']];
}

- (SEReference *)activity {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'epsa']];
}

- (SEReference *)all_windows_shortcut {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'epaw']];
}

- (SEReference *)animate {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dani']];
}

- (SEReference *)appearance {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'appe']];
}

- (SEReference *)appearance_preferences {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'aprp']];
}

- (SEReference *)apple_menu_folder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'amnu']];
}

- (SEReference *)application_bindings {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'spcs']];
}

- (SEReference *)application_file {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'appf']];
}

- (SEReference *)application_support_folder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'asup']];
}

- (SEReference *)application_windows_shortcut {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'eppw']];
}

- (SEReference *)applications_folder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'apps']];
}

- (SEReference *)architecture {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'arch']];
}

- (SEReference *)arrow_key_modifiers {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'spam']];
}

- (SEReference *)audio_channel_count {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'acha']];
}

- (SEReference *)audio_characteristic {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'audi']];
}

- (SEReference *)audio_sample_rate {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'asra']];
}

- (SEReference *)audio_sample_size {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'assz']];
}

- (SEReference *)auto_play {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'autp']];
}

- (SEReference *)auto_present {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'apre']];
}

- (SEReference *)auto_quit_when_done {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'aqui']];
}

- (SEReference *)autohide {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dahd']];
}

- (SEReference *)automatic {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'auto']];
}

- (SEReference *)automatic_login {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'aulg']];
}

- (SEReference *)background_only {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'bkgo']];
}

- (SEReference *)blank_CD {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dhbc']];
}

- (SEReference *)blank_DVD {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dhbd']];
}

- (SEReference *)bottom_left_screen_corner {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'epbl']];
}

- (SEReference *)bottom_right_screen_corner {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'epbr']];
}

- (SEReference *)bounds {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pbnd']];
}

- (SEReference *)bundle_identifier {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'bnid']];
}

- (SEReference *)busy_status {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'busy']];
}

- (SEReference *)capacity {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'capa']];
}

- (SEReference *)change_interval {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'cinT']];
}

- (SEReference *)class_ {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pcls']];
}

- (SEReference *)closeable {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'hclb']];
}

- (SEReference *)collating {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwcl']];
}

- (SEReference *)color {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'colr']];
}

- (SEReference *)connected {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'conn']];
}

- (SEReference *)container {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ctnr']];
}

- (SEReference *)contents {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pcnt']];
}

- (SEReference *)control_panels_folder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ctrl']];
}

- (SEReference *)control_strip_modules_folder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'sdev']];
}

- (SEReference *)copies {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwcp']];
}

- (SEReference *)creation_date {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ascd']];
}

- (SEReference *)creation_time {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'mdcr']];
}

- (SEReference *)creator_type {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'fcrt']];
}

- (SEReference *)current_configuration {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'cnfg']];
}

- (SEReference *)current_desktop {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'curd']];
}

- (SEReference *)current_location {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'locc']];
}

- (SEReference *)current_user {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'curu']];
}

- (SEReference *)custom_application {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dhca']];
}

- (SEReference *)custom_script {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dhcs']];
}

- (SEReference *)dashboard_shortcut {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'epdb']];
}

- (SEReference *)data_format {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'tdfr']];
}

- (SEReference *)data_rate {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ddra']];
}

- (SEReference *)data_size {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dsiz']];
}

- (SEReference *)default_application {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'asda']];
}



- (SEReference *)desk_accessory_file {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dafi']];
}

- (SEReference *)desktop_folder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'desk']];
}

- (SEReference *)desktop_pictures_folder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dtp$']];
}

- (SEReference *)dimensions {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pdim']];
}

- (SEReference *)display_name {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dnaM']];
}

- (SEReference *)displayed_name {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dnam']];
}

- (SEReference *)dock_preferences {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dpas']];
}

- (SEReference *)dock_size {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dsze']];
}

- (SEReference *)document {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'docu']];
}

- (SEReference *)documents_folder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'docs']];
}

- (SEReference *)double_click_minimizes {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'mndc']];
}

- (SEReference *)downloads_folder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'down']];
}

- (SEReference *)duplex {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dupl']];
}

- (SEReference *)duration {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'durn']];
}

- (SEReference *)ejectable {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'isej']];
}

- (SEReference *)enabled {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'enaB']];
}

- (SEReference *)ending_page {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwlp']];
}

- (SEReference *)entire_contents {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ects']];
}

- (SEReference *)error_handling {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lweh']];
}

- (SEReference *)expose_preferences {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'epas']];
}

- (SEReference *)extensions_folder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'extz']];
}

- (SEReference *)favorites_folder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'favs']];
}

- (SEReference *)fax_number {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'faxn']];
}

- (SEReference *)file {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'file']];
}

- (SEReference *)file_name {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'atfn']];
}

- (SEReference *)file_type {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'asty']];
}

- (SEReference *)floating {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'isfl']];
}

- (SEReference *)focused {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'focu']];
}

- (SEReference *)folder_actions_enabled {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'faen']];
}

- (SEReference *)font {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'font']];
}

- (SEReference *)font_smoothing_limit {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ftsm']];
}

- (SEReference *)font_smoothing_style {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ftss']];
}

- (SEReference *)fonts_folder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'font']];
}

- (SEReference *)format {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dfmt']];
}

- (SEReference *)free_space {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'frsp']];
}

- (SEReference *)frontmost {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pisf']];
}

- (SEReference *)full_name {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'fnam']];
}

- (SEReference *)full_text {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'anot']];
}

- (SEReference *)function_key {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'epsk']];
}

- (SEReference *)function_key_modifiers {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'epsy']];
}

- (SEReference *)has_scripting_terminology {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'hscr']];
}

- (SEReference *)help_ {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'help']];
}

- (SEReference *)hidden {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'hidn']];
}

- (SEReference *)high_quality {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'hqua']];
}

- (SEReference *)highlight_color {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'hico']];
}

- (SEReference *)home_directory {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'home']];
}

- (SEReference *)home_folder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'cusr']];
}

- (SEReference *)href {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'href']];
}

- (SEReference *)id {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ID  ']];
}

- (SEReference *)id_ {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ID  ']];
}

- (SEReference *)ignore_privileges {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'igpr']];
}

- (SEReference *)index {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pidx']];
}

- (SEReference *)insertion_action {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dhat']];
}

- (SEReference *)interface {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'intf']];
}

- (SEReference *)key_modifiers {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'spky']];
}

- (SEReference *)kind {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'kind']];
}

- (SEReference *)launcher_items_folder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'laun']];
}

- (SEReference *)library_folder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dlib']];
}

- (SEReference *)local_domain {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'fldl']];
}

- (SEReference *)local_volume {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'isrv']];
}

- (SEReference *)location {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dplo']];
}

- (SEReference *)log_out_when_inactive {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'aclk']];
}

- (SEReference *)log_out_when_inactive_interval {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'acto']];
}

- (SEReference *)looping {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'loop']];
}

- (SEReference *)magnification {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dmag']];
}

- (SEReference *)magnification_size {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dmsz']];
}

- (SEReference *)maximum_value {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'maxV']];
}

- (SEReference *)miniaturizable {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ismn']];
}

- (SEReference *)miniaturized {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pmnd']];
}

- (SEReference *)minimize_effect {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'deff']];
}

- (SEReference *)minimum_value {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'minW']];
}

- (SEReference *)modal {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pmod']];
}

- (SEReference *)modification_date {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'asmo']];
}

- (SEReference *)modification_time {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'mdtm']];
}

- (SEReference *)modified {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'imod']];
}

- (SEReference *)modifiers {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'epso']];
}

- (SEReference *)mouse_button {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'epsb']];
}

- (SEReference *)mouse_button_modifiers {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'epsm']];
}

- (SEReference *)movies_folder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'mdoc']];
}

- (SEReference *)mtu {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'mtu ']];
}

- (SEReference *)music_CD {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dhmc']];
}

- (SEReference *)music_folder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: '%doc']];
}

- (SEReference *)name {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pnam']];
}

- (SEReference *)name_extension {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'extn']];
}

- (SEReference *)natural_dimensions {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ndim']];
}

- (SEReference *)network_domain {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'fldn']];
}

- (SEReference *)network_preferences {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'netp']];
}

- (SEReference *)numbers_key_modifiers {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'spnm']];
}

- (SEReference *)orientation {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'orie']];
}

- (SEReference *)package_folder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pkgf']];
}

- (SEReference *)pages_across {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwla']];
}

- (SEReference *)pages_down {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwld']];
}

- (SEReference *)partition_space_used {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pusd']];
}

- (SEReference *)path {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ppth']];
}

- (SEReference *)physical_size {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'phys']];
}

- (SEReference *)picture {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'picP']];
}

- (SEReference *)picture_CD {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dhpc']];
}

- (SEReference *)picture_path {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'picp']];
}

- (SEReference *)picture_rotation {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'chnG']];
}

- (SEReference *)pictures_folder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pdoc']];
}

- (SEReference *)position {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'posn']];
}

- (SEReference *)preferences_folder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pref']];
}

- (SEReference *)preferred_rate {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'prfr']];
}

- (SEReference *)preferred_volume {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'prfv']];
}

- (SEReference *)presentation_mode {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'prmd']];
}

- (SEReference *)presentation_size {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'prsz']];
}

- (SEReference *)preview_duration {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pvwd']];
}

- (SEReference *)preview_time {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pvwt']];
}

- (SEReference *)product_version {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ver2']];
}

- (SEReference *)properties {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pALL']];
}

- (SEReference *)public_folder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pubb']];
}

- (SEReference *)quit_delay {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'qdel']];
}

- (SEReference *)random_order {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ranD']];
}

- (SEReference *)recent_applications_limit {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'rapl']];
}

- (SEReference *)recent_documents_limit {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'rdcl']];
}

- (SEReference *)recent_servers_limit {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'rsvl']];
}

- (SEReference *)requested_print_time {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwqt']];
}

- (SEReference *)require_password_to_unlock {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pwul']];
}

- (SEReference *)require_password_to_wake {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pwwk']];
}

- (SEReference *)resizable {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'prsz']];
}

- (SEReference *)role {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'role']];
}

- (SEReference *)script_menu_enabled {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'scmn']];
}

- (SEReference *)scripting_additions_folder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: '$scr']];
}

- (SEReference *)scripts_folder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'scr$']];
}

- (SEReference *)scroll_arrow_placement {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'sclp']];
}

- (SEReference *)scroll_bar_action {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'sclb']];
}

- (SEReference *)secure_virtual_memory {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'scvm']];
}

- (SEReference *)security_preferences {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'secp']];
}

- (SEReference *)selected {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'selE']];
}

- (SEReference *)server {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'srvr']];
}

- (SEReference *)settable {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'stbl']];
}

- (SEReference *)shared_documents_folder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'sdat']];
}

- (SEReference *)short_name {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'cfbn']];
}

- (SEReference *)short_version {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'assv']];
}

- (SEReference *)show_desktop_shortcut {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'epde']];
}

- (SEReference *)show_spaces_shortcut {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'spcs']];
}

- (SEReference *)shutdown_folder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'shdf']];
}

- (SEReference *)sites_folder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'site']];
}

- (SEReference *)size {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ptsz']];
}

- (SEReference *)smooth_scrolling {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'scls']];
}

- (SEReference *)spaces_columns {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'spcl']];
}

- (SEReference *)spaces_enabled {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'spen']];
}

- (SEReference *)spaces_preferences {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'essp']];
}

- (SEReference *)spaces_rows {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'sprw']];
}

- (SEReference *)speakable_items_folder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'spki']];
}

- (SEReference *)speed {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'sped']];
}

- (SEReference *)start_time {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'offs']];
}

- (SEReference *)starting_page {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwfp']];
}

- (SEReference *)startup {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'istd']];
}

- (SEReference *)startup_disk {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'sdsk']];
}

- (SEReference *)startup_items_folder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'empz']];
}

- (SEReference *)stationery {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pspd']];
}

- (SEReference *)stored_stream {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'isss']];
}

- (SEReference *)subrole {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'sbrl']];
}

- (SEReference *)system_domain {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'flds']];
}

- (SEReference *)system_folder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'macs']];
}

- (SEReference *)target_printer {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'trpr']];
}

- (SEReference *)temporary_items_folder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'temp']];
}

- (SEReference *)time_scale {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'tmsc']];
}

- (SEReference *)title {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'titl']];
}

- (SEReference *)titled {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ptit']];
}

- (SEReference *)top_left_screen_corner {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'eptl']];
}

- (SEReference *)top_right_screen_corner {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'eptr']];
}

- (SEReference *)total_partition_size {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'appt']];
}

- (SEReference *)trash {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'trsh']];
}

- (SEReference *)type {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ptyp']];
}

- (SEReference *)type_class {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'type']];
}

- (SEReference *)type_identifier {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'utid']];
}

- (SEReference *)unix_id {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'idux']];
}

- (SEReference *)user_domain {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'fldu']];
}

- (SEReference *)utilities_folder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'uti$']];
}

- (SEReference *)value {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'valL']];
}

- (SEReference *)version {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'vers']];
}

- (SEReference *)video_DVD {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dhvd']];
}

- (SEReference *)video_depth {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'vcdp']];
}

- (SEReference *)visible {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pvis']];
}

- (SEReference *)visual_characteristic {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'visu']];
}

- (SEReference *)volume {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'volu']];
}

- (SEReference *)workflows_folder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'flow']];
}

- (SEReference *)zone {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'zone']];
}

- (SEReference *)zoomable {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'iszm']];
}

- (SEReference *)zoomed {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pzum']];
}


/***********************************/

// ordinal selectors

- (SEReference *)first {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference first]];
}

- (SEReference *)middle {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference middle]];
}

- (SEReference *)last {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference last]];
}

- (SEReference *)any {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference any]];
}

// by-index, by-name, by-id selectors
 
- (SEReference *)at:(long)anIndex {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference at: anIndex]];
}

- (SEReference *)byIndex:(id)anIndex { // index is normally NSNumber, but may occasionally be other types
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference byIndex: anIndex]];
}

- (SEReference *)byName:(NSString *)name {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference byName: name]];
}

- (SEReference *)byID:(id)id_ {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference byID: id_]];
}

// by-relative-position selectors

- (SEReference *)previous:(ASConstant *)class_ {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference previous: [class_ AS_code]]];
}

- (SEReference *)next:(ASConstant *)class_ {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference next: [class_ AS_code]]];
}

// by-range selector

- (SEReference *)at:(long)fromIndex to:(long)toIndex {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference at: fromIndex to: toIndex]];
}

- (SEReference *)byRange:(id)fromObject to:(id)toObject {
    // takes two con-based references, with other values being expanded as necessary
    if ([fromObject isKindOfClass: [SEReference class]])
        fromObject = [fromObject AS_aemReference];
    if ([toObject isKindOfClass: [SEReference class]])
        toObject = [toObject AS_aemReference];
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference byRange: fromObject to: toObject]];
}

// by-test selector

- (SEReference *)byTest:(SEReference *)testReference {
    // note: getting AS_aemReference won't work for ASDynamicReference
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference byTest: [testReference AS_aemReference]]];
}

// insertion location selectors

- (SEReference *)beginning {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference beginning]];
}

- (SEReference *)end {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference end]];
}

- (SEReference *)before {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference before]];
}

- (SEReference *)after {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference after]];
}

// Comparison and logic tests

- (SEReference *)greaterThan:(id)object {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference greaterThan: object]];
}

- (SEReference *)greaterOrEquals:(id)object {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference greaterOrEquals: object]];
}

- (SEReference *)equals:(id)object {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference equals: object]];
}

- (SEReference *)notEquals:(id)object {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference notEquals: object]];
}

- (SEReference *)lessThan:(id)object {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference lessThan: object]];
}

- (SEReference *)lessOrEquals:(id)object {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference lessOrEquals: object]];
}

- (SEReference *)beginsWith:(id)object {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference beginsWith: object]];
}

- (SEReference *)endsWith:(id)object {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference endsWith: object]];
}

- (SEReference *)contains:(id)object {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference contains: object]];
}

- (SEReference *)isIn:(id)object {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference isIn: object]];
}

- (SEReference *)AND:(id)remainingOperands {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference AND: remainingOperands]];
}

- (SEReference *)OR:(id)remainingOperands {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference OR: remainingOperands]];
}

- (SEReference *)NOT {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference NOT]];
}

@end


