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
#import "NSArray+TyphoonManualEnumeration.h"
#import "NSInvocation+TCFUnwrapValues.h"
#import "TyphoonParameterInjection.h"

TYPHOON_LINK_CATEGORY(TyphoonInitializer_InstanceBuilder)


@implementation TyphoonMethod (InstanceBuilder)

/* ====================================================================================================================================== */
#pragma mark - Interface Methods

- (void)replaceInjection:(id<TyphoonParameterInjection>)injection with:(id<TyphoonParameterInjection>)injectionToReplace
{
    [injectionToReplace setParameterIndex:[injection parameterIndex]];
    NSUInteger index = [_injectedParameters indexOfObject:injection];
    [_injectedParameters replaceObjectAtIndex:index withObject:injectionToReplace];
}

- (NSArray *)injectedParameters
{
    return [_injectedParameters copy];
}

- (void)createInvocationOnClass:(Class)clazz withContext:(TyphoonInjectionContext *)context completion:(void(^)(NSInvocation *invocation))result
{
    BOOL isClassMethod = [self isClassMethodOnClass:clazz];
    
    NSMethodSignature *signature = [self methodSignatureWithTarget:clazz isClassMethod:isClassMethod];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation retainArguments];
    [invocation setSelector:_selector];
    
    [[self injectedParameters] typhoon_enumerateObjectsWithManualIteration:^(id<TyphoonParameterInjection> object, id<TyphoonIterator> iterator) {
        NSUInteger index = [object parameterIndex] + 2;
        context.destinationType = [TyphoonTypeDescriptor descriptorWithEncodedType:[signature getArgumentTypeAtIndex:index]];
        [object valueToInjectWithContext:context completion:^(id value) {
            [invocation typhoon_setArgumentObject:value atIndex:index];
            [iterator next];
        }];
    } completion:^{
        result(invocation);
    }];
}

- (void)checkParametersCount
{
    if ([TyphoonIntrospectionUtils numberOfArgumentsInSelector:_selector] != [_injectedParameters count]) {
        [NSException raise:NSInternalInconsistencyException format:@"Method '%@' has %d parameters, but %d was injected", NSStringFromSelector(_selector), (int)[_parameterNames count], (int)[_injectedParameters count]];
    }
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
