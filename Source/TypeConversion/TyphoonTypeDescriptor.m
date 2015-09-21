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



#import <objc/runtime.h>
#import "TyphoonTypeDescriptor.h"
#import "TyphoonIntrospectionUtils.h"

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


@implementation TyphoonTypeDescriptor
{
    NSString *_typeCode;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Class Methods
//-------------------------------------------------------------------------------------------

+ (TyphoonTypeDescriptor *)descriptorWithEncodedType:(const char *)encodedType
{
    return [[self alloc] initWithTypeCode:[NSString stringWithCString:encodedType encoding:NSUTF8StringEncoding]];
}

+ (TyphoonTypeDescriptor *)descriptorWithTypeCode:(NSString *)typeCode
{
    return [[self alloc] initWithTypeCode:typeCode];
}



//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

- (id)initWithTypeCode:(NSString *)typeCode
{
    self = [super init];
    if (self) {
        if ([typeCode hasPrefix:@"T@"]) {
            _isPrimitive = NO;
            
            NSRange typeNameRange = NSMakeRange(2, typeCode.length - 2);
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wassign-enum"
            NSRange quoteRange = [typeCode rangeOfString:@"\"" options:0 range:typeNameRange locale:nil];
            if (quoteRange.length > 0) {
                typeNameRange.location = quoteRange.location + 1;
                typeNameRange.length = typeCode.length - typeNameRange.location;
                
                NSRange range = [typeCode rangeOfString:@"\"" options:0 range:typeNameRange locale:nil];
                typeNameRange.length = range.location - typeNameRange.location;
            }
            
            NSRange protocolRange = [typeCode rangeOfString:@"<" options:0 range:typeNameRange locale:nil];
            if (protocolRange.length > 0) {
                NSRange range = [typeCode rangeOfString:@">" options:0 range:typeNameRange locale:nil];
                
                typeNameRange.length = protocolRange.location - typeNameRange.location;
                
                protocolRange.location += 1;
                protocolRange.length = range.location - protocolRange.location;
                
                _declaredProtocol = [typeCode substringWithRange:protocolRange];
            }
#pragma clang diagnostic pop
            
            NSString *typeName = [typeCode substringWithRange:typeNameRange];
            _typeBeingDescribed = TyphoonClassFromString(typeName);
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

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (id)classOrProtocol
{
    if (_typeBeingDescribed) {
        return _typeBeingDescribed;
    }
    else {
        return self.protocol;
    }
}

- (const char *)encodedType
{
    return [_typeCode cStringUsingEncoding:NSUTF8StringEncoding];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Overridden Methods
//-------------------------------------------------------------------------------------------

- (Protocol *)protocol
{
    return NSProtocolFromString(_declaredProtocol);
}

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

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//-------------------------------------------------------------------------------------------

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
        typeCode = [[typeCode stringByReplacingOccurrencesOfString:@"[" withString:@""]
            stringByReplacingOccurrencesOfString:@"]" withString:@""];
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
        typeCode = [[typeCode stringByReplacingOccurrencesOfString:@"{" withString:@""]
            stringByReplacingOccurrencesOfString:@"}" withString:@""];
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
    return (TyphoonPrimitiveType)[[NSDictionary dictionaryWithTyphoonPrimitiveTypesAsStrings][typeCode]
        intValue];
}

@end
