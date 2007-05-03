//
//  Test-JTCryptKey.h
//  IndyKit
//
//  Created by James Tuley on Sat Jul 31 2004.
//  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>


@interface Test_JTCryptKey : SenTestCase {
    id cryptPhrase;
    id rsakeypair;
    id dsakeypair;
    id mySecretData;
    id notMySecretData;
}

@end
