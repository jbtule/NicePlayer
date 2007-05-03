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

-(BOOL)allowAutomaticCheckForUpdates{
    [self _JTsetUpUpdatePreferences];
    return [[NSUserDefaults standardUserDefaults] boolForKey:AUTO_UPDATE_PREFEERENCE];
}

-(void)setAllowAutomaticCheckForUpdates:(BOOL)aBool{
    [[NSUserDefaults standardUserDefaults] setBool:aBool forKey:AUTO_UPDATE_PREFEERENCE];
}

-(IBAction)automaticCheckForUpdates:(id)sender{      
    
    [NSThread detachNewThreadSelector:@selector(_JTcheckForUpdatesWithNegativeResponse:) toTarget:self withObject:[NSNumber numberWithBool:NO]];
}

-(IBAction)checkForUpdates:(id)sender{      
    
    [NSThread detachNewThreadSelector:@selector(_JTcheckForUpdatesWithNegativeResponse:) toTarget:self withObject:[NSNumber numberWithBool:YES]];
}


-(void)_JTgiveError:(NSString*)aString silent:(BOOL)aBool{
    
    if(aBool)
        NSLog(aString);
    else
        [self performSelectorOnMainThread:@selector(_JTRunErrorPanel:) withObject:aString waitUntilDone:NO];
    
}

-(void)_JTRunErrorPanel:(id)aMessage{
    NSRunInformationalAlertPanel(@"Update Check",aMessage,
                                 @"Okay", nil,nil);
}

-(void)_JTsetUpUpdatePreferences{
    if([[NSUserDefaults standardUserDefaults]objectForKey:AUTO_UPDATE_PREFEERENCE] ==nil){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:AUTO_UPDATE_PREFEERENCE];
        NSLog(@"set pref for auto update");
    }
}

-(void)_JTcheckForUpdatesWithNegativeResponse:(NSNumber*)aResponse{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    [self _JTsetUpUpdatePreferences];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:AUTO_UPDATE_PREFEERENCE]
       && ![aResponse boolValue]){
        return;
    }
    
    id tempInfo =[[NSBundle mainBundle] infoDictionary];
    id tempStringURL =[tempInfo objectForKey:@"JTUpdateURL"];
        
    id tempURL =[NSURL URLWithString:tempStringURL];
    
    id tempDict = [NSDictionary dictionaryWithContentsOfURL:tempURL];
    
    if(tempDict == nil){
        [self _JTgiveError:LocalizeIt(@"Cannot contact update server...") silent:![aResponse boolValue]];
        return;
    }
    
    
    id tempData =  [NSPropertyListSerialization dataFromPropertyList:tempDict format:NSPropertyListXMLFormat_v1_0 errorDescription:nil];
    
    if([self delegate] != nil && [[self delegate] respondsToSelector:@selector(updateCheckPublicKey)]){
        
        id tempSigStringURL =[[tempStringURL mutableCopy] autorelease];
        
        [tempSigStringURL replaceOccurrencesOfString:@".indyUpdate" withString:@".sig" options:NSCaseInsensitiveSearch range:NSMakeRange(0,[tempSigStringURL length])];
        
        id tempSigData = [NSData dataWithContentsOfURL:[NSURL URLWithString:tempSigStringURL]];
        
        id tPubKey=[JTPublicCryptKey keyWithData:[[[self delegate] updateCheckPublicKey] propertyList] withAlgortihm:CSSM_ALGID_RSA];
        
        if(![tPubKey verifyData:tempData withSignature:tempSigData]){
            [self _JTgiveError:LocalizeIt(@"Cannot contact update server...") silent:![aResponse boolValue]];
            return;
        }else{
            NSLog(@"Verified");
        }
    }
    
    if([[tempDict objectForKey:@"Version"]isEqualTo:[NSNumber numberWithInt:1]]){
        [self _JTParseVersion1Update:tempDict withBundleInfo:tempInfo negativeResponse:aResponse];
    }else if([[tempDict objectForKey:@"Major Version"] isEqualTo:[NSNumber numberWithInt:2]]){
        [self _JTParseVersion2Update:tempDict withBundleInfo:tempInfo negativeResponse:aResponse];
    }
  
    [pool release];
}

-(void)_JTParseVersion2Update:(id)tempDict withBundleInfo:(id)tempInfo negativeResponse:(id)aResponse{
    id newInfo =[[tempDict objectForKey:@"Contents"] objectForKey:[tempInfo objectForKey:@"CFBundleName"]];
    
    NSString* tVersion= [tempInfo objectForKey:@"CFBundleVersion"];
    

    
    NSArray* tVersions = [[newInfo allKeys] selectUsingFunction:HPDGselectNewerVersion context:(void *)tVersion];
    
    if([tVersions isEmpty]){
        [self _JTgiveError:LocalizeIt(@"No new version") silent:![aResponse boolValue]];
        return;
    }
    
    tVersions =[tVersions sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    tVersion =[tVersions lastObject];
    

    
    NSAttributedString* tChanges =[tVersions injectUsingFunction:HPDGmergeData 
                                                            into:[[[NSMutableAttributedString alloc] init]autorelease] 
                                                         context:(void*)newInfo];
    
    newInfo =[newInfo objectForKey:tVersion];
    
    id tPassToWindow =[NSDictionary dictionaryWithObjectsAndKeys:[tempInfo objectForKey:@"CFBundleName"],@"BundleName",tVersion,@"BundleVersion",[newInfo objectForKey:@"HumanVersion"],@"HumanVersion",tChanges,@"Changes",[newInfo objectForKey:@"URL"],@"URL",nil];
    
    [self performSelectorOnMainThread:@selector(_JTOrderUpTheWindow:) withObject:tPassToWindow waitUntilDone:NO];
   
}

-(void)_JTParseVersion1Update:(id)tempDict withBundleInfo:(id)tempInfo negativeResponse:(id)aResponse{
    id newInfo =[[tempDict objectForKey:@"Contents"] objectForKey:[tempInfo objectForKey:@"CFBundleName"]];
    
    if([[newInfo objectForKey:@"BundleVersion"] caseInsensitiveCompare:[tempInfo objectForKey:@"CFBundleVersion"]] == NSOrderedDescending){
        id tPassToWindow =[NSDictionary dictionaryWithObjectsAndKeys:[tempInfo objectForKey:@"CFBundleName"],@"BundleName",[newInfo objectForKey:@"BundleVersion"],@"BundleVersion",[newInfo objectForKey:@"BundleVersion"],@"HumanVersion",[[[NSAttributedString alloc]initWithRTFD:[newInfo objectForKey:@"Changes"]documentAttributes:nil]autorelease],@"Changes",[newInfo objectForKey:@"URL"],@"URL",nil];
        [self performSelectorOnMainThread:@selector(_JTOrderUpTheWindow:) withObject:tPassToWindow waitUntilDone:NO];
    }else{
        [self _JTgiveError:LocalizeIt(@"No new version") silent:![aResponse boolValue]];
    }
}

-(void)_JTOrderUpTheWindow:(id)anInfoDict{
    static id _JTUpdateWinodwInstance= nil;
    if(_JTUpdateWinodwInstance ==nil){
        NSBundle *bundle = [NSBundle bundleForClass:[JTUpdateAlertPanelController self]];
        id tPath =[bundle pathForResource:@"UpdateAlertPanel"  ofType:@"nib"];
        
        _JTUpdateWinodwInstance = [[JTUpdateAlertPanelController alloc] initWithWindowNibPath:tPath];
    }
    [_JTUpdateWinodwInstance window];
    [_JTUpdateWinodwInstance loadInUpdateInfo:anInfoDict];
    
    [[_JTUpdateWinodwInstance window] makeKeyAndOrderFront:self];   
}


@end
