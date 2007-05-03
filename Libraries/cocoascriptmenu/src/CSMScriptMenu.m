/* ***** BEGIN LICENSE BLOCK *****
* Version: MPL 1.1/GPL 2.0/LGPL 2.1
*
* The contents of this file are subject to the Mozilla Public License Version
* 1.1 (the "License"); you may not use this file except in compliance with
* the License. You may obtain a copy of the License at
* http://www.mozilla.org/MPL/
*
* Software distributed under the License is distributed on an "AS IS" basis,
* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
* for the specific language governing rights and limitations under the
* License.
*
* The Original Code is CocoaScriptMenu.
*
* The Initial Developer of the Original Code is
* James Tuley.
* Portions created by the Initial Developer are Copyright (C) 2004-2005
* the Initial Developer. All Rights Reserved.
*
* Contributor(s):
*           James Tuley <jay+csm@tuley.name> (Original Author)
*           Wil Shipley                  (Changed way script path is generated - 1/1/07)
* 
* Alternatively, the contents of this file may be used under the terms of
* either the GNU General Public License Version 2 or later (the "GPL"), or
* the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
* in which case the provisions of the GPL or the LGPL are applicable instead
* of those above. If you wish to allow use of your version of this file only
* under the terms of either the GPL or the LGPL, and not to allow others to
* use your version of this file under the terms of the MPL, indicate your
* decision by deleting the provisions above and replace them with the notice
* and other provisions required by the GPL or the LGPL. If you do not delete
* the provisions above, a recipient may use your version of this file under
* the terms of any one of the MPL, the GPL or the LGPL.
*
* ***** END LICENSE BLOCK ***** */

//
//  CSMScriptMenu.m
//  CocoaScriptMenu
//
//  Created by James Tuley on 9/18/05.
//  Copyright 2005 James Tuley. All rights reserved.
//

#import "CSMScriptMenu.h"
#import "CSMCommand.h"
#import "CSMFileSubscription.h"
#import "TenThreeCompatibility.h"

void CSMUpdateMenuHandle(FNMessage message,OptionBits flags,void * refcon,FNSubscriptionRef subscription){
    if(message == kFNDirectoryModifiedMessage){
        [[CSMScriptMenu sharedMenuGenerator] updateScriptMenu];
    }
}

@implementation CSMScriptMenu

-(id)init{
    if(self = [super init]){
        theDelegate = nil;
        theMainScriptMenuItem = nil;
        thePathSubscriptions = [[NSMutableDictionary alloc] init];
    } return self;
}

-(void)setDelagate:(id)aDelegate{
    [theDelegate release];
    theDelegate = [aDelegate retain];
}

-(id)delegate{
    return theDelegate;
}

+(CSMScriptMenu*)sharedMenuGenerator{
    static CSMScriptMenu* theSharedMenuGenerator = nil;
    if(theSharedMenuGenerator == nil){
        theSharedMenuGenerator = [[CSMScriptMenu alloc] init];
    }return theSharedMenuGenerator;
}

+(NSMenuItem*)typicalScriptMenuItem{
    id tMenuItem = [[NSMenuItem alloc] initWithTitle:@"S" action:NULL keyEquivalent:@""];
    [tMenuItem setImage:[[[NSImage alloc] initWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForImageResource:@"scripticon"]] autorelease]];
    [tMenuItem setSubmenu:[[[NSMenu alloc] init] autorelease]];
    return [tMenuItem autorelease];
}

+(void)refreshMenu:(NSMenu*) aMenu withMenuItems:(NSArray*)aMenuItems{
    NSEnumerator* tEnum = [[aMenu itemArray] objectEnumerator];
    id tItem = nil;
    while(tItem = [tEnum nextObject]){
        [aMenu removeItem:tItem];
    }

    tEnum = [aMenuItems objectEnumerator];
    tItem = nil;

    while(tItem = [tEnum nextObject]){
        [aMenu addItem:tItem];
    }
    
}

+(NSArray*)menuItemsForPath:(NSString*)aPath{
    NSEnumerator* tEnum = [[[NSFileManager defaultManager] directoryContentsAtPath:aPath] objectEnumerator];
    id tPath =nil;
    NSMutableArray* tCommandItems = [NSMutableArray array];
    while(tPath =[tEnum nextObject]){
        if(![tPath hasPrefix:@"."]){
            [tCommandItems addObject:[CSMCommand commandWithScriptPath:[aPath stringByAppendingPathComponent:tPath]]];
        }
    }
    [tCommandItems sortUsingSelector:@selector(compare:)];
    tEnum = [tCommandItems objectEnumerator];
    id tCommand =nil;
    NSMutableArray* tMenuItems = [NSMutableArray array];
    while(tCommand = [tEnum nextObject]){
        [tMenuItems addObject:[tCommand menuItem]];
    }
    return tMenuItems;
}

-(unsigned int)countOfScripts{
    NSArray* tArray = [self scriptLocations];
    
    NSEnumerator* tLocEnum = [tArray objectEnumerator];
    NSString* tLoc;
    unsigned int tCount = 0;
    while(tLoc = [tLocEnum nextObject]){
        NSEnumerator* tEnum = [[[NSFileManager defaultManager] subpathsAtPath:tLoc] objectEnumerator];
        id tPath =nil;
        while(tPath =[tEnum nextObject]){
            BOOL tIsDir =NO;
            [[NSFileManager defaultManager] fileExistsAtPath:[tLoc stringByAppendingPathComponent:tPath ] isDirectory:&tIsDir];
            if(!([[tPath lastPathComponent] hasPrefix:@"."] || tIsDir) ){
                tCount++;
            }
        }
    }
    return tCount;
}


-(void)updateMenuForScripts:(NSMenu*)aMenu{
    NSMutableArray* tTotalMenus = [NSMutableArray array];
    [tTotalMenus addObject:[self showScriptFolderMenuItem]];
    
    NSMenuItem* tUpdateMenu = [[[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Update Scripts Menu",@"Update Scripts Menu") action:@selector(updateScriptMenu:) keyEquivalent:@""] autorelease];
    [tUpdateMenu setKeyEquivalentModifierMask:NSAlternateKeyMask];
    [tUpdateMenu setAlternate:YES];
    [tUpdateMenu setTarget:self];
    [tTotalMenus addObject:tUpdateMenu];

    NSEnumerator* tEnum = [[self scriptLocations] objectEnumerator];

    id tPath = nil;
    while (tPath = [tEnum nextObject]){
        [self createFileSystemSubscriptionForPath:tPath];
        NSArray* tDomainItems = [CSMScriptMenu menuItemsForPath:tPath];
        if([tDomainItems count]  > 0){
            [tTotalMenus addObject:[NSMenuItem separatorItem]];
            [tTotalMenus addObjectsFromArray:tDomainItems];
        }
    }
    
    [CSMScriptMenu refreshMenu:aMenu withMenuItems:tTotalMenus];
}

-(IBAction)showScriptsFolder:(id)sender{
    [[NSWorkspace sharedWorkspace] openFile:[[self scriptLocations] objectAtIndex:0]];
}

-(IBAction)updateScriptMenu:(id)sender{
    [self updateScriptMenu];
}

-(void)createFileSystemSubscriptionForPath:(NSString*)aPath{
    
    if([thePathSubscriptions objectForKey:aPath] == nil){
        [thePathSubscriptions setObject:[CSMFileSubscription createForPath:aPath withCallback:CSMUpdateMenuHandle andContext:NULL] forKey:aPath];
    }
            
}

-(void)updateScriptMenu{
    id tScriptItems =[self scriptMenuItemOrItems];
    
    if(![tScriptItems isKindOfClass:[NSArray class]])
        tScriptItems = [NSArray arrayWithObject:tScriptItems];
            
    NSEnumerator* tEnumerator = [tScriptItems objectEnumerator];
    id tScriptItem = nil;
    
    while(tScriptItem = [tEnumerator nextObject]){
        if(tScriptItem != nil){
            if([tScriptItem respondsToSelector:@selector(submenu)]){
                [self updateMenuForScripts:[tScriptItem submenu]];
            }else if([tScriptItem respondsToSelector:@selector(menu)]) {
                [self updateMenuForScripts:[tScriptItem menu]];
            }
        }
    }
}



-(NSArray*)standardScriptLocations{
    
    NSArray* tAppSupUserPaths= TTCSearchPathForDirectoriesInDomains(TTCApplicationSupportDirectory, NSUserDomainMask,YES);

    NSArray* tAppSupPaths= TTCSearchPathForDirectoriesInDomains(TTCApplicationSupportDirectory,NSAllDomainsMask ^ NSUserDomainMask,YES);
    
    NSMutableArray* tGuarenteedUserFirstArray = [NSMutableArray array];
    
    NSString * tASUserPath = [tAppSupUserPaths objectAtIndex:0];
    //Wil Shipley change to use process name instead of app name from the bundle, it's certainly more readable and apparently more reliable
    tASUserPath = [tASUserPath stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]];
    BOOL tIsDir = NO;
    if(![[NSFileManager defaultManager] fileExistsAtPath:tASUserPath isDirectory:&tIsDir]){
        [[NSFileManager defaultManager] createDirectoryAtPath:tASUserPath attributes:nil];
    }
    tASUserPath = [tASUserPath stringByAppendingPathComponent:@"Scripts"];
    tIsDir = NO;
    if(![[NSFileManager defaultManager] fileExistsAtPath:tASUserPath isDirectory:&tIsDir]){
        [[NSFileManager defaultManager] createDirectoryAtPath:tASUserPath attributes:nil];
    }
    
    [tGuarenteedUserFirstArray addObjectsFromArray:tAppSupPaths];

    NSEnumerator* tEnumerator = [tGuarenteedUserFirstArray objectEnumerator];
    id tItem = nil;
    NSMutableArray* tPathsThatExist = [NSMutableArray array];
    [tPathsThatExist addObject:tASUserPath];

    while(tItem = [tEnumerator nextObject]){
        //Wil Shipley change to use process name instead of app name from the bundle, it's certainly more readable and apparently more reliable
        NSString* tScriptPath = [(NSString*)tItem stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]];
        tScriptPath = [tScriptPath stringByAppendingPathComponent:@"Scripts"];
        tIsDir = NO;
        if([[NSFileManager defaultManager] fileExistsAtPath:tScriptPath isDirectory:&tIsDir] && tIsDir){
            [tPathsThatExist addObject:tScriptPath];
        }
        
    }
    return tPathsThatExist;
    
}

-(NSMenuItem*)showScriptFolderMenuItem{
    if ( [self delegate] !=nil && [[self delegate] respondsToSelector:@selector(showScriptFolderMenuItem)] )
        return [[self delegate] showScriptFolderMenuItem];
    
    NSMenuItem* tMenuItem = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Open Scripts Folder",@"Open Scripts Folder") action:@selector(showScriptsFolder:) keyEquivalent:@""];
    [tMenuItem setTarget:self];
    return [tMenuItem autorelease];
}

-(NSArray*)argumentsForShellScripts{
    if ( [self delegate] !=nil && [[self delegate] respondsToSelector:@selector(argumentsForShellScripts)] )
        return [[self delegate] argumentsForShellScripts];
    return nil;
}

-(NSArray*)scriptLocations{
    
    if ( [self delegate] !=nil && [[self delegate] respondsToSelector:@selector(scriptLocations)] )
        return [[self delegate] scriptLocations];
    
    return [self standardScriptLocations];
    
}

-(id)scriptMenuItemOrItems{
    if ( [self delegate] !=nil && [[self delegate] respondsToSelector:@selector(scriptMenuItemOrItems)] )
        return [[self delegate] scriptMenuItemOrItems];
    
    
    if(theMainScriptMenuItem == nil){
        theMainScriptMenuItem = [[CSMScriptMenu typicalScriptMenuItem] retain];
        int tIndex =[[NSApp mainMenu] indexOfItemWithTitle:NSLocalizedString(@"Help",@"Help")];
        
        if(tIndex < 0)
            [[NSApp mainMenu] addItem:theMainScriptMenuItem];
        else
            [[NSApp mainMenu] insertItem:theMainScriptMenuItem atIndex:tIndex];    
    }
    
    return theMainScriptMenuItem;
}

@end
