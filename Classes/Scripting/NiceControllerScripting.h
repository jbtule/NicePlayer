/*
 *  NiceControllerScripting.h
 *  NicePlayer
 *
 *  Created by Robert Chin on 2/13/05.
 *  Copyright 2005 __MyCompanyName__. All rights reserved.
 *
 */

#import "NiceController.h"

@interface NiceController (NiceControllerScripting)

-(void)handleEnterFullScreen:(id)tempWindow;
-(void)handleExitFullScreen:(id)tempWindow;
-(void)handleToggleFullScreen:(id)tempWindow;

@end