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
	return [[NSUserDefaults standardUserDefaults] integerForKey:@"LanguageForAudio"];
}

-(IBAction)setLanguageAudio:(id)sender
{
	[[NSUserDefaults standardUserDefaults] setInteger:[self languageCodeForString:[sender stringValue]]
											   forKey:@"LanguageForAudio"];
}

-(DVDLanguageCode)languageSubtitles
{
	return [[NSUserDefaults standardUserDefaults] integerForKey:@"LanguageForSubtitles"];
}

-(IBAction)setLanguageSubtitles:(id)sender
{
	[[NSUserDefaults standardUserDefaults] setInteger:[self languageCodeForString:[sender stringValue]]
											   forKey:@"LanguageForSubtitles"];
}

-(DVDLanguageCode)languageMenus
{
	return [[NSUserDefaults standardUserDefaults] integerForKey:@"LanguageForMenus"];
}

-(IBAction)setLanguageMenus:(id)sender
{
	[[NSUserDefaults standardUserDefaults] setInteger:[self languageCodeForString:[sender stringValue]]
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
}

-(NSArray *)bookmarksForDisc:(NSData *)discID
{
	NSDictionary *disc = [[NSUserDefaults standardUserDefaults] dictionaryForKey:discID];
	if(disc == nil)
		return nil;
	return [disc allKeys];
}

-(void)setBookmark:(NSData *)bookmarkData withName:(NSString *)aString forDisc:(NSData *)discID
{
	NSDictionary *disc = [[NSUserDefaults standardUserDefaults] dictionaryForKey:discID];
	if(disc == nil){
		disc = [NSDictionary dictionary];
		[[NSUserDefaults standardUserDefaults] setObject:disc forKey:discID];
	}
	
	[disc setObject:bookmarkData forKey:aString];
}

-(NSData *)bookmarkDataFromName:(NSString *)aString forDisc:(NSData *)discID
{
	NSDictionary *disc = [[NSUserDefaults standardUserDefaults] dictionaryForKey:discID];
	if(disc == nil)
		return nil;

	return [disc objectForKey:aString];	
}

@end
