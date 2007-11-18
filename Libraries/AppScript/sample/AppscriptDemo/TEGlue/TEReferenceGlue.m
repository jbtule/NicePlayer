/*
 * TEReferenceGlue.m
 *
 * /applications/textedit.app
 * osaglue 0.2.0
 *
 */

#import "TEReferenceGlue.h"

@implementation TEReference

- (NSString *)description {
	return [TEReferenceRenderer render: AS_aemReference];
}

/* Commands */

- (TEActivateCommand *)activate {
    return [TEActivateCommand commandWithAppData: AS_appData
                         eventClass: 'misc'
                            eventID: 'actv'
                    directParameter: nil
                    parentReference: self];
}

- (TEActivateCommand *)activate:(id)directParameter {
    return [TEActivateCommand commandWithAppData: AS_appData
                         eventClass: 'misc'
                            eventID: 'actv'
                    directParameter: directParameter
                    parentReference: self];
}

- (TECloseCommand *)close {
    return [TECloseCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'clos'
                    directParameter: nil
                    parentReference: self];
}

- (TECloseCommand *)close:(id)directParameter {
    return [TECloseCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'clos'
                    directParameter: directParameter
                    parentReference: self];
}

- (TECountCommand *)count {
    return [TECountCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'cnte'
                    directParameter: nil
                    parentReference: self];
}

- (TECountCommand *)count:(id)directParameter {
    return [TECountCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'cnte'
                    directParameter: directParameter
                    parentReference: self];
}

- (TEDeleteCommand *)delete {
    return [TEDeleteCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'delo'
                    directParameter: nil
                    parentReference: self];
}

- (TEDeleteCommand *)delete:(id)directParameter {
    return [TEDeleteCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'delo'
                    directParameter: directParameter
                    parentReference: self];
}

- (TEDuplicateCommand *)duplicate {
    return [TEDuplicateCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'clon'
                    directParameter: nil
                    parentReference: self];
}

- (TEDuplicateCommand *)duplicate:(id)directParameter {
    return [TEDuplicateCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'clon'
                    directParameter: directParameter
                    parentReference: self];
}

- (TEExistsCommand *)exists {
    return [TEExistsCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'doex'
                    directParameter: nil
                    parentReference: self];
}

- (TEExistsCommand *)exists:(id)directParameter {
    return [TEExistsCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'doex'
                    directParameter: directParameter
                    parentReference: self];
}

- (TEGetCommand *)get {
    return [TEGetCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'getd'
                    directParameter: nil
                    parentReference: self];
}

- (TEGetCommand *)get:(id)directParameter {
    return [TEGetCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'getd'
                    directParameter: directParameter
                    parentReference: self];
}

- (TELaunchCommand *)launch {
    return [TELaunchCommand commandWithAppData: AS_appData
                         eventClass: 'ascr'
                            eventID: 'noop'
                    directParameter: nil
                    parentReference: self];
}

- (TELaunchCommand *)launch:(id)directParameter {
    return [TELaunchCommand commandWithAppData: AS_appData
                         eventClass: 'ascr'
                            eventID: 'noop'
                    directParameter: directParameter
                    parentReference: self];
}

- (TEMakeCommand *)make {
    return [TEMakeCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'crel'
                    directParameter: nil
                    parentReference: self];
}

- (TEMakeCommand *)make:(id)directParameter {
    return [TEMakeCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'crel'
                    directParameter: directParameter
                    parentReference: self];
}

- (TEMoveCommand *)move {
    return [TEMoveCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'move'
                    directParameter: nil
                    parentReference: self];
}

- (TEMoveCommand *)move:(id)directParameter {
    return [TEMoveCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'move'
                    directParameter: directParameter
                    parentReference: self];
}

- (TEOpenCommand *)open {
    return [TEOpenCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'odoc'
                    directParameter: nil
                    parentReference: self];
}

- (TEOpenCommand *)open:(id)directParameter {
    return [TEOpenCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'odoc'
                    directParameter: directParameter
                    parentReference: self];
}

- (TEOpenLocationCommand *)openLocation {
    return [TEOpenLocationCommand commandWithAppData: AS_appData
                         eventClass: 'GURL'
                            eventID: 'GURL'
                    directParameter: nil
                    parentReference: self];
}

- (TEOpenLocationCommand *)openLocation:(id)directParameter {
    return [TEOpenLocationCommand commandWithAppData: AS_appData
                         eventClass: 'GURL'
                            eventID: 'GURL'
                    directParameter: directParameter
                    parentReference: self];
}

- (TEPrintCommand *)print {
    return [TEPrintCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'pdoc'
                    directParameter: nil
                    parentReference: self];
}

- (TEPrintCommand *)print:(id)directParameter {
    return [TEPrintCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'pdoc'
                    directParameter: directParameter
                    parentReference: self];
}

- (TEQuitCommand *)quit {
    return [TEQuitCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'quit'
                    directParameter: nil
                    parentReference: self];
}

- (TEQuitCommand *)quit:(id)directParameter {
    return [TEQuitCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'quit'
                    directParameter: directParameter
                    parentReference: self];
}

- (TEReopenCommand *)reopen {
    return [TEReopenCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'rapp'
                    directParameter: nil
                    parentReference: self];
}

- (TEReopenCommand *)reopen:(id)directParameter {
    return [TEReopenCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'rapp'
                    directParameter: directParameter
                    parentReference: self];
}

- (TERunCommand *)run {
    return [TERunCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'oapp'
                    directParameter: nil
                    parentReference: self];
}

- (TERunCommand *)run:(id)directParameter {
    return [TERunCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'oapp'
                    directParameter: directParameter
                    parentReference: self];
}

- (TESaveCommand *)save {
    return [TESaveCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'save'
                    directParameter: nil
                    parentReference: self];
}

- (TESaveCommand *)save:(id)directParameter {
    return [TESaveCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'save'
                    directParameter: directParameter
                    parentReference: self];
}

- (TESetCommand *)set {
    return [TESetCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'setd'
                    directParameter: nil
                    parentReference: self];
}

- (TESetCommand *)set:(id)directParameter {
    return [TESetCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'setd'
                    directParameter: directParameter
                    parentReference: self];
}


/* Elements */

- (TEReference *)applications {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'capp']];
}

- (TEReference *)attachment {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'atts']];
}

- (TEReference *)attributeRuns {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'catr']];
}

- (TEReference *)characters {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cha ']];
}

- (TEReference *)colors {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'colr']];
}

- (TEReference *)documents {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'docu']];
}

- (TEReference *)items {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cobj']];
}

- (TEReference *)paragraphs {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cpar']];
}

- (TEReference *)printSettings {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'pset']];
}

- (TEReference *)text {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'ctxt']];
}

- (TEReference *)windows {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cwin']];
}

- (TEReference *)words {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cwor']];
}


/* Properties */

- (TEReference *)bounds {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pbnd']];
}

- (TEReference *)class_ {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pcls']];
}

- (TEReference *)closeable {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'hclb']];
}

- (TEReference *)collating {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwcl']];
}

- (TEReference *)color {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'colr']];
}

- (TEReference *)copies {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwcp']];
}

- (TEReference *)document {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'docu']];
}

- (TEReference *)endingPage {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwlp']];
}

- (TEReference *)errorHandling {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lweh']];
}

- (TEReference *)faxNumber {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'faxn']];
}

- (TEReference *)fileName {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'atfn']];
}

- (TEReference *)floating {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'isfl']];
}

- (TEReference *)font {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'font']];
}

- (TEReference *)frontmost {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pisf']];
}

- (TEReference *)id_ {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ID  ']];
}

- (TEReference *)index {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pidx']];
}

- (TEReference *)miniaturizable {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ismn']];
}

- (TEReference *)miniaturized {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pmnd']];
}

- (TEReference *)modal {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pmod']];
}

- (TEReference *)modified {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'imod']];
}

- (TEReference *)name {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pnam']];
}

- (TEReference *)pagesAcross {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwla']];
}

- (TEReference *)pagesDown {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwld']];
}

- (TEReference *)path {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ppth']];
}

- (TEReference *)properties {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pALL']];
}

- (TEReference *)requestedPrintTime {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwqt']];
}

- (TEReference *)resizable {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'prsz']];
}

- (TEReference *)size {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ptsz']];
}

- (TEReference *)startingPage {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwfp']];
}

- (TEReference *)targetPrinter {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'trpr']];
}

- (TEReference *)titled {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ptit']];
}

- (TEReference *)version_ {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'vers']];
}

- (TEReference *)visible {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pvis']];
}

- (TEReference *)zoomable {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'iszm']];
}

- (TEReference *)zoomed {
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pzum']];
}


/***********************************/

// ordinal selectors

- (TEReference *)first {
    return [TEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference first]];
}

- (TEReference *)middle {
    return [TEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference middle]];
}

- (TEReference *)last {
    return [TEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference last]];
}

- (TEReference *)any {
    return [TEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference any]];
}

// by-index, by-name, by-id selectors
 
- (TEReference *)at:(long)index {
    return [TEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference at: index]];
}

- (TEReference *)byIndex:(id)index { // index is normally NSNumber, but may occasionally be other types
    return [TEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference byIndex: index]];
}

- (TEReference *)byName:(NSString *)name {
    return [TEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference byName: name]];
}

- (TEReference *)byID:(id)id_ {
    return [TEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference byID: id_]];
}

// by-relative-position selectors

- (TEReference *)previous:(ASConstant *)class_ {
    return [TEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference previous: [class_ AS_code]]];
}

- (TEReference *)next:(ASConstant *)class_ {
    return [TEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference next: [class_ AS_code]]];
}

// by-range selector

- (TEReference *)at:(long)fromIndex to:(long)toIndex {
    return [TEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference at: fromIndex to: toIndex]];
}

- (TEReference *)byRange:(id)fromObject to:(id)toObject {
    // takes two con-based references, with other values being expanded as necessary
    if ([fromObject isKindOfClass: [TEReference class]])
        fromObject = [fromObject AS_aemReference];
    if ([toObject isKindOfClass: [TEReference class]])
        toObject = [toObject AS_aemReference];
    return [TEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference byRange: fromObject to: toObject]];
}

// by-test selector

- (TEReference *)byTest:(TEReference *)testReference {
    // note: getting AS_aemReference won't work for ASDynamicReference
    return [TEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference byTest: [testReference AS_aemReference]]];
}

// insertion location selectors

- (TEReference *)beginning {
    return [TEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference beginning]];
}

- (TEReference *)end {
    return [TEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference end]];
}

- (TEReference *)before {
    return [TEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference before]];
}

- (TEReference *)after {
    return [TEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference after]];
}

// Comparison and logic tests

- (TEReference *)greaterThan:(id)object {
    return [TEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference greaterThan: object]];
}

- (TEReference *)greaterOrEquals:(id)object {
    return [TEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference greaterOrEquals: object]];
}

- (TEReference *)equals:(id)object {
    return [TEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference equals: object]];
}

- (TEReference *)notEquals:(id)object {
    return [TEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference notEquals: object]];
}

- (TEReference *)lessThan:(id)object {
    return [TEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference lessThan: object]];
}

- (TEReference *)lessOrEquals:(id)object {
    return [TEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference lessOrEquals: object]];
}

- (TEReference *)beginsWith:(id)object {
    return [TEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference beginsWith: object]];
}

- (TEReference *)endsWith:(id)object {
    return [TEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference endsWith: object]];
}

- (TEReference *)contains:(id)object {
    return [TEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference contains: object]];
}

- (TEReference *)isIn:(id)object {
    return [TEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference isIn: object]];
}

- (TEReference *)AND:(id)remainingOperands {
    return [TEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference AND: remainingOperands]];
}

- (TEReference *)OR:(id)remainingOperands {
    return [TEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference OR: remainingOperands]];
}

- (TEReference *)NOT {
    return [TEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference NOT]];
}

@end


