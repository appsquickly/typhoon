//
//  TyphoonInjectionByObjectFromString.m
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 12.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonInjectionByObjectFromString.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonTypeDescriptor.h"
#import "TyphoonPrimitiveTypeConverter.h"
#import "TyphoonTypeConverterRegistry.h"
#import "TyphoonIntrospectiveNSObject.h"
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
    [self copyBaseProperiesTo:copied];
    return copied;
}

- (id)valueToInjectPropertyOnInstance:(id)instance withFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)args
{
    TyphoonTypeDescriptor *type;
    if (!instance) {
        type = [TyphoonTypeDescriptor descriptorWithClassOrProtocol:[NSString class]];
    }
    else {
        type = [instance typhoon_typeForPropertyWithName:self.propertyName];
    }

    id value = nil;

    if (type.isPrimitive) {
        TyphoonPrimitiveTypeConverter *converter = [[TyphoonTypeConverterRegistry shared] primitiveTypeConverter];
        value = [converter valueFromText:self.textValue withType:type];
    }
    else {
        value = [self convertText:self.textValue];
    }
    return value;
}

- (void)setArgumentWithType:(TyphoonTypeDescriptor *)type onInvocation:(NSInvocation *)invocation withFactory:(TyphoonComponentFactory *)factory
                       args:(TyphoonRuntimeArguments *)args
{
    if (type.isPrimitive) {
        TyphoonPrimitiveTypeConverter *converter = [[TyphoonTypeConverterRegistry shared] primitiveTypeConverter];
        [converter setPrimitiveArgumentFor:invocation index:self.parameterIndex + 2 textValue:_textValue requiredType:type];
    }
    else {
        id converted = [self convertText:self.textValue];
        [invocation typhoon_setArgumentObject:converted atIndex:self.parameterIndex + 2];
    }
}

- (id)convertText:(NSString *)text
{
    id result = text;
    NSString *typeString = [TyphoonTypeConverterRegistry typeFromTextValue:text];
    if (typeString) {
        id <TyphoonTypeConverter> converter = [[TyphoonTypeConverterRegistry shared] converterForType:typeString];
        if (converter) {
            result = [converter convert:text];
        }
    }
    return result;
}

@end
