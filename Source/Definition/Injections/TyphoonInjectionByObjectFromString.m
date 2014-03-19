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

@implementation TyphoonInjectionByObjectFromString

- (instancetype)initWithString:(NSString *)string
{
    return [self initWithString:string objectClass:nil];
}

- (instancetype)initWithString:(NSString *)string objectClass:(Class)requiredClass
{
    self = [super init];
    if (self) {
        _textValue = string;
        _requiredClass = requiredClass;
    }
    return self;
}

#pragma mark - Overrides

- (id)copyWithZone:(NSZone *)zone
{
    TyphoonInjectionByObjectFromString
        *copied = [[TyphoonInjectionByObjectFromString alloc] initWithString:self.textValue objectClass:self.requiredClass];
    [self copyBaseProperiesTo:copied];
    return copied;
}

- (id)valueToInjectPropertyOnInstance:(id)instance withFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)args
{
    TyphoonTypeDescriptor *type;
    if (!instance) {
        NSAssert(self.requiredClass, @"requiredClass can't be nil when you trying to get value without instance");
        type = [TyphoonTypeDescriptor descriptorWithClassOrProtocol:self.requiredClass];
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
        id <TyphoonTypeConverter> converter = [[TyphoonTypeConverterRegistry shared] converterFor:type];
        value = [converter convert:self.textValue];
    }
    return value;
}

- (void)setArgumentWithType:(TyphoonTypeDescriptor *)type onInvocation:(NSInvocation *)invocation withFactory:(TyphoonComponentFactory *)factory
                       args:(TyphoonRuntimeArguments *)args
{
    if (self.requiredClass) {
        type = [TyphoonTypeDescriptor descriptorWithClassOrProtocol:self.requiredClass];
    } else if (!type.isPrimitive){
        [NSException raise:NSInvalidArgumentException
                    format:@"Unless the type is primitive (int, BOOL, etc), initializer injection requires the required class to be specified. "
         "Eg: <argument parameterName=\"string\" value=\"http://dev.foobar.com/service/\" required-class=\"NSString\" />"];
    }
    
    if (type.isPrimitive) {
        TyphoonPrimitiveTypeConverter *converter = [[TyphoonTypeConverterRegistry shared] primitiveTypeConverter];
        [converter setPrimitiveArgumentFor:invocation index:self.parameterIndex + 2 textValue:_textValue requiredType:type];
    }
    else {
        id <TyphoonTypeConverter> converter = [[TyphoonTypeConverterRegistry shared] converterFor:type];
        id converted = [converter convert:self.textValue];
        [invocation setArgument:&converted atIndex:self.parameterIndex + 2];
    }
}



@end
