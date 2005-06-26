//
//  NPApplicationScripting.m
//  NicePlayer
//
//  Created by James Tuley on 2/19/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "NPApplicationScripting.h"


@implementation NPApplication(Scripting)

-(NSArray *)niceMovies
{
    NSMutableArray* tArray =[NSMutableArray array];
    id tPlaylist =[self orderedDocuments];
    unsigned i;
    for(i=0;i<[tPlaylist count];i++){
        [tArray addObjectsFromArray:[[tPlaylist objectAtIndex:i] niceMovies]];
    }
    return tArray;
}


-(id)valueInOrderedDocumentsWithName:(id)anIdentifier{
    BOOL dectectIdentifier(id each, void* context){
                return ([[each identifier] isEqualTo:anIdentifier]);            
    }
    
    [[self orderedDocuments] detectUsingFunction:dectectIdentifier context:nil];
}


-(void)handleEnterFullScreenCommand:(id)sender
{
    [[NiceController controller] enterFullScreen];
}

-(void)handleExitFullScreenCommand:(id)sender
{
    [[NiceController controller] exitFullScreen];
}



@end
