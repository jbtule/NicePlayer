/**
 * NPPluginReader.m
 * NicePlayer
 *
 * Finds all of the plugins and makes them available to the application.
 */

#import "NPPluginReader.h"
#import "Pluggable Players/NPMovieProtocol.h"
#import "IndyKit/IndyKit.h"
#import "NiceUtilities.h"

@class RCMovieView;
@class JTMovieView;
@class DVDPlayerView;

static NPPluginReader *pluginReader = nil;

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
    
    id injectAllowedTypesOfEnabledPlugins(id each, id allowedExt,void* context){
        if([[each objectForKey:@"Chosen"] boolValue]){
            [allowedExt addObjectsFromArray:[[[self prefDictionary] objectForKey:[each objectForKey:@"Name"]] objectForKey:@"FileExtensions"]];
        }
        return allowedExt;
    }
    [[self cachedPluginOrder] injectUsingFunction:injectAllowedTypesOfEnabledPlugins into:tAllowExt context:NULL];
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
	if(![aBundle load])
	    continue;
	[objectArray addObject:[aBundle principalClass]];
    }
    return objectArray;
}

@end
