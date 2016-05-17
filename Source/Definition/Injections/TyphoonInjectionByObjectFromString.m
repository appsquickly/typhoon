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

    id value = [self convertText:self.textValue toType:type withTypeConverterRegistry:factory.typeConverterRegistry];
    
    result(value);
}

- (id)convertText:(NSString *)text toType:(TyphoonTypeDescriptor *)type withTypeConverterRegistry:(TyphoonTypeConverterRegistry *)typeConverterRegistry
{
    // First, let's see if the text explicitly states the value type.
    NSString *typeStringFromText = [TyphoonTypeConversionUtils typeFromTextValue:text];
    if (typeStringFromText) {
        id <TyphoonTypeConverter> converter = [typeConverterRegistry converterForType:typeStringFromText];
        if (converter) {
            return [converter convert:text];
        }
    }
    
    // In case we know the type from the method argument, let's try to use it.
    if (type) {
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
            if (converter) {
                return [converter convert:text];
            }
        }
    }
    
    // Fallback to injecting string.
    return text;
}

- (NSUInteger)customHash
{
    return [_textValue hash];
}

@end
