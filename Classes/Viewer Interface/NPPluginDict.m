/**
 * NPPluginDict.m
 * NicePlayer
 *
 * A category for NSMutableDictionary that allows the easy setting of chosen versus not chosen for
 * use of plugins.
 */

#import "NPPluginDict.h"
#import "../Preferences/Preferences.h"

@implementation NSMutableDictionary (NPPluginDict)

-(void)updateChosen:(id)sender
{
	[self setValue:[NSNumber numberWithBool:![[self valueForKey:@"Chosen"] boolValue]] forKey:@"Chosen"];
	[[Preferences mainPrefs] setViewerPluginPrefs:[[Preferences mainPrefs] viewerPluginPrefs]];
}

@end
