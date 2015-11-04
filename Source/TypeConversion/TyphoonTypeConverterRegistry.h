////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import <Foundation/Foundation.h>

@protocol TyphoonTypeConverter;
@class TyphoonPrimitiveTypeConverter;

/**
* Registry of type converters, with special treatment for primitives.
*/
@interface TyphoonTypeConverterRegistry : NSObject

/**
 * Returns the type converter for the given type string. Usually type is class of object you want to convert.
 * For example for NSURL type, you should use next syntax in properties file.
 * @code
 * key=NSURL(http://example.com)
 * @endcode
 */
- (id <TyphoonTypeConverter>)converterForType:(NSString *)type;

/**
* Returns the type converter for primitives - BOOLS, ints, floats, etc.
*/
- (TyphoonPrimitiveTypeConverter *)primitiveTypeConverter;

/**
 * Adds a converter to the registry. Raises an exception if the a converter for the same type 
 * already exists.
 */
- (void)registerTypeConverter:(id <TyphoonTypeConverter>)converter;

/**
 * Unregister a type converter.
 */
- (void)unregisterTypeConverter:(id <TyphoonTypeConverter>)converter;

@end
