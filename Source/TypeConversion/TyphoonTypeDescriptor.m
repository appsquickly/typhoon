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

@implementation NSDictionary (TyphoonPrimitiveType)

+ (NSDictionary *)dictionaryWithTyphoonPrimitiveTypesAsStrings
{
    static dispatch_once_t onceToken;
    static NSDictionary *_typhoonPrimitiveTypesAsStrings;

    dispatch_once(&onceToken, ^{
        _typhoonPrimitiveTypesAsStrings = @{
            @"c" : @(TyphoonPrimitiveTypeChar),
            @"i" : @(TyphoonPrimitiveTypeInt),
            @"s" : @(TyphoonPrimitiveTypeShort),
            @"l" : @(TyphoonPrimitiveTypeLong),
            @"q" : @(TyphoonPrimitiveTypeLongLong),
            @"C" : @(TyphoonPrimitiveTypeUnsignedChar),
            @"I" : @(TyphoonPrimitiveTypeUnsignedInt),
            @"S" : @(TyphoonPrimitiveTypeUnsignedShort),
            @"L" : @(TyphoonPrimitiveTypeUnsignedLong),
            @"Q" : @(TyphoonPrimitiveTypeUnsignedLongLong),
            @"f" : @(TyphoonPrimitiveTypeFloat),
            @"d" : @(TyphoonPrimitiveTypeDouble),
            @"B" : @(TyphoonPrimitiveTypeBoolean),
            @"v" : @(TyphoonPrimitiveTypeVoid),
            @"*" : @(TyphoonPrimitiveTypeString),
            @"#" : @(TyphoonPrimitiveTypeClass),
            @":" : @(TyphoonPrimitiveTypeSelector),
            @"?" : @(TyphoonPrimitiveTypeUnknown)
        };
    });
    return _typhoonPrimitiveTypesAsStrings;
}

@end

@implementation TyphoonTypeDescriptor {
    NSString *_typeCode;
}

/* ====================================================================================================================================== */
#pragma mark - Class Methods

+ (TyphoonTypeDescriptor *)descriptorWithEncodedType:(const char *)encodedType
{
    return [[[self class] alloc] initWithTypeCode:[NSString stringWithCString:encodedType encoding:NSUTF8StringEncoding]];
}

+ (TyphoonTypeDescriptor *)descriptorWithTypeCode:(NSString *)typeCode
{
    return [[[self class] alloc] initWithTypeCode:typeCode];
}

+ (TyphoonTypeDescriptor *)descriptorWithClassOrProtocol:(id)classOrProtocol
{
    if (class_isMetaClass(object_getClass(classOrProtocol))) {
        return [self descriptorWithTypeCode:[NSString stringWithFormat:@"T@%@", NSStringFromClass(classOrProtocol)]];
    }
    return [self descriptorWithTypeCode:[NSString stringWithFormat:@"T@<%@>", NSStringFromProtocol(classOrProtocol)]];
}

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)initWithTypeCode:(NSString *)typeCode
{
    self = [super init];
    if (self) {
        if ([typeCode hasPrefix:@"T@"]) {
            _isPrimitive = NO;
            typeCode = [typeCode stringByReplacingOccurrencesOfString:@"T@" withString:@""];
            typeCode = [typeCode stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            if ([typeCode hasPrefix:@"<"] && [typeCode hasSuffix:@">"]) {
                typeCode = [typeCode stringByReplacingOccurrencesOfString:@"<" withString:@""];
                typeCode = [typeCode stringByReplacingOccurrencesOfString:@">" withString:@""];
                _protocol = NSProtocolFromString(typeCode);
            }
            else if ([typeCode hasSuffix:@">"]) {
                NSArray *components = [typeCode componentsSeparatedByString:@"<"];
                NSString *protocol = [components[1] stringByReplacingOccurrencesOfString:@">" withString:@""];
                NSString *class = components[0];

                _protocol = NSProtocolFromString(protocol);
                _typeBeingDescribed = NSClassFromString(class);
            }
            else {
                _typeBeingDescribed = NSClassFromString(typeCode);
            }
        }
        else {
            _isPrimitive = YES;
            typeCode = [typeCode stringByReplacingOccurrencesOfString:@"T" withString:@""];
            [self parsePrimitiveType:typeCode];
        }
        _typeCode = typeCode;
    }
    return self;
}

/* ====================================================================================================================================== */
#pragma mark - Interface Methods

- (id)classOrProtocol
{
    if (_typeBeingDescribed) {
        return _typeBeingDescribed;
    }
    else {
        return _protocol;
    }
}

- (const char *)encodedType
{
    return [_typeCode cStringUsingEncoding:NSUTF8StringEncoding];
}

/* ====================================================================================================================================== */
#pragma mark - Utility Methods

- (NSString *)description
{
    if (_isPrimitive) {
        return [NSString stringWithFormat:@"Type descriptor for primitive: %i", _primitiveType];
    }
    else {
        Protocol *protocol = [self protocol];
        if (protocol && [self typeBeingDescribed]) {
            return [NSString stringWithFormat:@"Type descriptor: %@<%@>", NSStringFromClass([self typeBeingDescribed]),
                                              NSStringFromProtocol(protocol)];
        }
        else if (protocol) {
            return [NSString stringWithFormat:@"Type descriptor: id<%@>", NSStringFromProtocol(protocol)];
        }
        else {
            return [NSString stringWithFormat:@"Type descriptor: %@", [self classOrProtocol]];
        }

    }
}

/* ====================================================================================================================================== */
#pragma mark - Private Methods

- (void)parsePrimitiveType:(NSString *)typeCode
{
    typeCode = [self extractArrayInformation:typeCode];
    typeCode = [self extractPointerInformation:typeCode];
    typeCode = [self extractStructureInformation:typeCode];
    typeCode = [self extractObjectInformation:typeCode];
    _primitiveType = [self typeFromTypeCode:typeCode];
}

- (NSString *)extractArrayInformation:(NSString *)typeCode
{
    if ([typeCode hasPrefix:@"["] && [typeCode hasSuffix:@"]"]) {
        _isArray = YES;
        typeCode =
            [[typeCode stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""];
        NSScanner *scanner = [[NSScanner alloc] initWithString:typeCode];
        [scanner scanInt:&_arrayLength];
        typeCode = [typeCode stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    }
    return typeCode;
}

- (NSString *)extractPointerInformation:(NSString *)typeCode
{
    if ([typeCode hasPrefix:@"^"]) {
        _isPointer = YES;
        typeCode = [typeCode stringByReplacingOccurrencesOfString:@"^" withString:@""];
    }
    return typeCode;
}

- (NSString *)extractStructureInformation:(NSString *)typeCode
{
    if ([typeCode hasPrefix:@"{"] && [typeCode hasSuffix:@"}"]) {
        _isStructure = YES;
        typeCode =
            [[typeCode stringByReplacingOccurrencesOfString:@"{" withString:@""] stringByReplacingOccurrencesOfString:@"}" withString:@""];
        _structureTypeName = [typeCode copy];
    }
    return typeCode;
}

- (NSString *)extractObjectInformation:(NSString *)typeCode
{
    if ([typeCode isEqualToString:@"@"]) {
        _isPrimitive = NO;
        return @"?";
    }
    return typeCode;
}

- (TyphoonPrimitiveType)typeFromTypeCode:(NSString *)typeCode
{
    return (TyphoonPrimitiveType) [[[NSDictionary dictionaryWithTyphoonPrimitiveTypesAsStrings] objectForKey:typeCode] intValue];
}

@end
