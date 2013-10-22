////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import <objc/runtime.h>
#import "TyphoonTypeDescriptor.h"

@implementation NSDictionary (DeucePrimitiveType)

+ (NSDictionary*)dictionaryWithDeucePrimitiveTypesAsStrings
{
    static dispatch_once_t onceToken;
    static NSDictionary* _deucePrimitiveTypesAsStrings;

    dispatch_once(&onceToken, ^
{
    _deucePrimitiveTypesAsStrings =
            [[NSDictionary alloc] initWithObjectsAndKeys:@(TyphoonPrimitiveTypeChar), @"c", @(TyphoonPrimitiveTypeInt), @"i",
                                                         @(TyphoonPrimitiveTypeShort), @"s", @(TyphoonPrimitiveTypeLong), @"l",
                                                         @(TyphoonPrimitiveTypeLongLong), @"q", @(TyphoonPrimitiveTypeUnsignedChar), @"C",
                                                         @(TyphoonPrimitiveTypeUnsignedInt), @"I", @(TyphoonPrimitiveTypeUnsignedShort), @"S",
                                                         @(TyphoonPrimitiveTypeUnsignedLong), @"L",
                                                         @(TyphoonPrimitiveTypeUnsignedLongLong), @"Q", @(TyphoonPrimitiveTypeFloat), @"f",
                                                         @(TyphoonPrimitiveTypeDouble), @"d", @(TyphoonPrimitiveTypeBoolean), @"B",
                                                         @(TyphoonPrimitiveTypeVoid), @"v", @(TyphoonPrimitiveTypeString), @"*",
                                                         @(TyphoonPrimitiveTypeClass), @"#", @(TyphoonPrimitiveTypeSelector), @":",
                                                         @(TyphoonPrimitiveTypeUnknown), @"?", nil];
});
    return _deucePrimitiveTypesAsStrings;
}

@end

@implementation TyphoonTypeDescriptor

/* ====================================================================================================================================== */
#pragma mark - Class Methods

+ (TyphoonTypeDescriptor*)descriptorWithTypeCode:(NSString*)typeCode
{
    return [[[self class] alloc] initWithTypeCode:typeCode];
}

+ (TyphoonTypeDescriptor*)descriptorWithClassOrProtocol:(id)classOrProtocol;
{
    if (class_isMetaClass(object_getClass(classOrProtocol)))
    {
        return [self descriptorWithTypeCode:[NSString stringWithFormat:@"T@%@", NSStringFromClass(classOrProtocol)]];
    }
    return [self descriptorWithTypeCode:[NSString stringWithFormat:@"T@<%@>", NSStringFromProtocol(classOrProtocol)]];
}

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)initWithTypeCode:(NSString*)typeCode
{
    self = [super init];
    if (self)
    {
        if ([typeCode hasPrefix:@"T@"])
        {
            _isPrimitive = NO;
            typeCode = [typeCode stringByReplacingOccurrencesOfString:@"T@" withString:@""];
            typeCode = [typeCode stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            if ([typeCode hasPrefix:@"<"] && [typeCode hasSuffix:@">"])
            {
                typeCode = [typeCode stringByReplacingOccurrencesOfString:@"<" withString:@""];
                typeCode = [typeCode stringByReplacingOccurrencesOfString:@">" withString:@""];
                _protocol = NSProtocolFromString(typeCode);
            }
            else
            {
                _typeBeingDescribed = NSClassFromString(typeCode);
            }
        }
        else
        {
            _isPrimitive = YES;
            typeCode = [typeCode stringByReplacingOccurrencesOfString:@"T" withString:@""];
            [self parsePrimitiveType:typeCode];
        }
    }
    return self;
}

/* ====================================================================================================================================== */
#pragma mark - Interface Methods

- (id)classOrProtocol
{
    if (_typeBeingDescribed)
    {
        return _typeBeingDescribed;
    }
    else
    {
        return _protocol;
    }
}

/* ====================================================================================================================================== */
#pragma mark - Utility Methods

- (NSString*)description
{
    if (_isPrimitive)
    {
        return [NSString stringWithFormat:@"Type descriptor for primitive: %i", _primitiveType];
    }
    else
    {
        Protocol* protocol = [self protocol];
        if (protocol)
        {
            return [NSString stringWithFormat:@"Type descriptor: id<%@>", NSStringFromProtocol(protocol)];
        }
        else 
        {
            return [NSString stringWithFormat:@"Type descriptor: %@", [self classOrProtocol]];
        }
        
    }
}

/* ====================================================================================================================================== */
#pragma mark - Private Methods

- (void)parsePrimitiveType:(NSString*)typeCode
{
    typeCode = [self extractArrayInformation:typeCode];
    typeCode = [self extractPointerInformation:typeCode];
    typeCode = [self extractStructureInformation:typeCode];
    _primitiveType = [self typeFromTypeCode:typeCode];
}

- (NSString*)extractArrayInformation:(NSString*)typeCode
{
    if ([typeCode hasPrefix:@"["] && [typeCode hasSuffix:@"]"])
    {
        _isArray = YES;
        typeCode = [[typeCode stringByReplacingOccurrencesOfString:@"[" withString:@""]
                stringByReplacingOccurrencesOfString:@"]" withString:@""];
        NSScanner* scanner = [[NSScanner alloc] initWithString:typeCode];
        [scanner scanInt:&_arrayLength];
        typeCode = [typeCode stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    }
    return typeCode;
}

- (NSString*)extractPointerInformation:(NSString*)typeCode
{
    if ([typeCode hasPrefix:@"^"])
    {
        _isPointer = YES;
        typeCode = [typeCode stringByReplacingOccurrencesOfString:@"^" withString:@""];
    }
    return typeCode;
}

- (NSString*)extractStructureInformation:(NSString*)typeCode
{
    if ([typeCode hasPrefix:@"{"] && [typeCode hasSuffix:@"}"])
    {
        _isStructure = YES;
        typeCode = [[typeCode stringByReplacingOccurrencesOfString:@"{" withString:@""]
                stringByReplacingOccurrencesOfString:@"}" withString:@""];
        _structureTypeName = [typeCode copy];
    }
    return typeCode;
}

- (TyphoonPrimitiveType)typeFromTypeCode:(NSString*)typeCode
{
    return (TyphoonPrimitiveType) [[[NSDictionary dictionaryWithDeucePrimitiveTypesAsStrings] objectForKey:typeCode] intValue];
}

@end
