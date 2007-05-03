//
//  JTPreferenceWindow-Private.m
//  IndyKit
//
//  Created by James Tuley on Fri Jun 18 2004.
//  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
//

#import "JTPreferenceWindow-Private.h"
#import "JTToolbarTabbedController-Private.h"
//#import "NDAlias.h"

@implementation JTPreferenceWindow(Private)

- (void)_JTlazyInitialize{
    if([self toolbar]==nil){
       // NSLog(@"Initialize for first time");
        NSToolbar* tempToolbar =[[NSToolbar alloc]initWithIdentifier:@"Preferences Toolbar"];
        [tempToolbar setDelegate:self];
        [self setToolbar:tempToolbar]; 
        [self showPaneWithIdentifier:[_toolbarOrder objectAtIndex:0]];
        [tempToolbar validateVisibleItems];
    }
}

-(id)_toolbarDict{
    return _toolbarDict;
}

-(id)_toolbarOrder{
    return _toolbarOrder;
}

-(void)set_toolbarDict:(id)aDict{
    [_toolbarDict release];
    _toolbarDict = [aDict retain];
}

-(void)set_toolbarOrder:(id)anArray{
    [_toolbarOrder release];
    _toolbarOrder = [anArray retain];
    
}


-(id)_selectedProperty:(NSString*)aKey{
	
	return [[_toolbarDict objectForKey:[[self toolbar]selectedItemIdentifier]] objectForKey:aKey];
}

-(void)_setSelectedProperty:(id)prop forKey:(NSString*)aKey{
	
        [[_toolbarDict objectForKey:[[self toolbar]selectedItemIdentifier]] setObject:prop forKey:aKey];
}


-(IBAction)_JTshowPane:(NSToolbarItem*)sender{

    if(![[[self toolbar] selectedItemIdentifier] isEqualTo:_lastIdentifier]){

        [[self toolbar] setSelectedItemIdentifier:[sender itemIdentifier]];
        BOOL willAllowResize = [[[_toolbarDict objectForKey:[sender itemIdentifier]] objectForKey:@"Resize"] boolValue];
        [self setTitle:[NSString stringWithFormat:@"%@ %@ %@",[self titlePrefix],[sender label],[self titleSuffix],nil]];
        [self _JTshowPaneWithView:[[_toolbarDict objectForKey:[sender itemIdentifier]] objectForKey:@"View"]andResetWidth:!willAllowResize];
        
        [self setShowsResizeIndicator:willAllowResize];
        [[self standardWindowButton:NSWindowZoomButton] setEnabled:willAllowResize];
        
        [_lastIdentifier release];
        _lastIdentifier = [[sender itemIdentifier] retain];
    }
}

-(void)_JTshowPaneWithView:(NSView*)myNewView andResetWidth:(BOOL)widthReset{
    float newHeight =(([myNewView bounds]).size.height) + [self _JTtoolbarHeightForWindow];
    float newWidth;
    NSRect myWinFrame =[self frame];
    if(widthReset)
        newWidth = [self minSize].width;
    else
        newWidth = myWinFrame.size.width;
    NSRect newFrame=NSMakeRect(myWinFrame.origin.x,myWinFrame.origin.y-(newHeight- myWinFrame.size.height),newWidth,newHeight);
    [self setContentView:_blankView];
    [self setFrame:newFrame display:YES animate:YES];
    [self setContentView:myNewView];
}

-(float)_JTtoolbarHeightForWindow{
    NSWindow* aWindow = self;
    NSToolbar *toolbar;
    float toolbarHeight = 0.0;
    NSRect windowFrame;
    
    toolbar = [aWindow toolbar];
    
    if(toolbar && [toolbar isVisible])
    {
        windowFrame = [NSWindow contentRectForFrameRect:[aWindow frame]
                                              styleMask:[aWindow styleMask]];
        toolbarHeight = NSHeight(windowFrame)
            - NSHeight([[aWindow contentView] frame]);
    }
    
    return  toolbarHeight+22;
}

@end
