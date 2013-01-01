////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import <Foundation/Foundation.h>

typedef enum
{
    SpringPrimitiveTypeUnknown,
    SpringPrimitiveTypeChar,
    SpringPrimitiveTypeInt,
    SpringPrimitiveTypeShort,
    SpringPrimitiveTypeLong,
    SpringPrimitiveTypeLongLong,
    SpringPrimitiveTypeUnsignedChar,
    SpringPrimitiveTypeUnsignedInt,
    SpringPrimitiveTypeUnsignedShort,
    SpringPrimitiveTypeUnsignedLong,
    SpringPrimitiveTypeUnsignedLongLong,
    SpringPrimitiveTypeFloat,
    SpringPrimitiveTypeDouble,
    SpringPrimitiveTypeBoolean,
    SpringPrimitiveTypeVoid,
    SpringPrimitiveTypeString,
    SpringPrimitiveTypeClass,
    SpringPrimitiveTypeSelector,
    SpringPrimitiveTypeBitField,
} SpringPrimitiveType;


@interface SpringTypeDescriptor : NSObject

@property(nonatomic, readonly) BOOL isPrimitive;
@property(nonatomic, readonly) SpringPrimitiveType primitiveType;
@property(nonatomic, readonly) Class metaClass;
@property(nonatomic, readonly) Protocol* protocol;
@property(nonatomic, readonly) BOOL isArray;
@property(nonatomic, readonly) int arrayLength;
@property(nonatomic, readonly) BOOL isPointer;
@property(nonatomic, readonly) BOOL isStructure;
@property(nonatomic, strong, readonly) NSString* structureTypeName;

+ (SpringTypeDescriptor*)descriptorWithTypeCode:(NSString*)typeCode;

+ (SpringTypeDescriptor*)descriptorWithClassOrProtocol:(id)classOrProtocol;

- (id)initWithTypeCode:(NSString*)typeCode;

/**
* Returns the class or protocol. If the type descriptor is for a primitive, returns nil.
*/
- (id)classOrProtocol;


@end