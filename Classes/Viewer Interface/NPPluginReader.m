/**
 * NPPluginReader.m
 * NicePlayer
 *
 * Finds all of the plugins and makes them available to the application.
 */


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
* The Original Code is NicePlayer.
*
* The Initial Developer of the Original Code is
* James Tuley & Robert Chin.
* Portions created by the Initial Developer are Copyright (C) 2004-2005
* the Initial Developer. All Rights Reserved.
*
* Contributor(s):
*           Robert Chin <robert@osiris.laya.com> (NicePlayer Author)
*           James Tuley <jay+nicesource@tuley.name> (NicePlayer Author)
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




#import "NPPluginReader.h"
#import "Pluggable Players/NPMovieProtocol.h"
#import "NiceUtilities.h"
#import "JTMovieView.h"
#import "RCMovieView.h"
#import <STEnum/STEnum.h>

@class DVDPlayerView;

static NPPluginReader *pluginReader = nil;

id injectAllowedTypesOfEnabledPlugins(id each, id allowedExt,void* context){
    if([[each objectForKey:@"Chosen"] boolValue]){
        [allowedExt addObjectsFromArray:[[[(NPPluginReader*)context prefDictionary] objectForKey:[each objectForKey:@"Name"]] objectForKey:@"FileExtensions"]];
    }
    return allowedExt;
}

@implementation NPPluginReader

+(id)pluginReader
{
	if(pluginReader == nil)
		pluginReader = [NPPluginReader new];
	return pluginReader;
}

-(id)init
{
	if((self = [super init])){
	    [self generatePluggables];
	    [self generatePluginOrder];
	}
	return self;
}

-(void)dealloc
{
	[pluggablesArray release];
	[pluggableDict release];
	[super dealloc];
}

/* Use this function to integrate the preferred order from the preferences and any new
   plugins that may have been detected. */
/* TODO: write integrate function. */
-(id)integratePrefs:(NSArray *)anArray
{
    unsigned i, j;
    NSMutableArray *finalOrder = [[NSMutableArray array] retain];
    for(i = 0; i < [anArray count]; i++){
	NSDictionary *storedDict = [anArray objectAtIndex:i];
	for(j = 0; j < [orderedPlugins count]; j++){
	    NSMutableDictionary *parsedDict = [orderedPlugins objectAtIndex:j];
	    if([[storedDict objectForKey:@"Name"] isEqualToString:[parsedDict objectForKey:@"Name"]]){
		[parsedDict setObject:[storedDict objectForKey:@"Chosen"] forKey:@"Chosen"];
		[finalOrder addObject:parsedDict];
	    }
	}
    }
    NSMutableSet *remainingSet = [NSMutableSet setWithArray:orderedPlugins];
    NSSet *firstSet = [NSSet setWithArray:finalOrder];
    [remainingSet minusSet:firstSet];
    [finalOrder addObjectsFromArray:[remainingSet allObjects]];
    
    [orderedPlugins release];
    orderedPlugins = finalOrder;
    return orderedPlugins;
}

-(void)generatePluginOrder
{
    unsigned i;
    orderedPlugins = [[NSMutableArray array] retain];

    for(i = 0; i < [pluggablesArray count]; i++){
	NSDictionary *newItem = [NSMutableDictionary dictionaryWithObjectsAndKeys:
	    [pluggablesArray objectAtIndex:i],	@"Name",
	    [NSNumber numberWithBool:YES],	@"Chosen",
	    nil];
	[orderedPlugins addObject:newItem];
    }
}

-(id)cachedPluginOrder
{
    return orderedPlugins;
}

/* Get the dictionary that is indexed by the proper plugin names. It contains all of the necessary
   information to load the plugin. */
-(id)prefDictionary
{
	return pluggableDict;
}

/* Returns all of the allowed extensions for opening files. Dynamically grows as more plugins are
   loaded. */
-(id)allowedExtensions
{
    NSMutableSet* tAllowExt = [NSMutableSet setWithObject:@"nicelist"];
    

    [[self cachedPluginOrder] injectUsingFunction:injectAllowedTypesOfEnabledPlugins into:tAllowExt context:(void*)self];
    return [tAllowExt allObjects];
}

#pragma mark -
#pragma mark Private Methods

-(void)generatePluggables
{
    NSArray *array = [[self packagePluggables] arrayByAddingObjectsFromArray:[self builtinPlayerClasses]];
    
    pluggablesArray = [[NSMutableArray array] retain];
    pluggableDict = [[NSMutableDictionary dictionary] retain];
    
    id anObject;
    unsigned i;
    
    /* Sets up plugin information that we might need later. */
    for(i = 0; i < [array count]; i++){
	anObject = [array objectAtIndex:i];
	id plugInfo = [NSMutableDictionary dictionaryWithDictionary:[anObject plugInfo]];
	[plugInfo setObject:anObject forKey:@"Class"];
	[plugInfo setObject:[NSNumber numberWithBool:YES] forKey:@"Chosen"];
	[pluggableDict setObject:plugInfo forKey:[plugInfo objectForKey:@"Name"]];
	[pluggablesArray addObject:[plugInfo objectForKey:@"Name"]];
    }
}

-(id)builtinPlayerClasses
{
    if(NPIs10_4OrGreater())
        return [NSArray arrayWithObjects:[RCMovieView class], [JTMovieView class], nil];
    else
	return [NSArray arrayWithObjects:[JTMovieView class], nil];

}

/* Finds all package pluggables and gets their information. */
-(id)packagePluggables
{
    NSMutableArray *objectArray = [NSMutableArray array];
    NSMutableArray *pluginPaths = [NSMutableArray array];
    
    [pluginPaths addObjectsFromArray:
	[NSBundle pathsForResourcesOfType:@"nicebundle"
			      inDirectory:[[NSBundle mainBundle] builtInPlugInsPath]]];
    [pluginPaths addObjectsFromArray:
	    [NSBundle pathsForResourcesOfType:@"nicebundle"
				  inDirectory:@"/Library/Application Support/NicePlayer/Plugins"]];
    [pluginPaths addObjectsFromArray:
	    [NSBundle pathsForResourcesOfType:@"nicebundle"
				  inDirectory:
		[@"~/Library/Application Support/NicePlayer/Plugins" stringByExpandingTildeInPath]]];

    NSEnumerator *e = [pluginPaths objectEnumerator];
    id anObject;
    
    while ((anObject = [e nextObject])) {
	id aBundle = [NSBundle bundleWithPath:anObject];
		if(![aBundle load]){
			NSLog(@"Couldn't load bundle %@ (maybe it's not a universal binary?).", anObject);
	    continue;
		}
	[objectArray addObject:[aBundle principalClass]];
    }
    return objectArray;
}

@end
