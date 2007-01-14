//
//  JTTextFittingView.h
//  FitTextIntoView
//
//  Created by James Tuley on 9/25/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface JTTextFittingView : NSView {
    NSAttributedString* theText;
	double theWidth;
	NSDictionary* theAttributes;
}

-(void)setStringValue:(NSString*)aString;
-(NSString*)stringValue;

@end
