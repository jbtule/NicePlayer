/**
 * NPPluginReader.m
 * NicePlayer
 *
 * Finds all of the plugins and makes them available to the application.
 */

#import "NPPluginReader.h"
#import "Pluggable Players/NPMovieProtocol.h"
#import "NPPluginDict.h"

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
	if(self = [super init]){
		[self generatePluggables];
	}
	return self;
}

-(void)dealloc
{
	[pluggablesArray release];
	[allowedExtensions release];
	[pluggableDict release];
	[super dealloc];
}

/* Use this function to integrate the preferred order from the preferences and any new
   plugins that may have been detected. */
/* TODO: write integrate function. */
-(id)integratePrefs:(NSArray *)anArray
{
	return pluggablesArray;
}

-(id)cachedPluginOrder
{
	return pluggablesArray;
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
	return allowedExtensions;
}

#pragma mark -
#pragma mark Private Methods

-(void)generatePluggables
{
	NSArray *array = [[self builtinPlayerClasses] arrayByAddingObjectsFromArray:[self packagePluggables]];
	
	pluggablesArray = [[NSMutableArray array] retain];
	allowedExtensions = [[NSMutableArray array] retain];
	pluggableDict = [[NSMutableDictionary dictionary] retain];
	
	id anObject;
	unsigned i;
	
	/* Sets up plugin information that we might need later. */
	for(i = 0; i < [array count]; i++){
		anObject = [array objectAtIndex:i];
		id plugInfo = [NSMutableDictionary dictionaryWithDictionary:[anObject plugInfo]];
		[plugInfo setObject:anObject forKey:@"Class"];
		[plugInfo setObject:[NSNumber numberWithBool:YES] forKey:@"Chosen"];
		[allowedExtensions addObjectsFromArray:[plugInfo valueForKey:@"FileExtensions"]];
		[pluggableDict setObject:plugInfo forKey:[plugInfo valueForKey:@"Name"]];
		[pluggablesArray addObject:[plugInfo valueForKey:@"Name"]];
	}
}

-(id)builtinPlayerClasses
{
	return [NSArray arrayWithObjects:[JTMovieView class], nil];
}

/* Finds all package pluggables and gets their information. */
-(id)packagePluggables
{
	NSMutableArray *objectArray = [NSMutableArray array];
	NSArray *pluginPaths = [NSBundle pathsForResourcesOfType:@"nicebundle"
												 inDirectory:[[NSBundle mainBundle] builtInPlugInsPath]];
	NSEnumerator *e = [pluginPaths objectEnumerator];
	id anObject;
	
	while (anObject = [e nextObject]) {
		id aBundle = [NSBundle bundleWithPath:anObject];
		[aBundle load];
		[objectArray addObject:[aBundle principalClass]];
	}
	return objectArray;
}

@end
