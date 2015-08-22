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

/**
* Indicates if the type being described is a primitive.
*/
@property(nonatomic, readonly) BOOL isPrimitive;

/**
* The primitive type being described (if the type being described is a primitive).
*/
@property(nonatomic, readonly) TyphoonPrimitiveType primitiveType;

/**
* The type being described, or nil if the type is a primitive or protocol.
*/
@property(nonatomic, readonly) Class typeBeingDescribed;

/**
* The protocol being declared.
*/
@property (nonatomic, strong, readonly) NSString *declaredProtocol;

/**
* The protocol being described. Returns NSProtocolFromString(declaredProtocol). This may return nil if the protocol
* has been trimmed out by the compiler in the case that it has no direct references.
*/
@property(nonatomic, readonly) Protocol *protocol;

/**
* Indicates a primitive type is an array.
*/
@property(nonatomic, readonly) BOOL isArray;

/**
* Array length for primitive type.
*/
@property(nonatomic, readonly) int arrayLength;

/**
* Indicates a primitive type is a pointer.
*/
@property(nonatomic, readonly) BOOL isPointer;

/**
* Indicates a primitive type is a structure.
*/
@property(nonatomic, readonly) BOOL isStructure;

@property(nonatomic, strong, readonly) NSString *structureTypeName;

+ (TyphoonTypeDescriptor *)descriptorWithEncodedType:(const char *)encodedType;

+ (TyphoonTypeDescriptor *)descriptorWithTypeCode:(NSString *)typeCode;

- (id)initWithTypeCode:(NSString *)typeCode;

/**
* Returns the class or protocol. If the type descriptor is for a primitive, returns nil.
*/
- (id)classOrProtocol;

/** Returns encoded type as string */
- (const char *)encodedType;

@end
