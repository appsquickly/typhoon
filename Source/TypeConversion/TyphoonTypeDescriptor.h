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

typedef enum
{
    TyphoonPrimitiveTypeUnknown,
    TyphoonPrimitiveTypeChar,
    TyphoonPrimitiveTypeInt,
    TyphoonPrimitiveTypeShort,
    TyphoonPrimitiveTypeLong,
    TyphoonPrimitiveTypeLongLong,
    TyphoonPrimitiveTypeUnsignedChar,
    TyphoonPrimitiveTypeUnsignedInt,
    TyphoonPrimitiveTypeUnsignedShort,
    TyphoonPrimitiveTypeUnsignedLong,
    TyphoonPrimitiveTypeUnsignedLongLong,
    TyphoonPrimitiveTypeFloat,
    TyphoonPrimitiveTypeDouble,
    TyphoonPrimitiveTypeBoolean,
    TyphoonPrimitiveTypeVoid,
    TyphoonPrimitiveTypeString,
    TyphoonPrimitiveTypeClass,
    TyphoonPrimitiveTypeSelector,
    TyphoonPrimitiveTypeBitField,
} TyphoonPrimitiveType;


@interface TyphoonTypeDescriptor : NSObject

@property(nonatomic, readonly) BOOL isPrimitive;
@property(nonatomic, readonly) TyphoonPrimitiveType primitiveType;
@property(nonatomic, readonly) Class metaClass;
@property(nonatomic, readonly) Protocol* protocol;
@property(nonatomic, readonly) BOOL isArray;
@property(nonatomic, readonly) int arrayLength;
@property(nonatomic, readonly) BOOL isPointer;
@property(nonatomic, readonly) BOOL isStructure;
@property(nonatomic, strong, readonly) NSString* structureTypeName;

+ (TyphoonTypeDescriptor*)descriptorWithTypeCode:(NSString*)typeCode;

+ (TyphoonTypeDescriptor*)descriptorWithClassOrProtocol:(id)classOrProtocol;

- (id)initWithTypeCode:(NSString*)typeCode;

/**
* Returns the class or protocol. If the type descriptor is for a primitive, returns nil.
*/
- (id)classOrProtocol;


@end