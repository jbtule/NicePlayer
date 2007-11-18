//
//  test.h
//  aem
//
//  Copyright (C) 2007 HAS
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>
#import "base.h"



/**********************************************************************/
// Forward declarations

@class AEMAND;
@class AEMOR;
@class AEMNOT;


/**********************************************************************/
// initialise constants

void initTestModule(void); // called automatically

void disposeTestModule(void);


/**********************************************************************/
// Abstract base class for all comparison and logic test classes

@interface AEMTest : AEMQuery

- (AEMAND	*)AND:(id)remainingOperands; // takes a single test clause or an NSArray of test clauses
- (AEMOR	*)OR:(id)remainingOperands;
- (AEMNOT	*)NOT;

- (NSString *)formatString;

@end


/**********************************************************************/
// Comparison tests

// Abstract base class for all comparison test classes
@interface AEMComparisonBase : AEMTest {
	id operand1, operand2;	
}

- (id)initWithOperand1:(id)operand1_ operand2:(id)operand2_;

@end

// comparison tests
// Note: clients should not instantiate these classes directly

@interface AEMGreaterThan : AEMComparisonBase
@end

@interface AEMGreaterOrEquals : AEMComparisonBase
@end

@interface AEMEquals : AEMComparisonBase
@end

@interface AEMNotEquals : AEMComparisonBase
@end

@interface AEMLessThan : AEMComparisonBase
@end

@interface AEMLessOrEquals : AEMComparisonBase
@end

@interface AEMBeginsWith : AEMComparisonBase
@end

@interface AEMEndsWith : AEMComparisonBase
@end

@interface AEMContains : AEMComparisonBase
@end

@interface AEMIsIn : AEMComparisonBase
@end


/**********************************************************************/
// Logical tests

// Abstract base class for all logical test classes
@interface AEMLogicalBase : AEMTest {
	NSArray *operands;	
}

- (id)initWithOperands:(NSArray *)operands_;

- (id)resolveWithTarget:(id)target rest:(NSArray *)rest;

@end

// logical tests
// Note: clients should not instantiate these classes directly

@interface AEMAND : AEMLogicalBase
@end

@interface AEMOR : AEMLogicalBase
@end

@interface AEMNOT : AEMLogicalBase
@end

