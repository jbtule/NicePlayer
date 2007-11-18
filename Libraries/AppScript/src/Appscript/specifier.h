//
//  specifier.h
//  aem
//
//  Copyright (C) 2007 HAS
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>
#import "base.h"
#import "test.h"

/* TO DO:
 *
 * - provide an abstract AEMResolverBase class that third-party clients can subclass
 *   in order to create resolver objects to pass to AEM specifiers' -resolve: method.
 *   This base class should provide default implementations of all known specifier and
 *   test methods; these should in turn call a common -selector:args: method that does
 *   nothing by default. Subclasses can then override any of the specific specifier/
 *   test methods and/or the -selector:args: method according to their needs.
 *
 * - declare protocol/base class for reference resolver objects
 *
 * - implement AEMCustomRoot
 *
 * - since frameworks are never unloaded, do we really need disposeSpecifierModule()?
 */

/**********************************************************************/


#define AEMApp [AEMApplicationRoot applicationRoot]
#define AEMCon [AEMCurrentContainerRoot currentContainerRoot]
#define AEMIts [AEMObjectBeingExaminedRoot objectBeingExaminedRoot]


/**********************************************************************/
// Forward declarations

@class AEMPropertySpecifier;
@class AEMUserPropertySpecifier;
@class AEMElementByNameSpecifier;
@class AEMElementByIndexSpecifier;
@class AEMElementByIDSpecifier;
@class AEMElementByOrdinalSpecifier;
@class AEMElementByRelativePositionSpecifier;
@class AEMElementsByRangeSpecifier;
@class AEMElementsByTestSpecifier;
@class AEMAllElementsSpecifier;

@class AEMGreaterThan;
@class AEMGreaterOrEquals;
@class AEMEquals;
@class AEMNotEquals;
@class AEMLessThan;
@class AEMLessOrEquals;
@class AEMBeginsWith;
@class AEMEndsWith;
@class AEMContains;
@class AEMIsIn;

@class AEMSpecifier;
@class AEMReferenceRootBase;
@class AEMApplicationRoot;
@class AEMCurrentContainerRoot;
@class AEMObjectBeingExaminedRoot;

@class AEMTest;


/**********************************************************************/
// initialise constants

void initSpecifierModule(void); // called automatically

void disposeSpecifierModule(void);


/**********************************************************************/
// Specifier base

/*
 * Abstract base class for all object specifier classes.
 */
@interface AEMSpecifier : AEMQuery {
	AEMSpecifier *container;
	id key;
}

- (id)initWithContainer:(AEMSpecifier *)container_ key:(id)key_;

// reserved methods

- (AEMReferenceRootBase *)root;
- (AEMSpecifier *)trueSelf;

@end


/**********************************************************************/
// Insertion location specifier

/*
 * A reference to an element insertion point.
 */
@interface AEMInsertionSpecifier : AEMSpecifier
@end


/**********************************************************************/
// Position specifier base

/*
 * All property and element reference forms inherit from this abstract class.
 */
@interface AEMPositionSpecifierBase : AEMSpecifier {
	OSType wantCode;
}

- (id)initWithContainer:(AEMSpecifier *)container_ key:(id)key_ wantCode:(OSType)wantCode_;

// Comparison and logic tests

- (AEMGreaterThan		*)greaterThan:(id)object;
- (AEMGreaterOrEquals	*)greaterOrEquals:(id)object;
- (AEMEquals			*)equals:(id)object;
- (AEMNotEquals			*)notEquals:(id)object;
- (AEMLessThan			*)lessThan:(id)object;
- (AEMLessOrEquals		*)lessOrEquals:(id)object;
- (AEMBeginsWith		*)beginsWith:(id)object;
- (AEMEndsWith			*)endsWith:(id)object;
- (AEMContains			*)contains:(id)object;
- (AEMIsIn				*)isIn:(id)object;

// Insertion location selectors

- (AEMInsertionSpecifier *)beginning;
- (AEMInsertionSpecifier *)end;
- (AEMInsertionSpecifier *)before;
- (AEMInsertionSpecifier *)after;

// property and all-element specifiers

- (AEMPropertySpecifier		*)property:(OSType)propertyCode;
- (AEMUserPropertySpecifier	*)userProperty:(NSString *)propertyName;
- (AEMAllElementsSpecifier	*)elements:(OSType)classCode;

// by-relative-position selectors

- (AEMElementByRelativePositionSpecifier *)previous:(OSType)classCode;
- (AEMElementByRelativePositionSpecifier *)next:(OSType)classCode;

@end


/**********************************************************************/
// Properties

/*
 * Specifier identifying an application-defined property
 */
@interface AEMPropertySpecifier : AEMPositionSpecifierBase
@end


@interface AEMUserPropertySpecifier : AEMPositionSpecifierBase
@end


/**********************************************************************/
// Single elements

/*
 * Abstract base class for all single element specifiers
 */
@interface AEMSingleElementSpecifierBase : AEMPositionSpecifierBase
@end

/*
 * Specifiers identifying a single element by name, index, id or named ordinal
 */
@interface AEMElementByNameSpecifier : AEMSingleElementSpecifierBase
@end

@interface AEMElementByIndexSpecifier : AEMSingleElementSpecifierBase
@end

@interface AEMElementByIDSpecifier : AEMSingleElementSpecifierBase
@end

@interface AEMElementByOrdinalSpecifier : AEMSingleElementSpecifierBase
@end

@interface AEMElementByRelativePositionSpecifier : AEMPositionSpecifierBase
@end


/**********************************************************************/
// Multiple elements

/*
 * Base class for all multiple element specifiers.
 */
@interface AEMMultipleElementsSpecifierBase : AEMPositionSpecifierBase 

// ordinal selectors

- (AEMElementByOrdinalSpecifier *)first;
- (AEMElementByOrdinalSpecifier *)middle;
- (AEMElementByOrdinalSpecifier *)last;
- (AEMElementByOrdinalSpecifier *)any;

// by-index, by-name, by-id selectors
 
- (AEMElementByIndexSpecifier	*)at:(int)index;
- (AEMElementByIndexSpecifier	*)byIndex:(id)index; // normally NSNumber, but may occasionally be other types
- (AEMElementByNameSpecifier	*)byName:(NSString *)name;
- (AEMElementByIDSpecifier		*)byID:(id)id_;

// by-range selector

- (AEMElementsByRangeSpecifier *)at:(int)startIndex to:(int)stopIndex;
- (AEMElementsByRangeSpecifier *)byRange:(id)startReference to:(id)stopReference; // takes two con-based references, with other values being expanded as necessary

// by-test selector

- (AEMElementsByTestSpecifier *)byTest:(AEMTest *)testReference;

@end


@interface AEMElementsByRangeSpecifier : AEMMultipleElementsSpecifierBase {
	id startReference, stopReference;
}

- (id)initWithContainer:(AEMSpecifier *)container_
				  start:(id)startReference_
				   stop:(id)stopReference_
			   wantCode:(OSType)wantCode_;

@end


@interface AEMElementsByTestSpecifier : AEMMultipleElementsSpecifierBase
@end


@interface AEMAllElementsSpecifier : AEMMultipleElementsSpecifierBase
@end


/**********************************************************************/
// Multiple element shim

@interface AEMUnkeyedElementsShim : AEMSpecifier {
	OSType wantCode;
}

- (id)initWithContainer:(AEMSpecifier *)container_ wantCode:(OSType)wantCode_;

@end


/**********************************************************************/
// Reference roots

@interface AEMReferenceRootBase : AEMPositionSpecifierBase

// note: clients should avoid calling this initialiser directly; 
// use AEMApp, AEMCon, AEMIts macros instead.
- (id)initWithDescType:(DescType)descType;

@end

@interface AEMApplicationRoot : AEMReferenceRootBase

// note: clients should avoid calling this initialiser directly; 
// use AEMApp, AEMCon, AEMIts macros instead.
+ (AEMApplicationRoot *)applicationRoot;

@end

@interface AEMCurrentContainerRoot : AEMReferenceRootBase

// note: clients should avoid calling this initialiser directly; 
// use AEMApp, AEMCon, AEMIts macros instead.
+ (AEMCurrentContainerRoot *)currentContainerRoot;

@end

@interface AEMObjectBeingExaminedRoot : AEMReferenceRootBase

// note: clients should avoid calling this initialiser directly; 
// use AEMApp, AEMCon, AEMIts macros instead.
+ (AEMObjectBeingExaminedRoot *)objectBeingExaminedRoot;

@end

