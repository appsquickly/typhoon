////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 - 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import <Foundation/Foundation.h>

@protocol TyphonTypeConverter;
@class TyphoonTypeDescriptor;
@class TyphoonPrimitiveTypeConverter;


/**
* Registry of type converters, with special treatment for primitives.
*/
@interface TyphoonTypeConverterRegistry : NSObject
{
    TyphoonPrimitiveTypeConverter* _primitiveTypeConverter;
    NSMutableDictionary* _typeConverters;
}

/**
* Returns the shard/default registry instance used by the container.
*/
+ (TyphoonTypeConverterRegistry*)shared;

/**
* Returns the type converter for the given type either a Class object or @protocol(SomeType).
*/
- (id <TyphonTypeConverter>)converterFor:(TyphoonTypeDescriptor*)typeDescriptor;

/**
* Returns the type converter for primitives - BOOLS, ints, floats, etc.
*/
- (TyphoonPrimitiveTypeConverter*)primitiveTypeConverter;

/**
* Registers a converter for the given type (either a Class object or @protocol. If a converter exists for the type,
* raises an exception.
*/
- (void)register:(id <TyphonTypeConverter>)converter forClassOrProtocol:(id)classOrProtocol;

@end