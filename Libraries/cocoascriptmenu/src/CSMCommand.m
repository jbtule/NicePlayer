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
*           Gerad Putter                 (Sorting bug fix) 6/24/06
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
//  CSMCommand.m
//  CocoaScriptMenu
//
//  Created by James Tuley on 9/18/05.
//  Copyright 2005 James Tuley. All rights reserved.
//

#import "CSMCommand.h"
#import "CSMCommandCreator.h"
#import "CSMMenuNameParser.h"
#import "CSMCommand-SubclassMustImplement.h"

#define ASSERT_UNIMPLEMENTED [NSException raise:@"UnImplmentedMethod" format:@"Subclass %@ Must Implement %@", NSStringFromClass([self class]),NSStringFromSelector(_cmd),nil]

static id <CSMCommandCreator> theCSMCommandCreator;
static id <CSMMenuNameParser> theCSMMenuNameParser;

@implementation CSMCommand

+(void)initialize{
    theCSMCommandCreator = [[CSMCommandCreator alloc] init];
    theCSMMenuNameParser = [[CSMMenuNameParser alloc] init];
}

+(void)setMenuNameParser:(id <CSMMenuNameParser>)aParser{
    [theCSMMenuNameParser release];
    theCSMMenuNameParser = aParser;
    [theCSMMenuNameParser retain];
}

+(id <CSMMenuNameParser>)menuNameParser{
    return theCSMMenuNameParser;
}


+(void)setCommandCreator:(id <CSMCommandCreator>)aCreator{
    [theCSMCommandCreator release];
    theCSMCommandCreator = aCreator;
    [theCSMCommandCreator retain];
}

+(id <CSMCommandCreator>)commandCreator{
    return theCSMCommandCreator;
}

- (void)dealloc {
    [theNameParser release];
    [theFilePath release];
    [super dealloc];
}

+(id)commandWithScriptPath:(NSString*) aPath{
    return [[[self alloc] initWithScriptPath:aPath] autorelease];
}

+(id)alloc{
    return [self commandCreator];
}


-(id)initWithScriptPath:(NSString*) aPath{
    ASSERT_UNIMPLEMENTED;
    return nil;
}

-(NSString*)menuName{
    return [theNameParser name];
}

-(NSString*)filePath{
    return theFilePath;
}

-(NSString*)sortName{
    return [theNameParser sortName];
}

-(NSComparisonResult)compare:(CSMCommand *)aCommand{
    //bug fix by Gerard Putter, before this fix it wasn't actually sorting and just using the finder order which appeared to be sorted
    return [[self sortName] compare:[aCommand sortName]];
}

-(IBAction)executeScript:(id)sender{
    [self CSM_executeOperation];
}

-(BOOL)isMenuDivider{
   return [[self menuName] isEqualToString:@"-"];
}

-(NSMenuItem*)menuItem{
    if([self isMenuDivider]){
        return (NSMenuItem*)[NSMenuItem separatorItem];
    }
    
    return [self CSM_menuItem];
}

@end

