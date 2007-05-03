//
//  JTToolbarTabbedController.m
//  IndyKit
//
//  Created by James Tuley on 8/29/04.
//  Copyright 2004 __MyCompanyName__. All rights reserved.
//

#import "JTToolbarTabbedController.h"
#import "JTToolbarTabbedController-Private.h"


@implementation JTToolbarTabbedController

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    if ([decoder allowsKeyedCoding]) {
	_toolbarDict = [[decoder decodeObjectForKey:@"ToolBarDict"]retain];
	_toolbarOrder = [[decoder decodeObjectForKey:@"ToolBarOrder"]retain];
        _prefix= [[decoder decodeObjectForKey:@"TitlePrefix"]retain];
        _suffix = [[decoder decodeObjectForKey:@"TitleStuffix"]retain];
    }else{
        
        _toolbarDict=[[decoder decodeObject]retain];
        _toolbarOrder =[[decoder decodeObject]retain];
        _prefix=[[decoder decodeObject]retain];
        _suffix=[[decoder decodeObject]retain];
    }
    
    [self _sharedInit];
    
   // NSLog(@"init3 %@ %@",_toolbarDict,_toolbarOrder);
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
  
    if ([coder allowsKeyedCoding]) {
	[coder encodeObject:_toolbarDict forKey:@"ToolBarDict"];
	[coder encodeObject:_toolbarOrder forKey:@"ToolBarOrder"];
        [coder encodeObject:_prefix forKey:@"TitlePrefix"];
	[coder encodeObject:_suffix forKey:@"TitleStuffix"];
    }else{
        [coder encodeObject:_toolbarDict];
        [coder encodeObject:_toolbarOrder];
        [coder encodeObject:_prefix];
        [coder encodeObject:_suffix];
    }
}

- (NSWindow *)init{
    if(self = [super init]){
        _toolbarDict = nil;
        _toolbarOrder = nil;
        _prefix = nil;
        _suffix = nil;
	[self _sharedInit];
    } 
  //  NSLog(@"init5 %@ %@",_toolbarDict,_toolbarOrder);
    
    return self;
}

-(void)_sharedInit{
    if(_toolbarDict == nil)
        _toolbarDict = [[NSMutableDictionary alloc] init];
    if(_toolbarOrder == nil)
        _toolbarOrder = [[NSMutableArray alloc]init];
    if(_prefix == nil)
        _prefix= [@"" retain];
    if(_suffix == nil)
        _suffix = [@"" retain];
    
  //  NSLog(@"init shared %@ %@",_toolbarDict,_toolbarOrder);
    
    _lastIdentifier =nil;
    _blankView = [[NSView alloc] init];
    
}

-(BOOL)allowsResize{
    
    return [[self _selectedProperty:@"Resize"] boolValue];
}

-(void)setAllowsResize:(BOOL)aBool{
    
    [self _setSelectedProperty:[ NSNumber numberWithBool:aBool] forKey:@"Resize"];
}

-(NSImage*)image{
    
    return [self _selectedProperty:@"Image"];
}

-(void)setImage:(NSImage*)anImage{
    
    [self _setSelectedProperty:anImage forKey:@"Image"];
}


-(NSString*)label{
    
    return [self _selectedProperty:@"Label"];
}


-(void)setLabel:(NSString*)aLabel{
    
    [self _setSelectedProperty:aLabel forKey:@"Label"];
}

-(NSString*)toolTip{
    
    return [self _selectedProperty:@"ToolTip"];
}


-(void)setToolTip:(NSString*)toolTip{
    
    [self _setSelectedProperty:toolTip forKey:@"ToolTip"];
}

-(id)view{
    return [self _selectedProperty:@"View"];
}

-(NSString*)identifier{
    
    return [[self toolbar]selectedItemIdentifier];
}



-(void)setIdentifier:(NSString*)anIdent{
    
    id newItem= [[[NSToolbarItem alloc]initWithItemIdentifier:anIdent]autorelease];
    
    [newItem setTarget: self];
    [newItem setAction: @selector(_JTshowPane:)];
    [newItem setLabel:[self label]];
    [newItem setToolTip: [self toolTip]];
    [newItem setImage: [NSImage imageNamed:[self imageName]]];
    
    // int index =[self removePaneWithIdentifer:anIdent];
    
    id oldIdentifier =[self identifier];
    
    [_toolbarDict setObject:[_toolbarDict objectForKey:oldIdentifier] forKey:anIdent];
    
    [[_toolbarDict objectForKey:anIdent] setObject:newItem forKey:@"Item"];
    
    [_toolbarDict removeObjectForKey:oldIdentifier];
    
    int tempDex = [_toolbarOrder indexOfObject:oldIdentifier];
    [_toolbarOrder replaceObjectAtIndex:tempDex withObject:anIdent];
    
    [self _JTshowPane:newItem];
    
}

-(void)setTitlePrefix:(NSString*)aPrefix{
    [_prefix release];
    _prefix = [aPrefix copy];
}

-(NSString*)titlePrefix{
    if(_prefix == nil)
        return @"";
    else
        return [[_prefix retain] autorelease];
}

-(void)setTitleSuffix:(NSString*)aSuffix{
    [_suffix release];
    _suffix = [aSuffix copy];
}

-(NSString*)titleSuffix{
    if(_suffix == nil)
        return @"";
    else
        return [[_suffix retain] autorelease];
}

- (void)windowDidBecomeMain:(NSNotification *)aNotification{
    [self _JTlazyInitialize];
}

-(int)removePaneWithIdentifer:(NSString*)anIdentifier{
 /*   int index = [[[[controlledWindow toolbar] items] injectUsingFunction:_JTMatchIdentfierToIndex into:[NSNumber numberWithInt:-1] context:anIdentifier] intValue];
    
    id tempOrder = [_toolbarOrder rejectUsingFunction:_JTEqualTo context:anIdentifier];
    
    [_toolbarDict removeObjectForKey:anIdentifier];
    
    [_toolbarOrder release];
    _toolbarOrder = [tempOrder retain];
    */
    return 1;
    
}

-(void)addPane{
    
    id tempIdent=nil;
    int i =1;
    while(tempIdent ==nil){
        tempIdent = [NSString stringWithFormat:@"Indent %d",i,nil];
        if([_toolbarOrder containsObject:tempIdent]){
            NSLog(tempIdent);
            tempIdent = nil;
            i++;
        }
    }
    
    
    
    
    [self addPane:[[[NSView alloc] init] autorelease]
         withIcon:nil
   withIdentifier:tempIdent
        withLabel:@""
      withToolTip:@""
   allowingResize:YES];
    
    [self showPaneWithIdentifier:tempIdent];
}



-(void)addPane:(NSView*)aView 
      withIcon:(NSImage*)anImage
withIdentifier:(NSString*)anIdentifier
     withLabel:(NSString*)aLabel
   withToolTip:(NSString*)aToolTip
allowingResize:(BOOL)allowResize{
    NSLog(@"1");
    
    NSToolbarItem *toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier: anIdentifier] autorelease];
    NSLog(@"2");
    
    [toolbarItem setTarget: self];
    NSLog(@"3");
    
    [toolbarItem setAction: @selector(_JTshowPane:)];
    NSLog(@"4");
    
    [toolbarItem setLabel: aLabel];
    NSLog(@"5");
    
    [toolbarItem setToolTip: aToolTip];
    NSLog(@"6");
    
    [toolbarItem setImage: anImage];
    NSLog(@"7");
    
    NSLog(@"%@ %@",_toolbarDict,_toolbarOrder);
    [_toolbarDict setObject:[NSDictionary dictionaryWithObjectsAndKeys:anImage,@"Image",aView,@"View",toolbarItem,@"Item",[NSNumber numberWithBool:allowResize],@"Resize",nil] forKey:anIdentifier];
    [_toolbarOrder addObject:anIdentifier];
}

-(void)showPaneWithIdentifier:(NSString*)anIdentifier{
    [[controlledWindow toolbar] setSelectedItemIdentifier:anIdentifier];
    [self _JTshowPane:[[_toolbarDict objectForKey:anIdentifier] objectForKey:@"Item"]];
}




-(NSToolbarItem*)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag{
    return [[_toolbarDict objectForKey:itemIdentifier] objectForKey:@"Item"];
}

-(NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar{
    
    return _toolbarOrder; 
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar{
    return _toolbarOrder;    
}

-(NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar{
    return _toolbarOrder; 
    
}


@end
