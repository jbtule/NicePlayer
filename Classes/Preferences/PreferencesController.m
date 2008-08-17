/**
 * PreferencesController.m
 * NicePlayer
 *
 * The preferences controller allowing the preferences GUI to interact with the preference
 * cache and the NSUserDefaults system.
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
* Portions created by the Initial Developer are Copyright (C) 2004-2006
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

#import "PreferencesController.h"
#import "../Viewer Interface/NPPluginReader.h"
#import <Sparkle/Sparkle.h>
#import "NPApplication.h"
#import "NiceUtilities.h"
#import <Preferable/Preferable.h>
@implementation PreferencesController

-(void)awakeFromNib
{
    id tempBundle =[NSBundle bundleForClass:[PFPreferenceModule self]];
    
    NSString* tGeneralPrefIcon = [tempBundle pathForResource:@"GeneralPreferenceIcon" ofType:@"png"];
    NSString* tActionPrefIcon =[tempBundle pathForResource:@"ActionsPreferenceIcon" ofType:@"png"];

	id sparkleBundle =[NSBundle bundleForClass:[SUUpdater class]];
	NSString* tSparklePrefIcon =[sparkleBundle pathForResource:@"Sparkle" ofType:@"icns"];

	[prefWindowController addPane:paneMain
                   withIcon:[[[NSImage alloc]initWithContentsOfFile:tGeneralPrefIcon] autorelease]
		 withIdentifier:@"General"
			  withLabel:@"General"
			withToolTip:@"The General Preference Settings"
		 allowingResize:NO];
	[prefWindowController addPane:paneInput
                   withIcon:[NSImage imageNamed:@"inputpref"] 
		 withIdentifier:@"Input"
			  withLabel:@"Input"
			withToolTip:@"The Input Preference Settings"
		 allowingResize:NO];
	[prefWindowController addPane:paneWindowDefaults
                   withIcon:[NSImage imageNamed:@"windpref"] 
		 withIdentifier:@"Window Defaults"
			  withLabel:@"Window Defaults"
			withToolTip:@"The Window Default Preference Settings"
		 allowingResize:NO];
	[prefWindowController addPane:paneActions
			   withIcon:[[[NSImage alloc]initWithContentsOfFile:tActionPrefIcon] autorelease]
		 withIdentifier:@"Actions"
			  withLabel:@"Actions"
			withToolTip:@"Actions on Movies"
		 allowingResize:NO];
	
	if(!NPBuildingForMacPorts){
	[prefWindowController addPane:paneSparkle
			   withIcon:[[[NSImage alloc]initWithContentsOfFile:tSparklePrefIcon] autorelease]
		 withIdentifier:@"Sparkle"
			  withLabel:@"Auto Update"
			withToolTip:@"Auto Update"
		 allowingResize:NO];
	}
	
	[prefWindowController addPane:paneOverlays
		   withIcon:[NSImage imageNamed:@"OverPrefIcon"] 
	     withIdentifier:@"Overlays"
		  withLabel:@"Overlays"
		withToolTip:@"Various Information and Interaction Displays"
	     allowingResize:YES];
	[prefWindowController addPane:paneView
			   withIcon:[NSImage imageNamed:@"ViewerPrefIcon"]
		 withIdentifier:@"Viewer"
			  withLabel:@"Viewer"
			withToolTip:@"Viewer Order for Opening Movies"
		 allowingResize:YES];
	
	[doubleClickMoviePref selectItemWithTag:[[Preferences mainPrefs] doubleClickMoviePref]];
	[rightClickMoviePref selectItemWithTag:[[Preferences mainPrefs] rightClickMoviePref]];
	[scrollWheelMoviePref selectItemWithTag:[[Preferences mainPrefs] scrollWheelMoviePref]];
	[scrollWheelHorizontalMoviePref selectItemWithTag:[[Preferences mainPrefs] scrollWheelHorizontalMoviePref]];
	[scrollResizePin selectItemAtIndex:[[Preferences mainPrefs] scrollResizePin]];
	[defaultTimeDisplay selectItemAtIndex:[[Preferences mainPrefs] defaultTimeDisplay]];
	[defaultRepeatMode selectItemAtIndex:[[Preferences mainPrefs] defaultRepeatMode]];
	[defaultOpenMode selectItemAtIndex:[[Preferences mainPrefs] defaultOpenMode]];
	[enableAppleRemote setState:![[Preferences mainPrefs] disableAppleRemote]];

        id aDate = [NSDate dateWithTimeIntervalSinceReferenceDate:
            ([[Preferences mainPrefs] rrSpeed]- [[NSTimeZone localTimeZone] secondsFromGMTForDate:
                [NSDate dateWithTimeIntervalSinceReferenceDate:0]])];
        [rrSpeedSlider setObjectValue:aDate];

               
        id aDate2 = [NSDate dateWithTimeIntervalSinceReferenceDate:
            ([[Preferences mainPrefs] ffSpeed]- [[NSTimeZone localTimeZone] secondsFromGMTForDate:
                [NSDate dateWithTimeIntervalSinceReferenceDate:0]])];
        [ffSpeedSlider setObjectValue:aDate2];

	[autoplayOnFullScreen setState:[[Preferences mainPrefs] autoplayOnFullScreen]];
	[autostopOnNormalScreen setState:[[Preferences mainPrefs] autostopOnNormalScreen]];
	
	[showInitialOverlays setState:[[Preferences mainPrefs] showInitialOverlays]];
	[fadeOverlays setState:[[Preferences mainPrefs] fadeOverlays]];
	float fOT = [[Preferences mainPrefs] fadeOverlayTime];
	fOT = (fOT <= 0.0) ? 5.0 : fOT;
        [fadeOverlayTime setObjectValue:[NSNumber numberWithFloat:fOT]];
	
	[showNotificationOverlays setState:[[Preferences mainPrefs] showNotificationOverlays]];
	[fadeNotificationOverlays setState:[[Preferences mainPrefs] fadeNotificationOverlays]];
	float dNT = [[Preferences mainPrefs] displayNotificationTime];
	dNT = (dNT <= 0.0) ? 0.25 : dNT;
        [displayNotificationTime setObjectValue:[NSNumber numberWithFloat:dNT]];
        [notificationColor setColor:[[Preferences mainPrefs] notificationColor]];
		
	[movieOpenedPlay setState:[[Preferences mainPrefs] movieOpenedPlay]];
	[movieOpenedFullScreen setState:[[Preferences mainPrefs] movieOpenedFullScreen]];
	[windowAlwaysOnTop setState:[[Preferences mainPrefs] windowAlwaysOnTop]];
	[windowLeaveFullScreen setState:[[Preferences mainPrefs] windowLeaveFullScreen]];
	[audioVolumeSimilarToLastWindow setState:[[Preferences mainPrefs] audioVolumeSimilarToLastWindow]];
	[disableShowingOverlaysOnKeyPress setState:[[Preferences mainPrefs] disableShowingOverlaysOnKeyPress]];
	[opacityWhenWindowIsTransparent setFloatValue:[[Preferences mainPrefs] opacityWhenWindowIsTransparent]];
	
	if([((NPApplication*)NSApp) shouldCheckAtStartUp])
		[sparkleAuto setState:NSOnState];
	else		
		[sparkleAuto setState:NSOffState];
	
	
	[bundlePriorityTable setDataSource:self];
	[bundlePriorityTable setDelegate:self];
	[bundlePriorityTable registerForDraggedTypes:[NSArray arrayWithObjects:@"draggingData", nil]];
}

-(IBAction)doubleClickMoviePref:(id)sender
{
	[[Preferences mainPrefs] setDoubleClickMoviePref:[[sender selectedItem] tag]];
}

-(IBAction)rightClickMoviePref:(id)sender
{
	[[Preferences mainPrefs] setRightClickMoviePref:[[sender selectedItem] tag]];
}

-(IBAction)scrollWheelMoviePref:(id)sender
{
    [[Preferences mainPrefs] setScrollWheelMoviePref:[[sender selectedItem] tag]];
}

-(IBAction)scrollWheelHorizontalMoviePref:(id)sender
{
    [[Preferences mainPrefs] setScrollWheelHorizontalMoviePref:[[sender selectedItem] tag]];
}

-(IBAction)scrollResizePin:(id)sender
{
	[[Preferences mainPrefs] setScrollResizePin:[sender indexOfSelectedItem]];
}

-(IBAction)defaultTimeDisplay:(id)sender
{
	[[Preferences mainPrefs] setDefaultTimeDisplay:[sender indexOfSelectedItem]];
}

-(IBAction)defaultRepeatMode:(id)sender
{
	[[Preferences mainPrefs] setDefaultRepeatMode:[sender indexOfSelectedItem]];
}

-(IBAction)defaultOpenMode:(id)sender
{
	[[Preferences mainPrefs] setDefaultOpenMode:[sender indexOfSelectedItem]];
}

-(IBAction)enableAppleRemote:(id)sender
{
    [[Preferences mainPrefs] setDisableAppleRemote:([sender state] == NSOffState)];
}

#pragma mark -

-(IBAction)rrSpeed:(id)sender
{
    //[[Preferences mainPrefs] setRrSpeed:[sender intValue]];

   // id date =[NSCalendarDate dateWithString:[sender stringValue] calendarFormat:@"%H:%M:%S"];
    
    int total = [[sender objectValue] secondOfMinute];
    total += 60 * [[sender objectValue] minuteOfHour];
     total += 60* 60* [[sender objectValue] hourOfDay];
    [[Preferences mainPrefs] setRrSpeed:total];
}

-(IBAction)ffSpeed:(id)sender
{
   // [[Preferences mainPrefs] setFfSpeed:[sender intValue]];
    //id date =[NSCalendarDate dateWithString:[sender stringValue] calendarFormat:@"%H:%M:%S"];
    int total = [[sender objectValue] secondOfMinute];
    total += 60 * [[sender objectValue] minuteOfHour];
    total += 60* 60* [[sender objectValue] hourOfDay];
    [[Preferences mainPrefs] setFfSpeed:total];
}


-(IBAction)sparkleStartCheck:(id)sender{
	[NSApp setShouldCheckAtStartup:[sparkleAuto state]==NSOnState];
}


#pragma mark -

-(IBAction)autoplayOnFullScreen:(id)sender
{
	[[Preferences mainPrefs] setAutoplayOnFullScreen:[sender state]];
}

-(IBAction)autostopOnNormalScreen:(id)sender
{
	[[Preferences mainPrefs] setAutostopOnNormalScreen:[sender state]];
}

#pragma mark -

-(IBAction)showInitialOverlays:(id)sender
{
	[[Preferences mainPrefs] setShowInitialOverlays:[sender state]];
}

-(IBAction)fadeOverlays:(id)sender
{
	[[Preferences mainPrefs] setFadeOverlays:[sender state]];
}

-(IBAction)fadeOverlayTime:(id)sender
{
    int fOT = [[Preferences mainPrefs] fadeOverlayTime];
    fOT = (fOT <= 0) ? 5.0 : fOT;
    [[Preferences mainPrefs] setFadeOverlayTime:fOT];
}

#pragma mark -

-(IBAction)showNotificationOverlays:(id)sender
{
    	[[Preferences mainPrefs] setShowNotificationOverlays:[sender state]];
}

-(IBAction)fadeNotificationOverlays:(id)sender
{
    	[[Preferences mainPrefs] setFadeNotificationOverlays:[sender state]];
}

-(IBAction)displayNotificationTime:(id)sender
{
    int dNT = [[Preferences mainPrefs] fadeOverlayTime];
    dNT = (dNT <= 0) ? 0.25 : dNT;
    [[Preferences mainPrefs] setFadeOverlayTime:dNT];
}

-(IBAction)notificationColor:(id)sender
{
    [[Preferences mainPrefs] setNotificationColor:[sender color]];
}

#pragma mark -

-(IBAction)movieOpenedPlay:(id)sender
{
	[[Preferences mainPrefs] setMovieOpenedPlay:[sender state]];
}

-(IBAction)movieOpenedFullScreen:(id)sender
{
	[[Preferences mainPrefs] setMovieOpenedFullScreen:[sender state]];
}

-(IBAction)windowAlwaysOnTop:(id)sender
{
	[[Preferences mainPrefs] setWindowAlwaysOnTop:[sender state]];
}

-(IBAction)windowLeaveFullScreen:(id)sender
{
	[[Preferences mainPrefs] setWindowLeaveFullScreen:[sender state]];
}

-(IBAction)audioVolumeSimilarToLastWindow:(id)sender
{
	[[Preferences mainPrefs] setAudioVolumeSimilarToLastWindow:[sender state]];
}

-(IBAction)disableShowingOverlaysOnKeyPress:(id)sender
{
	[[Preferences mainPrefs] setDisableShowingOverlaysOnKeyPress:[sender state]];
}

-(IBAction)opacityWhenWindowIsTransparent:(id)sender
{
	[[Preferences mainPrefs] setOpacityWhenWindowIsTransparent:[sender floatValue]];
}

#pragma mark -
#pragma mark TableViews

-(id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)aTableColumn
		   row:(int)rowIndex
{
    if([[aTableColumn identifier] isEqualToString:@"Viewer"])
	return [[[[NPPluginReader pluginReader] cachedPluginOrder] objectAtIndex:rowIndex] objectForKey:@"Name"];
    if([[aTableColumn identifier] isEqualToString:@"Use"]){
	NSDictionary *anObject = [[[NPPluginReader pluginReader] cachedPluginOrder] objectAtIndex:rowIndex];
	NSCell *aCell = [aTableColumn dataCellForRow:rowIndex];
	[aCell setState:([[anObject objectForKey:@"Chosen"] boolValue] ? NSOnState : NSOffState)];
	return aCell;
    }
    
    return nil;
}

-(int)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [[[Preferences mainPrefs] viewerPluginPrefs] count];
}

-(void)tableView:(NSTableView *)aTableView
 willDisplayCell:(id)aCell
  forTableColumn:(NSTableColumn *)aTableColumn
	     row:(int)rowIndex
{
	if([[aTableColumn identifier] isEqualToString:@"Use"]){
	    id anObject = [[[NPPluginReader pluginReader] cachedPluginOrder] objectAtIndex:rowIndex];
	    [aCell setState:([[anObject objectForKey:@"Chosen"] boolValue] ? NSOnState : NSOffState)];
	    [aCell setTarget:self];
	    [aCell setAction:@selector(updateChosen:)];
	}
}

-(void)updateChosen:(id)sender
{
    id anObject = [[[NPPluginReader pluginReader] cachedPluginOrder] objectAtIndex:[sender selectedRow]];
    id newValue = [NSNumber numberWithBool:![[anObject objectForKey:@"Chosen"] boolValue]];
    [anObject setObject:newValue forKey:@"Chosen"];
    [sender setIntValue:[newValue boolValue]];
    [[Preferences mainPrefs] setViewerPluginPrefs:[[NPPluginReader pluginReader] cachedPluginOrder]];
    [sender reloadData];
}


-(BOOL)tableView:(NSTableView *)tableView
	   writeRows:(NSArray *)rows 
	toPasteboard:(NSPasteboard *)pboard
{
	[_draggingObjects release];
	_draggingObjects = [[NSMutableArray alloc] init];
	
	NSEnumerator* rowsEnumerator = [rows objectEnumerator];
	NSNumber *row;

	while((row = [rowsEnumerator nextObject]))
		[_draggingObjects addObject:[NSNumber numberWithUnsignedInt:[row unsignedIntValue]]];
	
	NSData* data = [NSKeyedArchiver archivedDataWithRootObject:_draggingObjects];
	
	[pboard declareTypes: [NSArray arrayWithObject: @"draggingData"] owner: nil];
	[pboard setData: data forType: @"draggingData"];
	
	return YES;
}

-(NSDragOperation)tableView:(NSTableView *)tableView
			   validateDrop:(id <NSDraggingInfo>)inf
				proposedRow:(int)row 
	  proposedDropOperation:(NSTableViewDropOperation)operation
{
	if (_tableLocked)
		return NSDragOperationNone;
	else
		return NSDragOperationMove;
}

-(BOOL)tableView:(NSTableView *)tableView
      acceptDrop:(id <NSDraggingInfo>)info
	     row:(int)row 
   dropOperation:(NSTableViewDropOperation)operation
{
	NSArray* objects = [NSKeyedUnarchiver unarchiveObjectWithData:
		[[info draggingPasteboard] dataForType: @"draggingData"]];
	NSEnumerator* e = [objects objectEnumerator];
	NSNumber *num = [e nextObject];
	
	if([[[Preferences mainPrefs] viewerPluginPrefs] count] <= (unsigned)row)
		row = [[[Preferences mainPrefs] viewerPluginPrefs] count] - 1;
	[[[Preferences mainPrefs] viewerPluginPrefs] exchangeObjectAtIndex:[num unsignedIntValue]
							 withObjectAtIndex:row];
	while((num = [e nextObject])){
		id pluggables = [[Preferences mainPrefs] viewerPluginPrefs];
		id anObject = [pluggables objectAtIndex:[num unsignedIntValue]];
		[pluggables removeObjectAtIndex:[num unsignedIntValue]];
		[pluggables insertObject:anObject atIndex:(row + 1)];
	}
	
	[bundlePriorityTable setNeedsDisplay:YES];
	[[Preferences mainPrefs] setViewerPluginPrefs:[[NPPluginReader pluginReader] cachedPluginOrder]];
	return YES;
}


@end
