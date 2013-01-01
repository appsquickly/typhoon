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




#import <objc/runtime.h>
#import "SpringTypeDescriptor.h"

@implementation NSDictionary (DeucePrimitiveType)

+ (NSDictionary*)dictionaryWithDeucePrimitiveTypesAsStrings
{
    static dispatch_once_t onceToken;
    static NSDictionary* _deucePrimitiveTypesAsStrings;

    dispatch_once(&onceToken, ^
{
    _deucePrimitiveTypesAsStrings =
            [[NSDictionary alloc] initWithObjectsAndKeys:@(SpringPrimitiveTypeChar), @"c", @(SpringPrimitiveTypeInt), @"i",
                                                         @(SpringPrimitiveTypeShort), @"s", @(SpringPrimitiveTypeLong), @"l",
                                                         @(SpringPrimitiveTypeLongLong), @"q", @(SpringPrimitiveTypeUnsignedChar), @"C",
                                                         @(SpringPrimitiveTypeUnsignedInt), @"I", @(SpringPrimitiveTypeUnsignedShort), @"S",
                                                         @(SpringPrimitiveTypeUnsignedLong), @"L",
                                                         @(SpringPrimitiveTypeUnsignedLongLong), @"Q", @(SpringPrimitiveTypeFloat), @"f",
                                                         @(SpringPrimitiveTypeDouble), @"d", @(SpringPrimitiveTypeBoolean), @"B",
                                                         @(SpringPrimitiveTypeVoid), @"v", @(SpringPrimitiveTypeString), @"*",
                                                         @(SpringPrimitiveTypeClass), @"#", @(SpringPrimitiveTypeSelector), @":",
                                                         @(SpringPrimitiveTypeUnknown), @"?", nil];
});
    return _deucePrimitiveTypesAsStrings;
}

@end

@implementation SpringTypeDescriptor

/* =========================================================== Class Methods ============================================================ */
+ (SpringTypeDescriptor*)descriptorWithTypeCode:(NSString*)typeCode
{
    return [[[self class] alloc] initWithTypeCode:typeCode];
}

+ (SpringTypeDescriptor*)descriptorWithClassOrProtocol:(id)classOrProtocol;
{
    if (class_isMetaClass(object_getClass(classOrProtocol)))
    {
        return [self descriptorWithTypeCode:[NSString stringWithFormat:@"T@%@", NSStringFromClass(classOrProtocol)]];
    }
    return [self descriptorWithTypeCode:[NSString stringWithFormat:@"T@<%@>", NSStringFromProtocol(classOrProtocol)]];
}

/* ============================================================ Initializers ============================================================ */
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
                _metaClass = NSClassFromString(typeCode);
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

/* ========================================================== Interface Methods ========================================================= */
- (id)classOrProtocol
{
    if (_metaClass)
    {
        return _metaClass;
    }
    else
    {
        return _protocol;
    }
}

/* ============================================================ Utility Methods ========================================================= */
- (NSString*)description
{
    if (_isPrimitive)
    {
        return [NSString stringWithFormat:@"Type descriptor for primitive: %i", _primitiveType];
    }
    else
    {
        return [NSString stringWithFormat:@"Type descriptor: %@", [self classOrProtocol]];
    }
}

/* ============================================================ Private Methods ========================================================= */
- (void)parsePrimitiveType:(NSString*)typeCode
{
    LogDebug(@"Parsing typeCode: %@", typeCode);
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

- (SpringPrimitiveType)typeFromTypeCode:(NSString*)typeCode
{
    return (SpringPrimitiveType) [[[NSDictionary dictionaryWithDeucePrimitiveTypesAsStrings] objectForKey:typeCode] intValue];
}

@end