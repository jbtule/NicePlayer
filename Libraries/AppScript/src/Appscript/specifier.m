//
//  specifier.m
//  aem
//
//  Copyright (C) 2007 HAS
//

#import "specifier.h"


// note: [desc stringValue] doesn't work in 10.5 for typeType descs, so use the following workaround:
#define typeDescToString(desc) [[desc coerceToDescriptorType: typeUnicodeText] stringValue]



/**********************************************************************/
// initialise/dispose constants


#define ENUMERATOR(name) \
		descData = kAE##name; \
		kEnum##name = [[NSAppleEventDescriptor alloc] initWithDescriptorType:typeEnumerated \
														 bytes:&descData \
														length:sizeof(descData)];

#define ORDINAL(name) \
		descData = kAE##name; \
		kOrdinal##name = [[NSAppleEventDescriptor alloc] initWithDescriptorType:typeAbsoluteOrdinal \
														 bytes:&descData \
														length:sizeof(descData)];

#define KEY_FORM(name) \
		descData = form##name; \
		kForm##name = [[NSAppleEventDescriptor alloc] initWithDescriptorType:typeEnumerated \
														 bytes:&descData \
														length:sizeof(descData)];

// insertion locations
static NSAppleEventDescriptor *kEnumBeginning,
							  *kEnumEnd,
							  *kEnumBefore,
							  *kEnumAfter;

// relative positions
static NSAppleEventDescriptor *kEnumPrevious,
							  *kEnumNext;

// absolute ordinals
static NSAppleEventDescriptor *kOrdinalFirst,
							  *kOrdinalMiddle,
							  *kOrdinalLast,
							  *kOrdinalAny,
							  *kOrdinalAll;

// key forms
static NSAppleEventDescriptor *kFormPropertyID,
							  *kFormUserPropertyID,
							  *kFormName,
							  *kFormAbsolutePosition,
							  *kFormUniqueID,
							  *kFormRelativePosition,
							  *kFormRange,
							  *kFormTest;


// prepacked value for keyDesiredClass for use by -packSelf: in property specifiers
static NSAppleEventDescriptor *kClassProperty;


// prepacked value for use by -init...: in by-test specifier
static NSAppleEventDescriptor *kTypeTrue;


// blank record used by -packSelf: to construct object specifier descriptors
static NSAppleEventDescriptor *kNullRecord;


static BOOL specifierModulesAreInitialized = NO;


void initSpecifierModule(void) {
	OSType descData;
	
	initTestModule();
	// insertion locations
	ENUMERATOR(Beginning);
	ENUMERATOR(End);
	ENUMERATOR(Before);
	ENUMERATOR(After);
	// relative positions
	ENUMERATOR(Previous);
	ENUMERATOR(Next);
	// absolute ordinals
	ORDINAL(First);
	ORDINAL(Middle);
	ORDINAL(Last);
	ORDINAL(Any);
	ORDINAL(All);
	//key forms
	KEY_FORM(PropertyID);
	KEY_FORM(UserPropertyID);
	KEY_FORM(Name);
	KEY_FORM(AbsolutePosition);
	KEY_FORM(UniqueID);
	KEY_FORM(RelativePosition);
	KEY_FORM(Range);
	KEY_FORM(Test);
	// miscellaneous
	descData = cProperty;
	kClassProperty = [[NSAppleEventDescriptor alloc] initWithDescriptorType: typeType
																	  bytes: &descData
																	 length: sizeof(descData)];
	kNullRecord = [[NSAppleEventDescriptor alloc] initRecordDescriptor];
	kTypeTrue = [[NSAppleEventDescriptor alloc] initWithDescriptorType: typeTrue
																 bytes: NULL
																length: 0];
	specifierModulesAreInitialized = YES;
}


void disposeSpecifierModule(void) {
	disposeTestModule();
	// insertion locations
	[kEnumBeginning release];
	[kEnumEnd release];
	[kEnumBefore release];
	[kEnumAfter release];
	// relative positions
	[kEnumPrevious release];
	[kEnumNext release];
	// absolute ordinals
	[kOrdinalFirst release];
	[kOrdinalMiddle release];
	[kOrdinalLast release];
	[kOrdinalAny release];
	[kOrdinalAll release];
	//key forms
	[kFormPropertyID release];
	[kFormUserPropertyID release];
	[kFormName release];
	[kFormAbsolutePosition release];
	[kFormUniqueID release];
	[kFormRelativePosition release];
	[kFormRange release];
	[kFormTest release];
	// miscellaneous
	[kClassProperty release];
	[kNullRecord release];
	[kTypeTrue release];
	specifierModulesAreInitialized = NO;
}


/**********************************************************************/
// Specifier base

/*
 * Abstract base class for all object specifier classes.
 */
@implementation AEMSpecifier

- (id)initWithContainer:(AEMSpecifier *)container_ key:(id)key_ {
	self = [super init];
	if (!self) return self;
	[container_ retain];
	container = container_;
	[key_ retain];
	key = key_;
	return self;
}

- (void)dealloc {
	[container release];
	[key release];
	[super dealloc];
}

// reserved methods

- (AEMReferenceRootBase *)root {
	return [container root];
}

- (AEMSpecifier *)trueSelf {
	return self;
}


@end


/**********************************************************************/
// Insertion location specifier

/*
 * A reference to an element insertion point.
 *
 * key : NSAppleEventDescriptor of typeEnumerated, value:
 *			 kEnumBeginning/kEnumEnd/kEnumBefore/kEnumAfter
 *
 */
@implementation AEMInsertionSpecifier

- (NSString *)description {
	switch ([key enumCodeValue]) {
		case kAEBeginning:
			return [NSString stringWithFormat: @"[%@ beginning]", container];
		case kAEEnd:
			return [NSString stringWithFormat: @"[%@ end]", container];
		case kAEBefore:
			return [NSString stringWithFormat: @"[%@ before]", container];
		case kAEAfter:
			return [NSString stringWithFormat: @"[%@ after]", container];
		default:
			return nil;
	}
}

- (NSAppleEventDescriptor *)packSelf:(id)codecs {
	if (!cachedDesc) {
		cachedDesc = [kNullRecord coerceToDescriptorType: typeInsertionLoc];
		[cachedDesc setDescriptor: [container packSelf: codecs] forKeyword: keyAEObject];
		[cachedDesc setDescriptor: key forKeyword: keyAEPosition];
	}
	return cachedDesc;	
}

-(id)resolve:(id)object { 
	id result;
	
	result = [container resolve: object];
	switch ([key enumCodeValue]) {
		case kAEBeginning:
			return [result beginning];
		case kAEEnd:
			return [result end];
		case kAEBefore:
			return [result before];
		case kAEAfter:
			return [result after];
		default:
			return nil;
	}
}

@end


/**********************************************************************/
// Position specifier base

/*
 * All property and element reference forms inherit from this abstract class.
 */
@implementation AEMPositionSpecifierBase

- (id)initWithContainer:(AEMSpecifier *)container_ key:(id)key_ wantCode:(OSType)wantCode_; {
	self = [super initWithContainer:(AEMSpecifier *)container_ key:(id)key_];
	if (!self) return self;
	wantCode = wantCode_;
	return self;
}

// Comparison and logic tests

- (AEMGreaterThan *)greaterThan:(id)object {
	return [[[AEMGreaterThan alloc] initWithOperand1: self operand2: object] autorelease];
}

- (AEMGreaterOrEquals *)greaterOrEquals:(id)object {
	return [[[AEMGreaterOrEquals alloc] initWithOperand1: self operand2: object] autorelease];
}

- (AEMEquals *)equals:(id)object {
	return [[[AEMEquals alloc] initWithOperand1: self operand2: object] autorelease];
}

- (AEMNotEquals *)notEquals:(id)object {
	return [[[AEMNotEquals alloc] initWithOperand1: self operand2: object] autorelease];
}

- (AEMLessThan *)lessThan:(id)object {
	return [[[AEMLessThan alloc] initWithOperand1: self operand2: object] autorelease];
}

- (AEMLessOrEquals *)lessOrEquals:(id)object {
	return [[[AEMLessOrEquals alloc] initWithOperand1: self operand2: object] autorelease];
}

- (AEMBeginsWith *)beginsWith:(id)object {
	return [[[AEMBeginsWith alloc] initWithOperand1: self operand2: object] autorelease];
}

- (AEMEndsWith *)endsWith:(id)object {
	return [[[AEMEndsWith alloc] initWithOperand1: self operand2: object] autorelease];
}

- (AEMContains *)contains:(id)object {
	return [[[AEMContains alloc] initWithOperand1: self operand2: object] autorelease];
}

- (AEMIsIn *)isIn:(id)object {
	return [[[AEMIsIn alloc] initWithOperand1: self operand2: object] autorelease];
}


// Insertion location selectors

- (AEMInsertionSpecifier *)beginning {
	return [[[AEMInsertionSpecifier alloc] initWithContainer: self key: kEnumBeginning] autorelease];
}

- (AEMInsertionSpecifier *)end {
	return [[[AEMInsertionSpecifier alloc] initWithContainer: self key: kEnumEnd] autorelease];
}

- (AEMInsertionSpecifier *)before {
	return [[[AEMInsertionSpecifier alloc] initWithContainer: self key: kEnumBefore] autorelease];
}

- (AEMInsertionSpecifier *)after {
	return [[[AEMInsertionSpecifier alloc] initWithContainer: self key: kEnumAfter] autorelease];
}


// property and all-element specifiers

- (AEMPropertySpecifier *)property:(OSType)propertyCode {
	return [[[AEMPropertySpecifier alloc]
					   initWithContainer: self
									 key: [NSAppleEventDescriptor descriptorWithTypeCode: propertyCode]
								wantCode: cProperty] autorelease];
}

- (AEMUserPropertySpecifier *)userProperty:(NSString *)propertyName {
	return [[[AEMUserPropertySpecifier alloc]
						   initWithContainer: self
										 key: propertyName
									wantCode: cProperty] autorelease];
}

- (AEMAllElementsSpecifier *)elements:(OSType)classCode {
	return [[[AEMAllElementsSpecifier alloc]
						  initWithContainer: self
								   wantCode: classCode] autorelease];
}


// by-relative-position selectors

- (AEMElementByRelativePositionSpecifier *)previous:(OSType)classCode {
	return [[[AEMElementByRelativePositionSpecifier alloc]
										initWithContainer: self
													  key: kEnumPrevious
												 wantCode: classCode] autorelease];
}

- (AEMElementByRelativePositionSpecifier *)next:(OSType)classCode {
	return [[[AEMElementByRelativePositionSpecifier alloc]
										initWithContainer: self
													  key: kEnumNext
												 wantCode: classCode] autorelease];
}

@end


/**********************************************************************/
// Properties

/*
 * A reference to a user-defined property specifier
 */
@implementation AEMPropertySpecifier

- (NSString *)description {
	return [NSString stringWithFormat: @"[%@ property: '%@']", container, typeDescToString(key)];
}

// reserved methods

- (NSAppleEventDescriptor *)packSelf:(id)codecs {
	if (!cachedDesc) {
		cachedDesc = [kNullRecord coerceToDescriptorType: typeObjectSpecifier];
		[cachedDesc setDescriptor: kClassProperty forKeyword: keyAEDesiredClass];
		[cachedDesc setDescriptor: kFormPropertyID forKeyword: keyAEKeyForm];
		[cachedDesc setDescriptor: key forKeyword: keyAEKeyData];
		[cachedDesc setDescriptor: [container packSelf: codecs] forKeyword: keyAEContainer];
	}
	return cachedDesc;
}

-(id)resolve:(id)object { 
	return [[container resolve: object] property: [key typeCodeValue]];
}

@end


@implementation AEMUserPropertySpecifier

- (NSString *)description {
	return [NSString stringWithFormat: @"[%@ userProperty: '%@']", container, key];
}

// reserved methods

- (NSAppleEventDescriptor *)packSelf:(id)codecs {
	if (!cachedDesc) {
		cachedDesc = [kNullRecord coerceToDescriptorType: typeObjectSpecifier];
		[cachedDesc setDescriptor: kClassProperty forKeyword: keyAEDesiredClass];
		[cachedDesc setDescriptor: kFormUserPropertyID forKeyword: keyAEKeyForm];
		[cachedDesc setDescriptor: [[NSAppleEventDescriptor descriptorWithString: key] coerceToDescriptorType: typeChar]
					   forKeyword: keyAEKeyData];
		[cachedDesc setDescriptor: [container packSelf: codecs] forKeyword: keyAEContainer];
	}
	return cachedDesc;
}

-(id)resolve:(id)object { 
	return [[container resolve: object] userProperty: key];
}

@end


/**********************************************************************/
// Single elements

/*
 * Abstract base class for all single element specifiers
 * (except AEMElementByRelativePositionSpecifier, which
 * needs the original container reference as-is while
 * the rest call its -trueSelf method to get rid of any
 * all-elements specifiers)
 */
@implementation AEMSingleElementSpecifierBase

- (id)initWithContainer:(AEMSpecifier *)container_ key:(id)key_ wantCode:(OSType)wantCode_; {
	return [super initWithContainer: [container_ trueSelf] key: key_ wantCode: wantCode_];
}

@end


@implementation AEMElementByNameSpecifier

- (NSString *)description {
	return [NSString stringWithFormat: @"[%@ byName: %@]", container, key];
}

// reserved methods

- (NSAppleEventDescriptor *)packSelf:(id)codecs {
	if (!cachedDesc) {
		cachedDesc = [kNullRecord coerceToDescriptorType: typeObjectSpecifier];
		[cachedDesc setDescriptor: [NSAppleEventDescriptor descriptorWithTypeCode: wantCode]
					   forKeyword: keyAEDesiredClass];
		[cachedDesc setDescriptor: kFormName forKeyword: keyAEKeyForm];
		[cachedDesc setDescriptor: [codecs pack: key] forKeyword: keyAEKeyData];
		[cachedDesc setDescriptor: [container packSelf: codecs] forKeyword: keyAEContainer];
	}
	return cachedDesc;
}

-(id)resolve:(id)object { 
	return [[container resolve: object] byName: key];
}

@end


@implementation AEMElementByIndexSpecifier

- (NSString *)description {
	return [NSString stringWithFormat: @"[%@ byIndex: %@]", container, key];
}

// reserved methods

- (NSAppleEventDescriptor *)packSelf:(id)codecs {
	if (!cachedDesc) {
	cachedDesc = [kNullRecord coerceToDescriptorType: typeObjectSpecifier];
	[cachedDesc setDescriptor: [NSAppleEventDescriptor descriptorWithTypeCode: wantCode]
				   forKeyword: keyAEDesiredClass];
	[cachedDesc setDescriptor: kFormAbsolutePosition forKeyword: keyAEKeyForm];
	[cachedDesc setDescriptor: [codecs pack: key] forKeyword: keyAEKeyData];
	[cachedDesc setDescriptor: [container packSelf: codecs] forKeyword: keyAEContainer];
	}
	return cachedDesc;
}

-(id)resolve:(id)object { 
	return [[container resolve: object] byIndex: key];
}

@end


@implementation AEMElementByIDSpecifier

- (NSString *)description {
	return [NSString stringWithFormat: @"[%@ byID: %@]", container, key];
}

// reserved methods

- (NSAppleEventDescriptor *)packSelf:(id)codecs {
	if (!cachedDesc) {
		cachedDesc = [kNullRecord coerceToDescriptorType: typeObjectSpecifier];
		[cachedDesc setDescriptor: [NSAppleEventDescriptor descriptorWithTypeCode: wantCode]
					   forKeyword: keyAEDesiredClass];
		[cachedDesc setDescriptor: kFormUniqueID forKeyword: keyAEKeyForm];
		[cachedDesc setDescriptor: [codecs pack: key] forKeyword: keyAEKeyData];
		[cachedDesc setDescriptor: [container packSelf: codecs] forKeyword: keyAEContainer];
	}
	return cachedDesc;
}

-(id)resolve:(id)object { 
	return [[container resolve: object] byID: key];
}

@end


@implementation AEMElementByOrdinalSpecifier

- (NSString *)description {
	switch ([key enumCodeValue]) {
		case kAEFirst:
			return [NSString stringWithFormat: @"[%@ first]", container];
		case kAEMiddle:
			return [NSString stringWithFormat: @"[%@ middle]", container];
		case kAELast:
			return [NSString stringWithFormat: @"[%@ last]", container];
		case kAEAny:
			return [NSString stringWithFormat: @"[%@ any]", container];
		default:
			return nil;
	}
}

// reserved methods

- (NSAppleEventDescriptor *)packSelf:(id)codecs {
	if (!cachedDesc) {
		cachedDesc = [kNullRecord coerceToDescriptorType: typeObjectSpecifier];
		[cachedDesc setDescriptor: [NSAppleEventDescriptor descriptorWithTypeCode: wantCode]
					   forKeyword: keyAEDesiredClass];
		[cachedDesc setDescriptor: kFormAbsolutePosition forKeyword: keyAEKeyForm];
		[cachedDesc setDescriptor: key forKeyword: keyAEKeyData];
		[cachedDesc setDescriptor: [container packSelf: codecs] forKeyword: keyAEContainer];
	}
	return cachedDesc;
}

-(id)resolve:(id)object { 
	id result;
	
	result = [container resolve: object];
	switch ([key enumCodeValue]) {
		case kAEFirst:
			return [result first];
		case kAEMiddle:
			return [result middle];
		case kAELast:
			return [result last];
		case kAEAny:
			return [result any];
		default:
			return nil;
	}
}

@end



@implementation AEMElementByRelativePositionSpecifier

- (NSString *)description {
	switch ([key enumCodeValue]) {
		case kAEPrevious:
			return [NSString stringWithFormat: @"[%@ previous: %@]", container,
					typeDescToString([NSAppleEventDescriptor descriptorWithTypeCode: wantCode])];
		case kAENext:
			return [NSString stringWithFormat: @"[%@ next: %@]", container,
					typeDescToString([NSAppleEventDescriptor descriptorWithTypeCode: wantCode])];
		default:
			return nil;
	}
}

// reserved methods

- (NSAppleEventDescriptor *)packSelf:(id)codecs {
	if (!cachedDesc) {
		cachedDesc = [kNullRecord coerceToDescriptorType: typeObjectSpecifier];
		[cachedDesc setDescriptor: [NSAppleEventDescriptor descriptorWithTypeCode: wantCode]
					   forKeyword: keyAEDesiredClass];
		[cachedDesc setDescriptor: kFormRelativePosition forKeyword: keyAEKeyForm];
		[cachedDesc setDescriptor: key forKeyword: keyAEKeyData];
		[cachedDesc setDescriptor: [container packSelf: codecs] forKeyword: keyAEContainer];
	}
	return cachedDesc;
}


-(id)resolve:(id)object { 
	id result;
	
	result = [container resolve: object];
	switch ([key enumCodeValue]) {
		case kAEPrevious:
			return [result previous: wantCode];
		case kAENext:
			return [result next: wantCode];
		default:
			return nil;
	}
}

@end



/**********************************************************************/
// Multiple elements

/*
 * Base class for all multiple element specifiers.
 */
@implementation AEMMultipleElementsSpecifierBase 

// ordinal selectors

- (AEMElementByOrdinalSpecifier *)first {
	return [[[AEMElementByOrdinalSpecifier alloc]
							   initWithContainer: self
											 key: kOrdinalFirst
										wantCode: wantCode] autorelease];
}

- (AEMElementByOrdinalSpecifier *)middle {
	return [[[AEMElementByOrdinalSpecifier alloc]
							   initWithContainer: self
											 key: kOrdinalMiddle
										wantCode: wantCode] autorelease];
}

- (AEMElementByOrdinalSpecifier *)last {
	return [[[AEMElementByOrdinalSpecifier alloc]
							   initWithContainer: self
											 key: kOrdinalLast
										wantCode: wantCode] autorelease];
}

- (AEMElementByOrdinalSpecifier *)any {
	return [[[AEMElementByOrdinalSpecifier alloc]
							   initWithContainer: self
											 key: kOrdinalAny
										wantCode: wantCode] autorelease];
}


// by-index, by-name, by-id selectors
 
- (AEMElementByIndexSpecifier *)at:(int)index {
	return [[[AEMElementByIndexSpecifier alloc]
							 initWithContainer: self
										   key: [NSNumber numberWithInt: index]
									  wantCode: wantCode] autorelease];
}

- (AEMElementByIndexSpecifier *)byIndex:(id)index { // index is normally NSNumber, but may occasionally be other types where target application accepts it (e.g. Finder also accepts typeAlias)
	return [[[AEMElementByIndexSpecifier alloc]
							 initWithContainer: self
										   key: index
									  wantCode: wantCode] autorelease];
}

- (AEMElementByNameSpecifier *)byName:(NSString *)name {
	return [[[AEMElementByNameSpecifier alloc]
							initWithContainer: self
										  key: name
									 wantCode: wantCode] autorelease];
}

- (AEMElementByIDSpecifier *)byID:(id)id_ {
	return [[[AEMElementByIDSpecifier alloc]
						  initWithContainer: self
										key: id_
								   wantCode: wantCode] autorelease];
}

// by-range selector

- (AEMElementsByRangeSpecifier *)at:(int)startIndex to:(int)stopIndex {
	return [[[AEMElementsByRangeSpecifier alloc]
							  initWithContainer: self
										  start: [[AEMCon elements: wantCode] at: startIndex]
										   stop: [[AEMCon elements: wantCode] at: stopIndex]
									   wantCode: wantCode] autorelease];
}

// takes two app- or con-based references, expanding any other values as necessary
- (AEMElementsByRangeSpecifier *)byRange:(id)startReference to:(id)stopReference { 
	return [[[AEMElementsByRangeSpecifier alloc]
							  initWithContainer: self
										  start: startReference
										   stop: stopReference
									   wantCode: wantCode] autorelease];
}


// by-test selector

- (AEMElementsByTestSpecifier *)byTest:(AEMTest *)testReference {
	return [[[AEMElementsByTestSpecifier alloc]
							 initWithContainer: self
										   key: testReference
									  wantCode: wantCode] autorelease];
}

@end


@implementation AEMElementsByRangeSpecifier

- (id)initWithContainer:(AEMSpecifier *)container_
				  start:(id)startReference_
				   stop:(id)stopReference_
			   wantCode:(OSType)wantCode_ {
	self = [super initWithContainer: [container_ trueSelf] key: nil wantCode: wantCode_];
	if (!self) return self;
	// expand non-reference values to con-based references
	// (note: doesn't bother to check if references are app- or con-based;
	//	will assume users are smart enough not to try passing its-based references)
	if ([startReference_ isKindOfClass: [NSString class]])
		startReference_ = [[AEMCon elements: wantCode_] byName: startReference_];
	else if (![startReference_ isKindOfClass: [AEMSpecifier class]])
		startReference_ = [[AEMCon elements: wantCode_] byIndex: startReference_];
	if (![stopReference_ isKindOfClass: [AEMSpecifier class]])
		stopReference_ = [[AEMCon elements: wantCode_] byName: stopReference_];
	else if (![stopReference_ isKindOfClass: [AEMSpecifier class]])
		stopReference_ = [[AEMCon elements: wantCode_] byIndex: stopReference_];
	[startReference_ retain];
	[stopReference_ retain];
	startReference = startReference_;
	stopReference = stopReference_;
	return self;
}

- (void)dealloc {
	[startReference release];
	[stopReference release];
	[super dealloc];
}

- (NSString *)description {
	return [NSString stringWithFormat: @"[%@ byRange: %@ to: %@]",
									   container,
									   startReference,
									   stopReference];
}

// reserved methods

- (NSAppleEventDescriptor *)packSelf:(id)codecs {
	NSAppleEventDescriptor *keyDesc;
	
	if (!cachedDesc) {
		keyDesc = [kNullRecord coerceToDescriptorType: typeRangeDescriptor];
		[keyDesc setDescriptor: [codecs pack: startReference] forKeyword: keyAERangeStart];
		[keyDesc setDescriptor: [codecs pack: stopReference] forKeyword: keyAERangeStop];
		cachedDesc = [kNullRecord coerceToDescriptorType: typeObjectSpecifier];
		[cachedDesc setDescriptor: [NSAppleEventDescriptor descriptorWithTypeCode: wantCode]
					   forKeyword: keyAEDesiredClass];
		[cachedDesc setDescriptor: kFormRange forKeyword: keyAEKeyForm];
		[cachedDesc setDescriptor: keyDesc forKeyword: keyAEKeyData];
		[cachedDesc setDescriptor: [container packSelf: codecs] forKeyword: keyAEContainer];
	}
	return cachedDesc;
}


-(id)resolve:(id)object {
	return [[container resolve: object] byRange: startReference to: stopReference];
}

@end


@implementation AEMElementsByTestSpecifier

- (id)initWithContainer:(AEMSpecifier *)container_ key:(AEMTest *)key_ wantCode:(OSType)wantCode_; {
	return [super initWithContainer: [container_ trueSelf] key: key_ wantCode: wantCode_];
}

- (NSString *)description {
	return [NSString stringWithFormat: @"[%@ byTest: %@]", container, key];
}

// reserved methods

- (NSAppleEventDescriptor *)packSelf:(id)codecs {
	if (!cachedDesc) {
		cachedDesc = [kNullRecord coerceToDescriptorType: typeObjectSpecifier];
		[cachedDesc setDescriptor: [NSAppleEventDescriptor descriptorWithTypeCode: wantCode]
					   forKeyword: keyAEDesiredClass];
		[cachedDesc setDescriptor: kFormTest forKeyword: keyAEKeyForm];
		[cachedDesc setDescriptor: [codecs pack: key] forKeyword: keyAEKeyData];
		[cachedDesc setDescriptor: [container packSelf: codecs] forKeyword: keyAEContainer];
	}
	return cachedDesc;
}


-(id)resolve:(id)object { 
	return [[container resolve: object] byTest: key];
}

@end


@implementation AEMAllElementsSpecifier

- (id)initWithContainer:(AEMSpecifier *)container_ wantCode:(OSType)wantCode_ {
	AEMUnkeyedElementsShim *shim;
	
	shim = [[AEMUnkeyedElementsShim alloc] initWithContainer: container_ wantCode: wantCode_];
	self = [super initWithContainer: shim key: kOrdinalAll wantCode: wantCode_];
	[shim release];
	return self;
}

- (NSString *)description {
	return [container description]; // forward to shim
}

// reserved methods

- (AEMSpecifier *)trueSelf {
	// Overrides default implementation to return the UnkeyedElements object
	// stored inside of this AllElements instance.
	return container; 
}

- (NSAppleEventDescriptor *)packSelf:(id)codecs {
	if (!cachedDesc) {
		cachedDesc = [kNullRecord coerceToDescriptorType: typeObjectSpecifier];
		[cachedDesc setDescriptor: [NSAppleEventDescriptor descriptorWithTypeCode: wantCode]
					   forKeyword: keyAEDesiredClass];
		[cachedDesc setDescriptor: kFormAbsolutePosition forKeyword: keyAEKeyForm];
		[cachedDesc setDescriptor: kOrdinalAll forKeyword: keyAEKeyData];
		[cachedDesc setDescriptor: [container packSelf: codecs] forKeyword: keyAEContainer];
	}
	return cachedDesc;
}

-(id)resolve:(id)object { 
	return [container resolve: object]; // forward to shim
}

@end


/**********************************************************************/
// Multiple element shim

@implementation AEMUnkeyedElementsShim

- (id)initWithContainer:(AEMSpecifier *)container_ wantCode:(OSType)wantCode_ {
	self = [super initWithContainer: container_ key: nil];
	if (!self) return self;
	wantCode = wantCode_;
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat: @"[%@ elements: '%@']", container, 
			typeDescToString([NSAppleEventDescriptor descriptorWithTypeCode: wantCode])];
}

- (NSAppleEventDescriptor *)packSelf:(id)codecs {
	return [container packSelf: codecs]; // forward to next container
}

-(id)resolve:(id)object { 
	return [[container resolve: object] elements: wantCode];
}

@end


/**********************************************************************/
// Reference roots

@implementation AEMReferenceRootBase

- (id)init {
	return nil;
}

// note: clients should avoid calling this initialiser directly; 
// use AEMApp, AEMCon, AEMIts macros instead.
- (id)initWithDescType:(DescType)descType {
	self = [super initWithContainer: nil key: nil wantCode: '????'];
	if (!self) return self;
	cachedDesc = [[NSAppleEventDescriptor alloc] initWithDescriptorType: descType
																  bytes: NULL
																 length: 0];
	return self;
}


- (AEMReferenceRootBase *)root {
	return self;
}

- (NSAppleEventDescriptor *)packSelf:(id)codecs {
	return cachedDesc;
}
@end


@implementation AEMApplicationRoot

// note: clients should avoid calling this initialiser directly; 
// use AEMApp, AEMCon, AEMIts macros instead.
+ (AEMApplicationRoot *)applicationRoot {
	static AEMApplicationRoot *root;
	
	if (!root) {
		if (!specifierModulesAreInitialized) initSpecifierModule();
		root = [[AEMApplicationRoot alloc] initWithDescType: typeNull];
	}
	return root;
}

- (NSString *)description {
	return @"AEMApp";
}

- (id)resolve:(id)object {
	return [object app];
}

@end


@implementation AEMCurrentContainerRoot

// note: clients should avoid calling this initialiser directly; 
// use AEMApp, AEMCon, AEMIts macros instead.
+ (AEMCurrentContainerRoot *)currentContainerRoot {
	static AEMCurrentContainerRoot *root;
	
	if (!root) {
		if (!specifierModulesAreInitialized) initSpecifierModule();
		root = [[AEMCurrentContainerRoot alloc] initWithDescType: typeCurrentContainer];
	}
	return root;
}

- (NSString *)description {
	return @"AEMCon";
}

- (id)resolve:(id)object {
	return [object con];
}

@end


@implementation AEMObjectBeingExaminedRoot

// note: clients should avoid calling this initialiser directly; 
// use AEMApp, AEMCon, AEMIts macros instead.
+ (AEMObjectBeingExaminedRoot *)objectBeingExaminedRoot {
	static AEMObjectBeingExaminedRoot *root;
	
	if (!root) {
		if (!specifierModulesAreInitialized) initSpecifierModule();
		root = [[AEMObjectBeingExaminedRoot alloc] initWithDescType: typeObjectBeingExamined];
	}
	return root;
}

- (NSString *)description {
	return @"AEMIts";
}

- (id)resolve:(id)object {
	return [object its];
}

@end

