//
//  NiceWindowController.m
//  NicePlayer
//
//  Created by James Tuley on 4/9/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "NiceWindowController.h"
#import "NPApplication.h"

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

- (void)windowDidLoad{
    int tScreenPref = -1;
    
    NSScreen* tScreen = [NSScreen mainScreen];
    NSArray* tScreens = [NSScreen screens];
    
    if(tScreenPref > 0 && (tScreenPref < (int)[tScreens count])){
        tScreen = [tScreens objectAtIndex:tScreenPref];
    }  
    
    NSRect tScreenRect = [tScreen visibleFrame];
    
    NSValue* tPoint = nil;
    
    BOOL rejectSelf(id each,void* context){
        return [each isEqual:[self window]];
    }
    
    NSArray* tMovieWindows = [[NSApp movieWindows] rejectUsingFunction:rejectSelf context:nil];
    
    
    BOOL findOpenPoint(id each, void* context){
        NSRect tWinRect = [each frame];
        NSRect tNewRect = NSMakeRect([tPoint pointValue].x,[tPoint pointValue].y,[[self window] frame].size.width,[[self window] frame].size.height);
        
        return NSIntersectsRect(tWinRect,tNewRect) || !NSContainsRect(tScreenRect,tNewRect);
    }
    
    void findSpace(id each, void* context, BOOL* endthis){
        for(float j = tScreenRect.origin.y + tScreenRect.size.height - [[self window] frame].size.height; j >= tScreenRect.origin.y; j -= [[self window] frame].size.height){
                for(float i = tScreenRect.origin.x; i < tScreenRect.origin.x + tScreenRect.size.width; i+= [[self window] frame].size.width){
                tPoint= [NSValue valueWithPoint:NSMakePoint(i,j)];
                if(nil == [tMovieWindows detectUsingFunction:findOpenPoint context:nil]){
                    STDoBreak(endthis);
                }
                tPoint = nil;
            }
        }
    }
    
    int sortByMain(id v1, id v2, void* context){
        if([v1 isEqualTo:v2])
            return NSOrderedSame;
        if([[NSScreen mainScreen] isEqualTo: v1]){
            return NSOrderedDescending;
        }
        
        return NSOrderedAscending;
    }

    if(tScreen < 0){
        [[[NSScreen screens] sortedArrayUsingFunction:sortByMain context:nil] doUsingFunction:findSpace context:nil];
    }else{
        BOOL tDummy;
        findSpace(tScreen,nil,&tDummy);
    }

    if(tPoint == nil){
        BOOL findWindowScreen(id each, void* context){
            return [[each screen] isEqual:tScreen];
        }
        id tWindow = [[NSApp movieWindows] detectUsingFunction:findWindowScreen context:nil];
        [[self window] cascadeTopLeftFromPoint:[tWindow frame].origin];
    }else{
        [[self window] setFrameOrigin:[tPoint pointValue]];
    }
    
    
}
@end
