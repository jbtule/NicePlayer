//
//  NSApplication-JTAdditions.m
//  IndyKit
//
//  Created by James Tuley on Tue Jul 06 2004.
//  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
//

#import "NSApplication-JTAdditions.h"
#import <HodgePodge/IndyKit.h>
#define AUTO_UPDATE_PREFEERENCE @"indy.jt.autoUpdateCheck"
#define LocalizeIt(arg) NSLocalizedStringFromTableInBundle(arg, nil,[NSBundle bundleForClass:[self class]],@"no comment")


BOOL HPDGselectNewerVersion(id each,void* context){
    return ([each caseInsensitiveCompare:(NSString*)context] == NSOrderedDescending);
}

id HPDGmergeData(id each, id object, void* context){
    id tAttrString =[[[NSMutableAttributedString alloc]initWithRTFD:[[(NSDictionary*)context objectForKey:each] objectForKey:@"Changes"]documentAttributes:nil] autorelease];
    [tAttrString appendAttributedString:object];
    return tAttrString;
}

@implementation NSApplication (JTAdditions)

-(IBAction)emailAuthor:(id)sender{
    id tempInfo =[[NSBundle mainBundle] infoDictionary];
    id tempEmail =[tempInfo objectForKey:@"JTAuthorEmail"];
    if(tempEmail == nil){
        NSRunAlertPanel(@"Email", LocalizeIt(@"Contact email address not provided by author."), @"Okay",nil,nil);
    }else{
        NSLog([NSString stringWithFormat:@"mailto:%@?subject=%@/%@(v%@)",tempEmail,[tempInfo objectForKey:@"CFBundleName"],[tempInfo objectForKey:@"CFBundleShortVersionString"],[tempInfo objectForKey:@"CFBundleVersion"],nil]);
        [[NSWorkspace sharedWorkspace ]openURL: [NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@?subject=%@/%@(v%@)",tempEmail,[tempInfo objectForKey:@"CFBundleName"],[tempInfo objectForKey:@"CFBundleShortVersionString"],[tempInfo objectForKey:@"CFBundleVersion"],nil]]];
    }
}

@end
