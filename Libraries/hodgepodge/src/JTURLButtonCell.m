//
//  JTURLButtonCell.m
//  IndyKit
//
//  Created by James Tuley on Sun Aug 01 2004.
//  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
//



#import "JTURLButtonCell.h"


@implementation JTURLButtonCell

- (id)initTextCell:(NSString *)aString
{
    if (self = [super initTextCell:aString]) {
        _goToURL = [[NSURL URLWithString:@""] retain];
        [self _sharedInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder{
    if(self = [super initWithCoder:decoder]){
    
        if ([decoder allowsKeyedCoding]) 
            _goToURL = [[decoder decodeObjectForKey:@"goToURL"]retain];
        else
           _goToURL = [[decoder decodeObject]retain];

        [self _sharedInit];
    }return self;
}

- (void)encodeWithCoder:(NSCoder *)coder{
    [super encodeWithCoder:coder];
    if ([coder allowsKeyedCoding]) 
        [coder encodeObject:_goToURL forKey:@"goToURL"];
    else
        [coder encodeObject:_goToURL];

}

-(void)_sharedInit{
    _mouseIsDown = NO;
    _mouseIsEntered = NO;
}


-(NSURL*)URL{
    return _goToURL;
}

-(void)setURL:(NSURL*)aURL{
    [_goToURL release];
    _goToURL = aURL;
    [_goToURL retain];
}

-(NSString*)displayString{
    if([[self title]isEmpty]){
        if([[[self URL] absoluteString] isEmpty])
            return @"?";
        else
            return [[self URL] absoluteString];
    }else
        return [self title];
}


-(void)setMouseDown:(BOOL)aBool{
    _mouseIsDown = aBool;
}

-(BOOL)mouseDown{
    return _mouseIsDown;
}

- (void)mouseEntered:(NSEvent *)event{
    _mouseIsEntered = YES;
    [super mouseEntered:event];
}

- (BOOL)startTrackingAt:(NSPoint)startPoint inView:(NSView *)controlView{
    _mouseIsEntered = YES;
    NSLog(@"start");
    return YES;
}

- (BOOL)continueTracking:(NSPoint)lastPoint at:(NSPoint)currentPoint inView:(NSView *)controlView{
    _mouseIsEntered = NSPointInRect(currentPoint,[controlView frame]);
    NSLog(@"continue %d",_mouseIsEntered);
    return YES;
    
}

- (void)stopTracking:(NSPoint)lastPoint at:(NSPoint)stopPoint inView:(NSView *)controlView mouseIsUp:(BOOL)flag{
    _mouseIsDown = !flag;
    _mouseIsEntered = flag;
    NSLog(@"stop %d %d",_mouseIsEntered,flag);
    if(flag)
        [self goToURL:controlView];
    
}

-(void)goToURL:(id)sender{
    if(![[[self URL] absoluteString]isEmpty])
         [[NSWorkspace sharedWorkspace] openURL:[self URL]];
}

- (void)mouseExited:(NSEvent *)event{
    _mouseIsEntered = NO;
    [super mouseExited:event];
}

-(NSColor*)linkColor{
    if (_mouseIsDown && _mouseIsEntered){
        return [NSColor redColor];   
    }else{
        return [NSColor blueColor];
    }
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView{
    if(![self showsBorderOnlyWhileMouseInside] || _mouseIsEntered){
        [[self displayString]  drawInRect:cellFrame withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[self linkColor],NSForegroundColorAttributeName,[NSNumber numberWithInt:NSUnderlineStyleSingle],NSUnderlineStyleAttributeName,nil]];
    }else{
        [self drawInteriorWithFrame:cellFrame inView:controlView];
    }

}




- (BOOL)isOpaque{
    return NO;
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView{
    [[self displayString] drawInRect:cellFrame withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[self linkColor],NSForegroundColorAttributeName,nil]];
}

@end
