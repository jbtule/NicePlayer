//
//  DVDPrefController.m
//  DVDPlayer
//
//  Created by Robert Chin on 3/13/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <DVDPlayback/DVDPlayback.h>
#import "DVDPrefController.h"

@implementation DVDPrefController

+(NSUserDefaults *)preferences
{
	static id preferences;
	if(!preferences){
		preferences = [[NSUserDefaults alloc] init];
	}
	
	return preferences;
}

-(id)init
{
	if(self = [super init]){
		if([self languageAudio] == nil)
			[self setLanguageAudio:[NSNumber numberWithInt:kDVDLanguageNoPreference]];
		if([self languageSubtitles] == nil)
			[self setLanguageSubtitles:[NSNumber numberWithInt:kDVDLanguageNoPreference]];
		if([self languageMenus] == nil)
			[self setLanguageMenus:[NSNumber numberWithInt:kDVDLanguageNoPreference]];
	}
	
	return self;
}

-(DVDLanguageCode)languageAudio
{
	return [[DVDPrefController preferences] integerForKey:@"LanguageForAudio"];
}

-(IBAction)setLanguageAudio:(id)sender
{
	[[DVDPrefController preferences] setInteger:[self languageCodeForString:[sender stringValue]]
											   forKey:@"LanguageForAudio"];
}

-(DVDLanguageCode)languageSubtitles
{
	return [[DVDPrefController preferences] integerForKey:@"LanguageForSubtitles"];
}

-(IBAction)setLanguageSubtitles:(id)sender
{
	[[DVDPrefController preferences] setInteger:[self languageCodeForString:[sender stringValue]]
											   forKey:@"LanguageForSubtitles"];
}

-(DVDLanguageCode)languageMenus
{
	return [[DVDPrefController preferences] integerForKey:@"LanguageForMenus"];
}

-(IBAction)setLanguageMenus:(id)sender
{
	[[DVDPrefController preferences] setInteger:[self languageCodeForString:[sender stringValue]]
											   forKey:@"LanguageForMenus"];
}

-(DVDLanguageCode)languageCodeForString:(id)aString
{
	if([aString isEqualToString:NSLocalizedStringFromTable(@"No Preference", nil, nil)])
		return kDVDLanguageNoPreference;
	if([aString isEqualToString:NSLocalizedStringFromTable(@"English", nil, nil)])
		return kDVDLanguageCodeEnglish;
	if([aString isEqualToString:NSLocalizedStringFromTable(@"Japanese", nil, nil)])
		return kDVDLanguageCodeJapanese;
	if([aString isEqualToString:NSLocalizedStringFromTable(@"Chinese", nil, nil)])
		return kDVDLanguageCodeChinese;
	if([aString isEqualToString:NSLocalizedStringFromTable(@"French", nil, nil)])
		return kDVDLanguageCodeFrench;
	if([aString isEqualToString:NSLocalizedStringFromTable(@"German", nil, nil)])
		return kDVDLanguageCodeGerman;
	return kDVDLanguageCodeUninitialized;
}

-(NSArray *)bookmarksForDisc:(NSString *)discID
{
	NSDictionary *disc = [[DVDPrefController preferences] dictionaryForKey:discID];
	if(disc == nil)
		return nil;
	return [disc allKeys];
}

-(void)setBookmark:(NSData *)bookmarkData withName:(NSString *)aString forDisc:(NSString *)discID
{
    NSMutableDictionary *disc = [NSMutableDictionary dictionaryWithDictionary:
	[[DVDPrefController preferences] dictionaryForKey:discID]];
	if(disc == nil)
		disc = [NSMutableDictionary dictionary];
	else
		disc = [NSMutableDictionary dictionaryWithDictionary:disc];
	
	[disc setObject:bookmarkData forKey:aString];
	[[DVDPrefController preferences] setObject:disc forKey:discID];
	[[DVDPrefController preferences] synchronize];
}

-(NSData *)bookmarkDataFromName:(NSString *)aString forDisc:(NSString *)discID
{
	NSDictionary *disc = [[DVDPrefController preferences] dictionaryForKey:discID];
	if(disc == nil)
		return nil;

	return [disc objectForKey:aString];	
}

@end
