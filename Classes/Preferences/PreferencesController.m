/**
 * PreferencesController.m
 * NicePlayer
 *
 * The preferences controller allowing the preferences GUI to interact with the preference
 * cache and the NSUserDefaults system.
 */

#import "PreferencesController.h"
#import "../Viewer Interface/NPPluginReader.h"
#import <IndyKit/JTPreferenceWindow.h>
#import "../Viewer Interface/NPPluginDict.h"

@implementation PreferencesController

-(void)awakeFromNib
{
    id tempBundle =[NSBundle bundleForClass:[JTPreferenceWindow self]];
    
    NSString* tGeneralPrefIcon = [tempBundle pathForResource:@"GeneralPreferenceIcon" ofType:@"png"];
    NSString* tActionPrefIcon =[tempBundle pathForResource:@"ActionsPreferenceIcon" ofType:@"png"];

    
	[prefWindow addPane:paneMain
                   withIcon:[[[NSImage alloc]initWithContentsOfFile:tGeneralPrefIcon] autorelease]
		 withIdentifier:@"General"
			  withLabel:@"General"
			withToolTip:@"The General Preference Settings"
		 allowingResize:NO];
	[prefWindow addPane:paneActions
			   withIcon:[[[NSImage alloc]initWithContentsOfFile:tActionPrefIcon] autorelease]
		 withIdentifier:@"Actions"
			  withLabel:@"Actions"
			withToolTip:@"Actions on Movies"
		 allowingResize:NO];
	[prefWindow addPane:paneView
			   withIcon:[NSImage imageNamed:@"ViewerPrefIcon"]
		 withIdentifier:@"Viewer"
			  withLabel:@"Viewer"
			withToolTip:@"Viewer Order for Opening Movies"
		 allowingResize:YES];
	
	[doubleClickMoviePref selectItemAtIndex:[[Preferences mainPrefs] doubleClickMoviePref]];
	[rightClickMoviePref selectItemAtIndex:[[Preferences mainPrefs] rightClickMoviePref]];	
	[scrollResizePin selectItemAtIndex:[[Preferences mainPrefs] scrollResizePin]];
	[defaultTimeDisplay selectItemAtIndex:[[Preferences mainPrefs] defaultTimeDisplay]];
	[defaultRepeatMode selectItemAtIndex:[[Preferences mainPrefs] defaultRepeatMode]];
	[defaultOpenMode selectItemAtIndex:[[Preferences mainPrefs] defaultOpenMode]];

        
        
        
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
	
	[movieOpenedPlay setState:[[Preferences mainPrefs] movieOpenedPlay]];
	[movieOpenedFullScreen setState:[[Preferences mainPrefs] movieOpenedFullScreen]];
	[windowAlwaysOnTop setState:[[Preferences mainPrefs] windowAlwaysOnTop]];
	[windowLeaveFullScreen setState:[[Preferences mainPrefs] windowLeaveFullScreen]];
	
	[bundlePriorityTable setDataSource:self];
	[bundlePriorityTable setDelegate:self];
	[bundlePriorityTable registerForDraggedTypes:[NSArray arrayWithObjects:@"draggingData", nil]];
}

-(IBAction)doubleClickMoviePref:(id)sender
{
	[[Preferences mainPrefs] setDoubleClickMoviePref:[sender indexOfSelectedItem]];
}

-(IBAction)rightClickMoviePref:(id)sender
{
	[[Preferences mainPrefs] setRightClickMoviePref:[sender indexOfSelectedItem]];
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

#pragma mark -
#pragma mark TableViews

-(id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)aTableColumn
		   row:(int)rowIndex
{
    if([[aTableColumn identifier] isEqualToString:@"Viewer"]){
		id anObject = [[[Preferences mainPrefs] viewerPluginPrefs] objectAtIndex:rowIndex];
		return [[[[NPPluginReader pluginReader] prefDictionary] valueForKey:anObject] valueForKey:@"Name"];
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
		id anObject = [[[Preferences mainPrefs] viewerPluginPrefs] objectAtIndex:rowIndex];
		[aCell setIntValue:
			([[[[[NPPluginReader pluginReader] prefDictionary] valueForKey:anObject] valueForKey:@"Chosen"] boolValue])];
		[aCell setTarget:anObject];
		[aCell setAction:@selector(updateChosen:)];
	}
}

-(BOOL)tableView:(NSTableView *)tableView
	   writeRows:(NSArray *)rows 
	toPasteboard:(NSPasteboard *)pboard
{
	[_draggingObjects release];
	_draggingObjects = [[NSMutableArray alloc] init];
	
	NSEnumerator* rowsEnumerator = [rows objectEnumerator];
	NSNumber *row;

	while(row = [rowsEnumerator nextObject])
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
	while(num = [e nextObject]){
		id pluggables = [[Preferences mainPrefs] viewerPluginPrefs];
		id anObject = [pluggables objectAtIndex:[num unsignedIntValue]];
		[pluggables removeObjectAtIndex:[num unsignedIntValue]];
		[pluggables insertObject:anObject atIndex:(row + 1)];
	}
	
	[bundlePriorityTable setNeedsDisplay:YES];
	return YES;
}


@end
