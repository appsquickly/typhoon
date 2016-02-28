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


#import "TyphoonInjectionByObjectFromString.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonTypeDescriptor.h"
#import "TyphoonPrimitiveTypeConverter.h"
#import "TyphoonTypeConverterRegistry.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonDefinition.h"
#import "NSInvocation+TCFUnwrapValues.h"

@implementation TyphoonInjectionByObjectFromString

- (instancetype)initWithString:(NSString *)string
{
    self = [super init];
    if (self) {
        _textValue = string;
    }
    return self;
}

#pragma mark - Overrides

- (id)copyWithZone:(NSZone *)zone
{
    TyphoonInjectionByObjectFromString
        *copied = [[TyphoonInjectionByObjectFromString alloc] initWithString:self.textValue];
    [self copyBasePropertiesTo:copied];
    return copied;
}

- (BOOL)isEqualToCustom:(TyphoonInjectionByObjectFromString *)injection
{
    return  [self.textValue isEqualToString:injection.textValue];
}

- (void)valueToInjectWithContext:(TyphoonInjectionContext *)context completion:(TyphoonInjectionValueBlock)result
{
    TyphoonTypeDescriptor *type = context.destinationType;
    TyphoonComponentFactory *factory = context.factory;

    id value = nil;
    
    if (type) {
        value = [self convertText:self.textValue toType:type withTypeConverterRegistry:factory.typeConverterRegistry];
    }
    else {
        value = [self convertText:self.textValue withTypeConverterRegistry:factory.typeConverterRegistry];
    }
    
    result(value);
}

- (id)convertText:(NSString *)text toType:(TyphoonTypeDescriptor *)type withTypeConverterRegistry:(TyphoonTypeConverterRegistry *)typeConverterRegistry
{
    if (type.isPrimitive) {
        TyphoonPrimitiveTypeConverter *converter = [typeConverterRegistry primitiveTypeConverter];
        return [converter valueFromText:text withType:type];
    }
    else {
        NSString *typeString;
        
        if (type.typeBeingDescribed) {
            typeString = NSStringFromClass(type.typeBeingDescribed);
        }
        else {
            typeString = [NSString stringWithFormat:@"<%@>", type.declaredProtocol];
        }

        id<TyphoonTypeConverter> converter = [typeConverterRegistry converterForType:typeString];
        return [converter convert:text];
    }
}

- (id)convertText:(NSString *)text withTypeConverterRegistry:(TyphoonTypeConverterRegistry *)typeConverterRegistry
{
    id result = text;
    NSString *typeString = [TyphoonTypeConversionUtils typeFromTextValue:text];
    if (typeString) {
        id <TyphoonTypeConverter> converter = [typeConverterRegistry converterForType:typeString];
        if (converter) {
            result = [converter convert:text];
        }
    }
    return result;
}

- (NSUInteger)customHash
{
    return [_textValue hash];
}

@end
