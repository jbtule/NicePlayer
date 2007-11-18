//
//  codecs.h
//  aem
//
//  Copyright (C) 2007 HAS
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>
#import "specifier.h"
#import "types.h"

// TO DO: support for unit types

/**********************************************************************/


@interface AEMCodecs : NSObject

//- (void)addUnitTypes:(NSArray *)typeDefs; // TO DO

/**********************************************************************/
// main pack methods

/*
 * Converts a Cocoa object to an NSAppleEventDescriptor.
 * Calls -packUnknown: if object is of an unsupported class.
 */
- (NSAppleEventDescriptor *)pack:(id)anObject;

/*
 * Called by -pack: to process a Cocoa object of unsupported class.
 * Default implementation raises "CodecsError" NSException; subclasses
 * can override this method to provide alternative behaviours if desired.
 */
- (NSAppleEventDescriptor *)packUnknown:(id)anObject;


/**********************************************************************/
/*
 * The following methods will be called by -pack: as needed.
 * Subclasses can override the following methods to provide alternative 
 * behaviours if desired, although this is generally unnecessary.
 */
- (NSAppleEventDescriptor *)packArray:(NSArray *)anObject;
- (NSAppleEventDescriptor *)packDictionary:(NSDictionary *)anObject;


/**********************************************************************/
// main unpack methods; subclasses can override to process still-unconverted objects

/*
 * Converts an NSAppleEventDescriptor to a Cocoa object.
 * Calls -unpackUnknown: if descriptor is of an unsupported type.
 */
- (id)unpack:(NSAppleEventDescriptor *)desc;

/*
 * Called by -unpack: to process an NSAppleEventDescriptor of unsupported type.
 * Default implementation checks to see if the descriptor is a record-type structure
 * and unpacks it as an NSDictionary if it is, otherwise it returns the value as-is.
 * Subclasses can override this method to provide alternative behaviours if desired.
 */
- (id)unpackUnknown:(NSAppleEventDescriptor *)desc;


/**********************************************************************/
/*
 * The following methods will be called by -unpack: as needed.
 * Subclasses can override the following methods to provide alternative 
 * behaviours if desired, although this is generally unnecessary.
 */
- (id)unpackAEList:(NSAppleEventDescriptor *)desc;
- (id)unpackAERecord:(NSAppleEventDescriptor *)desc;
- (id)unpackAERecordKey:(AEKeyword)key;

- (id)unpackType:(NSAppleEventDescriptor *)desc;
- (id)unpackEnum:(NSAppleEventDescriptor *)desc;
- (id)unpackProperty:(NSAppleEventDescriptor *)desc;
- (id)unpackKeyword:(NSAppleEventDescriptor *)desc;

- (id)fullyUnpackObjectSpecifier:(NSAppleEventDescriptor *)desc;
- (id)unpackObjectSpecifier:(NSAppleEventDescriptor *)desc;
- (id)unpackInsertionLoc:(NSAppleEventDescriptor *)desc;

- (id)app;
- (id)con;
- (id)its;

- (id)unpackCompDescriptor:(NSAppleEventDescriptor *)desc;
- (id)unpackLogicalDescriptor:(NSAppleEventDescriptor *)desc;

@end
