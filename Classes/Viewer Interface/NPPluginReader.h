/**
 * NPPluginReader.h
 * NicePlayer
 */

#import <Cocoa/Cocoa.h>

@interface NPPluginReader : NSObject {
	NSMutableArray *pluggablesArray;
	NSMutableArray *allowedExtensions;
	NSMutableDictionary *pluggableDict;
	NSMutableArray *orderedPlugins;
}

+(id)pluginReader;
-(id)init;
-(id)prefDictionary;
-(id)allowedExtensions;

-(id)integratePrefs:(NSArray *)anArray;
-(id)cachedPluginOrder;
-(void)generatePluggables;
-(id)builtinPlayerClasses;
-(id)packagePluggables;

@end
