/*
 * TEConstantGlue.m
 *
 * /applications/textedit.app
 * osaglue 0.2.0
 *
 */

#import "TEConstantGlue.h"

@implementation TEConstant

+ (id)constantWithCode:(OSType)code_ {
    switch (code_) {
        case 'capp': return [self application];
        case 'ask ': return [self ask];
        case 'atts': return [self attachment];
        case 'catr': return [self attributeRun];
        case 'pbnd': return [self bounds];
        case 'cha ': return [self character];
        case 'pcls': return [self class_];
        case 'hclb': return [self closeable];
        case 'lwcl': return [self collating];
        case 'colr': return [self color];
        case 'lwcp': return [self copies];
        case 'lwdt': return [self detailed];
        case 'docu': return [self document];
        case 'lwlp': return [self endingPage];
        case 'lweh': return [self errorHandling];
        case 'faxn': return [self faxNumber];
        case 'atfn': return [self fileName];
        case 'isfl': return [self floating];
        case 'font': return [self font];
        case 'pisf': return [self frontmost];
        case 'ID  ': return [self id_];
        case 'pidx': return [self index];
        case 'cobj': return [self item];
        case 'ismn': return [self miniaturizable];
        case 'pmnd': return [self miniaturized];
        case 'pmod': return [self modal];
        case 'imod': return [self modified];
        case 'pnam': return [self name];
        case 'no  ': return [self no];
        case 'lwla': return [self pagesAcross];
        case 'lwld': return [self pagesDown];
        case 'cpar': return [self paragraph];
        case 'ppth': return [self path];
        case 'pset': return [self printSettings];
        case 'pALL': return [self properties];
        case 'lwqt': return [self requestedPrintTime];
        case 'prsz': return [self resizable];
        case 'ptsz': return [self size];
        case 'lwst': return [self standard];
        case 'lwfp': return [self startingPage];
        case 'trpr': return [self targetPrinter];
        case 'ctxt': return [self text];
        case 'ptit': return [self titled];
        case 'vers': return [self version_];
        case 'pvis': return [self visible];
        case 'cwin': return [self window];
        case 'cwor': return [self word];
        case 'yes ': return [self yes];
        case 'iszm': return [self zoomable];
        case 'pzum': return [self zoomed];
        default: return [[self superclass] constantWithCode: code_];
    }
}


/* Enumerators */

+ (TEConstant *)ask {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"ask" type: typeEnumerated code: 'ask '];
    return constantObj;
}

+ (TEConstant *)detailed {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"detailed" type: typeEnumerated code: 'lwdt'];
    return constantObj;
}

+ (TEConstant *)no {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"no" type: typeEnumerated code: 'no  '];
    return constantObj;
}

+ (TEConstant *)standard {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"standard" type: typeEnumerated code: 'lwst'];
    return constantObj;
}

+ (TEConstant *)yes {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"yes" type: typeEnumerated code: 'yes '];
    return constantObj;
}


/* Types and properties */

+ (TEConstant *)application {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"application" type: typeType code: 'capp'];
    return constantObj;
}

+ (TEConstant *)attachment {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"attachment" type: typeType code: 'atts'];
    return constantObj;
}

+ (TEConstant *)attributeRun {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"attributeRun" type: typeType code: 'catr'];
    return constantObj;
}

+ (TEConstant *)bounds {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"bounds" type: typeType code: 'pbnd'];
    return constantObj;
}

+ (TEConstant *)character {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"character" type: typeType code: 'cha '];
    return constantObj;
}

+ (TEConstant *)class_ {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"class_" type: typeType code: 'pcls'];
    return constantObj;
}

+ (TEConstant *)closeable {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"closeable" type: typeType code: 'hclb'];
    return constantObj;
}

+ (TEConstant *)collating {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"collating" type: typeType code: 'lwcl'];
    return constantObj;
}

+ (TEConstant *)color {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"color" type: typeType code: 'colr'];
    return constantObj;
}

+ (TEConstant *)copies {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"copies" type: typeType code: 'lwcp'];
    return constantObj;
}

+ (TEConstant *)document {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"document" type: typeType code: 'docu'];
    return constantObj;
}

+ (TEConstant *)endingPage {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"endingPage" type: typeType code: 'lwlp'];
    return constantObj;
}

+ (TEConstant *)errorHandling {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"errorHandling" type: typeType code: 'lweh'];
    return constantObj;
}

+ (TEConstant *)faxNumber {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"faxNumber" type: typeType code: 'faxn'];
    return constantObj;
}

+ (TEConstant *)fileName {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"fileName" type: typeType code: 'atfn'];
    return constantObj;
}

+ (TEConstant *)floating {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"floating" type: typeType code: 'isfl'];
    return constantObj;
}

+ (TEConstant *)font {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"font" type: typeType code: 'font'];
    return constantObj;
}

+ (TEConstant *)frontmost {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"frontmost" type: typeType code: 'pisf'];
    return constantObj;
}

+ (TEConstant *)id_ {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"id_" type: typeType code: 'ID  '];
    return constantObj;
}

+ (TEConstant *)index {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"index" type: typeType code: 'pidx'];
    return constantObj;
}

+ (TEConstant *)item {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"item" type: typeType code: 'cobj'];
    return constantObj;
}

+ (TEConstant *)miniaturizable {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"miniaturizable" type: typeType code: 'ismn'];
    return constantObj;
}

+ (TEConstant *)miniaturized {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"miniaturized" type: typeType code: 'pmnd'];
    return constantObj;
}

+ (TEConstant *)modal {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"modal" type: typeType code: 'pmod'];
    return constantObj;
}

+ (TEConstant *)modified {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"modified" type: typeType code: 'imod'];
    return constantObj;
}

+ (TEConstant *)name {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"name" type: typeType code: 'pnam'];
    return constantObj;
}

+ (TEConstant *)pagesAcross {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"pagesAcross" type: typeType code: 'lwla'];
    return constantObj;
}

+ (TEConstant *)pagesDown {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"pagesDown" type: typeType code: 'lwld'];
    return constantObj;
}

+ (TEConstant *)paragraph {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"paragraph" type: typeType code: 'cpar'];
    return constantObj;
}

+ (TEConstant *)path {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"path" type: typeType code: 'ppth'];
    return constantObj;
}

+ (TEConstant *)printSettings {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"printSettings" type: typeType code: 'pset'];
    return constantObj;
}

+ (TEConstant *)properties {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"properties" type: typeType code: 'pALL'];
    return constantObj;
}

+ (TEConstant *)requestedPrintTime {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"requestedPrintTime" type: typeType code: 'lwqt'];
    return constantObj;
}

+ (TEConstant *)resizable {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"resizable" type: typeType code: 'prsz'];
    return constantObj;
}

+ (TEConstant *)size {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"size" type: typeType code: 'ptsz'];
    return constantObj;
}

+ (TEConstant *)startingPage {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"startingPage" type: typeType code: 'lwfp'];
    return constantObj;
}

+ (TEConstant *)targetPrinter {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"targetPrinter" type: typeType code: 'trpr'];
    return constantObj;
}

+ (TEConstant *)text {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"text" type: typeType code: 'ctxt'];
    return constantObj;
}

+ (TEConstant *)titled {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"titled" type: typeType code: 'ptit'];
    return constantObj;
}

+ (TEConstant *)version_ {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"version_" type: typeType code: 'vers'];
    return constantObj;
}

+ (TEConstant *)visible {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"visible" type: typeType code: 'pvis'];
    return constantObj;
}

+ (TEConstant *)window {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"window" type: typeType code: 'cwin'];
    return constantObj;
}

+ (TEConstant *)word {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"word" type: typeType code: 'cwor'];
    return constantObj;
}

+ (TEConstant *)zoomable {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"zoomable" type: typeType code: 'iszm'];
    return constantObj;
}

+ (TEConstant *)zoomed {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"zoomed" type: typeType code: 'pzum'];
    return constantObj;
}

@end


