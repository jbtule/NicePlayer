/**
 * NiceScrubber.h
 * NicePlayer
 *
 * The implementation of the movie scrubber.
 */

#import "NiceScrubber.h"


@implementation NiceScrubber

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        left = [[NSImage imageNamed:@"scrubbar_left"]retain];
         right = [[NSImage imageNamed:@"scrubbar_right"]retain];
         center = [[NSImage imageNamed:@"scrubbar_center"]retain];
         scrubClick = [[NSImage imageNamed:@"scrubberClick"]retain];
         scrub = [[NSImage imageNamed:@"scrubber"] retain];
         value=0.0;
         target = nil;
         action = NULL;
         dragging = NO;
    }
    return self;
}

-(void)dealloc
{
    [left release];
    [right release];
    [center release];
    [scrubClick release];
    [scrub release];
    [target release];
    [super dealloc];
}

- (void)drawRect:(NSRect)rect
{
    
    id tempImage;
    if (dragging)
        tempImage = scrubClick;
    else 
        tempImage = scrub;
    
    [self lockFocus];
    
    [left drawAtPoint:NSMakePoint(0,0) 
             fromRect:NSMakeRect(0, 0,
                                 [left size].width,
                                 [left size].height) 
            operation:NSCompositeSourceOver
             fraction:1.0];
    
    
    [center drawInRect:NSMakeRect(5,0,
                                   [self frame].size.width-10,
                                   [self frame].size.height)
              fromRect:NSMakeRect(0,0,
                                  [center size].width,
                                  [center size].height) 
             operation:NSCompositeSourceOver
              fraction:1.0];
    
    [right drawAtPoint:NSMakePoint([self frame].size.width-5,0)
              fromRect:NSMakeRect(0,0,
                                  [right size].width,
                                  [right size].height) 
             operation:NSCompositeSourceOver
              fraction:1.0];
    
    [tempImage drawAtPoint:NSMakePoint(5+([self doubleValue]*([self frame].size.width-10))-[scrub size].width/2,[self frame].size.height/2 - [tempImage size].height/2 )
                 fromRect:NSMakeRect(0,0,
                                     [tempImage size].width,
                                     [tempImage size].height) 
                operation:NSCompositeSourceOver
                 fraction:1.0];
    
    [self unlockFocus];
    
}

-(void)setDoubleValue:(double)aValue
{
    value = aValue;
}

-(double)doubleValue
{
    return value;
}

-(void)setTarget:(id)aTarget
{
    [target release];
    target = [aTarget retain];
}

-(id)target
{
    return target;
}
-(void)setAction:(SEL)anAction
{
    action = anAction;
}

-(SEL)action
{
    return action;
}


- (void)mouseDragged:(NSEvent *)anEvent
{
    float loc =[self convertPoint:[anEvent locationInWindow]fromView:[[self window] contentView]].x;
    
    if(loc <= 5)
        [self setDoubleValue:0.0];
    else if(loc >=5 && loc <= ([self frame].size.width-5.0)){
        [self setDoubleValue: (loc-5.0)/([self frame].size.width-10.0)];
        
    } else 
        [self setDoubleValue:1.0];
    [[self target] performSelector:[self action]withObject:self];
}

-(BOOL)inUse
{
    return dragging;
}

-(void)mouseUp:(NSEvent *)anEvent
{
    dragging = NO;
    [self setNeedsDisplay:YES];
}

-(void)mouseDown:(NSEvent *)anEvent
{
    dragging =YES;
    float loc =[self convertPoint:[anEvent locationInWindow]fromView:[[self window] contentView]].x;

    if(loc <= 5)
        [self setDoubleValue:0.0];
    else if(loc >=5 && loc <= ([self frame].size.width-5.0)){
        [self setDoubleValue: (loc-5.0)/([self frame].size.width-10.0)];

    } else 
        [self setDoubleValue:1.0];
    [[self target] performSelector:[self action]withObject:self];
}

@end
