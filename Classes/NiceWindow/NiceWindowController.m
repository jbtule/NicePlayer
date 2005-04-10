//
//  NiceWindowController.m
//  NicePlayer
//
//  Created by James Tuley on 4/9/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "NiceWindowController.h"


@implementation NiceWindowController

- (id)initWithWindowNibName:(NSString *)windowNibName owner:(id)owner{
    if(self = [super initWithWindowNibName:windowNibName owner:owner]){
        [self setShouldCascadeWindows:NO];
    }return self;
    
}




- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName
{
    if([displayName hasPrefix:@"Untitled"]){
        NSMutableString *newString = [NSMutableString stringWithString:displayName];
        [newString replaceOccurrencesOfString:@"Untitled"
                                   withString:@"NicePlayer"
                                      options:NSAnchoredSearch
                                        range:NSMakeRange(0, [newString length])];
        return newString;
    } else
        return displayName;
}

-(NSPoint)pointForNewWindow{
    int tScreenPref = -1;

    NSRect tScreenRect = [[NSScreen mainScreen] visibleFrame];
    NSArray* tScreens = [NSScreen screens];
    if(tScreenPref < 0){//Open on current window monitor
        NSRect tWinRect = [[NSApp bestMovieWindow] frame];
        
        BOOL selectIntersection(id each,void* context){
            return NSIntersectsRect([each visibleFrame], tWinRect);
        }
        
        NSArray* tIntersectScreens =[tScreens selectUsingFunction:selectIntersection context:nil];
        
        if([tIntersectScreens count] > 1){           
            id getGreatestIntersection(id each, id injection, void* context){
                NSRect tIntersection  =  NSIntersectionRect([each visibleFrame],tWinRect);
                if(tIntersection.size.width * tIntersection.size.height 
                   > [injection rectValue].size.width * [injection rectValue].size.height){
                    tScreenRect =[each visibleFrame];
                    return [NSValue valueWithRect:tIntersection];
                }else{
                    return injection;
                }
            }
            
            [tIntersectScreens injectObject:[NSValue valueWithRect:NSMakeRect(0,0,-10,-10)]
                                                      intoFunction:getGreatestIntersection
                                                           context:nil];
                
        }else if([tIntersectScreens notEmpty]){
            tScreenRect = [[tIntersectScreens firstObject] visibleFrame];
        }

    }else{
        if(tScreenPref < [tScreens count]){
            tScreenRect = [[tScreens objectAtIndex:tScreenPref] visibleFrame];
        }
    }  

    BOOL selectWindowsContainedInRect(id each,void* context){
        return NSContainsRect(tScreenRect,[each frame]);
    }
    
    id tWindow = [[NSApp movieWindows] detectUsingFunction:selectWindowsContainedInRect context:nil];

    if(tWindow != nil){
        return NSMakePoint([tWindow frame].origin.x + 24,[tWindow frame].origin.y -24);
    }else{
        return NSMakePoint(tScreenRect.origin.x,tScreenRect.origin.y + tScreenRect.size.height - [[self window] frame].size.height );
    }
    
    
}


- (void)windowDidLoad{
    
    [[self window] setFrameOrigin:[self pointForNewWindow]];
 
}
@end
