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

- (void)valueToInjectWithContext:(TyphoonInjectionContext *)context completion:(TyphoonInjectionValueBlock)result
{
    TyphoonTypeDescriptor *type = context.destinationType;

    id value = nil;
    
    if (type.isPrimitive) {
        TyphoonPrimitiveTypeConverter *converter = [[TyphoonTypeConverterRegistry shared] primitiveTypeConverter];
        value = [converter valueFromText:self.textValue withType:type];
    }
    else {
        value = [self convertText:self.textValue];
    }
    
    result(value);
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
