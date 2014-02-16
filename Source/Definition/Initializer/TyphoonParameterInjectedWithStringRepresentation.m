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
#import "TyphoonParameterInjectedWithStringRepresentation.h"
#import "TyphoonInitializer.h"
#import "TyphoonTypeDescriptor.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonInitializer+InstanceBuilder.h"
#import "TyphoonDefinition.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonPrimitiveTypeConverter.h"
#import "TyphoonTypeConverterRegistry.h"


@implementation TyphoonParameterInjectedWithStringRepresentation


@synthesize textValue = _textValue;

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)initWithIndex:(NSUInteger)index value:(NSString *)value requiredTypeOrNil:(Class)requiredTypeOrNil
{
    self = [super init];
    if (self) {
        _index = index;
        _textValue = value;
        _requiredType = requiredTypeOrNil;
    }
    return self;
}

/* ====================================================================================================================================== */
#pragma mark - Interface Methods

- (TyphoonTypeDescriptor *)resolveType
{
    if (_requiredType) {
        return [TyphoonTypeDescriptor descriptorWithClassOrProtocol:_requiredType];
    }
    else {
        BOOL isClass = [_initializer isClassMethod];
        Class clazz = [_initializer.definition type];
        NSArray *typeCodes = [TyphoonIntrospectionUtils typeCodesForSelector:_initializer.selector ofClass:clazz isClassMethod:isClass];

        if ([[typeCodes objectAtIndex:_index] isEqualToString:@"@"]) {
            [NSException raise:NSInvalidArgumentException
                format:@"Unless the type is primitive (int, BOOL, etc), initializer injection requires the required class to be specified. "
                    "Eg: <argument parameterName=\"string\" value=\"http://dev.foobar.com/service/\" required-class=\"NSString\" />"];
        }
        return [TyphoonTypeDescriptor descriptorWithTypeCode:[typeCodes objectAtIndex:_index]];
    }
}


/* ====================================================================================================================================== */
#pragma mark - Overridden Methods

- (void)withFactory:(TyphoonComponentFactory *)factory setArgumentOnInvocation:(NSInvocation *)invocation
{
    TyphoonTypeDescriptor *requiredType = [self resolveType];
    if (requiredType.isPrimitive) {
        TyphoonPrimitiveTypeConverter *converter = [[TyphoonTypeConverterRegistry shared] primitiveTypeConverter];
        [converter setPrimitiveArgumentFor:invocation index:_index + 2 textValue:_textValue requiredType:requiredType];
    }
    else {
        id <TyphoonTypeConverter> converter = [[TyphoonTypeConverterRegistry shared] converterFor:requiredType];
        id converted = [converter convert:_textValue];
        [invocation setArgument:&converted atIndex:_index + 2];
    }
}


/* ====================================================================================================================================== */
#pragma mark - Utility Methods

- (id)copyWithZone:(NSZone *)zone
{
    return [[TyphoonParameterInjectedWithStringRepresentation alloc]
        initWithIndex:self.index value:self.textValue requiredTypeOrNil:self.requiredType];
}


@end
