//
//  JTTextFittingView.m
//  FitTextIntoView
//
//  Created by James Tuley on 9/25/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "JTTextFittingView.h"


@implementation JTTextFittingView

-(void)dealloc{
    [theText release];
	[theAttributes release];
	[super dealloc];
}

-(void)setStringValue:(NSString*)aString{
    [theText release];
    theText = [[NSAttributedString alloc] initWithString:aString attributes:theAttributes];
    [self setNeedsDisplay:YES];
    
}

-(void)setMaxTextWidth:(double)aWidth{
	theWidth =aWidth;
}

-(void)setMaxText:(NSString*)aTextRepresentingWidth{
    NSAttributedString* tWidth = [[NSAttributedString alloc] initWithString:aTextRepresentingWidth attributes:theAttributes];

	theWidth =[tWidth size].width;
	[tWidth release];
}

-(void)setAttributes:(NSDictionary*)anAttributes{
[theAttributes release];
	theAttributes =anAttributes;
	[theAttributes retain];
}

-(NSString*)stringValue{
    return [theText string];
}

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        theText = [[NSAttributedString alloc] initWithString:@""];
		theWidth=0;
		theAttributes = [[NSDictionary alloc]init];
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)rect {
    
    // NSRectFill(NSMakeRect(0,0,[theText size].width,[theText size].height));
    double tWidth =[theText size].width;
	if(theWidth!=0){
		tWidth =theWidth;
	}
    double tRWidth =rect.size.width;
    [NSGraphicsContext saveGraphicsState];
	[self lockFocus];
   id transform = [NSAffineTransform transform];


    [transform scaleBy: tRWidth/tWidth];
	[transform translateXBy:tWidth/2.0 yBy:[theText size].height/2.0];

   [transform concat];




	//[theText drawAtPoint:NSMakePoint(0,0)];
   [theText drawInRect:NSMakeRect(-[self frame].size.width/2.0,-[theText size].height/2.0,[self frame].size.width,[theText size].height)];
	[self unlockFocus];
    [NSGraphicsContext restoreGraphicsState];
}

@end
