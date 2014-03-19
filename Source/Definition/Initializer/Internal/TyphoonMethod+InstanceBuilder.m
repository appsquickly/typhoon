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



#import "TyphoonLinkerCategoryBugFix.h"
#import "TyphoonMethod+InstanceBuilder.h"
#import "TyphoonDefinition.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonInjectionByObjectFromString.h"
#import "TyphoonInjectionByRuntimeArgument.h"
#import "TyphoonTypeDescriptor.h"

TYPHOON_LINK_CATEGORY(TyphoonInitializer_InstanceBuilder)


@implementation TyphoonMethod (InstanceBuilder)

/* ====================================================================================================================================== */
#pragma mark - Interface Methods

- (NSArray *)injectedParameters
{
    return [_injectedParameters copy];
}

- (NSArray *)parametersInjectedByValue
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject isKindOfClass:[TyphoonInjectionByObjectFromString class]];
    }];
    return [_injectedParameters filteredArrayUsingPredicate:predicate];
}

- (NSArray *)parametersInjectedByRuntimeArgument
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject isKindOfClass:[TyphoonInjectionByRuntimeArgument class]];
    }];
    return [_injectedParameters filteredArrayUsingPredicate:predicate];
}

- (NSInvocation *)newInvocationOnClass:(Class)clazz withFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)args;
{
    BOOL isClassMethod = [self isClassMethodOnClass:clazz];
    
    NSArray *typeCodes = [TyphoonIntrospectionUtils typeCodesForSelector:self.selector ofClass:clazz isClassMethod:isClassMethod];

    NSMethodSignature *signature = [self methodSignatureWithTarget:clazz isClassMethod:isClassMethod];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation retainArguments];
    [invocation setSelector:_selector];

    [[self injectedParameters] enumerateObjectsUsingBlock:^(id <TyphoonParameterInjection> parameter, NSUInteger index, BOOL *stop) {
        TyphoonTypeDescriptor *type = [TyphoonTypeDescriptor descriptorWithTypeCode:typeCodes[index]];
        [parameter setArgumentWithType:type onInvocation:invocation withFactory:factory args:args];
    }];

    return invocation;
}

/* ====================================================================================================================================== */
#pragma mark - Private Methods

- (BOOL)isClassMethodOnClass:(Class)_class
{
    BOOL instanceRespondsToSelector = [_class instancesRespondToSelector:_selector];
    BOOL classRespondsToSelector = [_class respondsToSelector:_selector];
    
    if (!instanceRespondsToSelector && !classRespondsToSelector) {
        [NSException raise:NSInvalidArgumentException
                    format:@"Method '%@' not found on '%@'. Did you include the required ':' characters to signify arguments?",
         NSStringFromSelector(_selector), NSStringFromClass(_class)];
    }
    
    return classRespondsToSelector && !instanceRespondsToSelector;
}

- (NSMethodSignature *)methodSignatureWithTarget:(Class)clazz isClassMethod:(BOOL)isClassMethod
{
    return isClassMethod ? [clazz methodSignatureForSelector:_selector] : [clazz instanceMethodSignatureForSelector:_selector];
}

@end
