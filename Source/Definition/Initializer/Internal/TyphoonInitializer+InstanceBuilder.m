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
#import "TyphoonInitializer+InstanceBuilder.h"
#import "TyphoonParameterInjectedWithStringRepresentation.h"
#import "TyphoonDefinition.h"
#import "TyphoonComponentFactory.h"

TYPHOON_LINK_CATEGORY(TyphoonInitializer_InstanceBuilder)


@implementation TyphoonInitializer (InstanceBuilder)

/* ====================================================================================================================================== */
#pragma mark - Interface Methods

- (NSArray *)parametersInjectedByValue
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject isKindOfClass:[TyphoonParameterInjectedWithStringRepresentation class]];
    }];
    return [_injectedParameters filteredArrayUsingPredicate:predicate];

}

- (NSInvocation *)newInvocationInFactory:(TyphoonComponentFactory *)factory
{
    Class clazz = _definition.factory ? _definition.factory.type : _definition.type;

    NSMethodSignature *signature = [self methodSignatureWithTarget:clazz];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:_selector];

    for (TyphoonAbstractInjectedParameter *parameter in [self injectedParameters]) {
        [parameter withFactory:factory setArgumentOnInvocation:invocation];
    }

    return invocation;
}

- (void)setDefinition:(TyphoonDefinition *)definition
{
    _definition = definition;
    [self resolveIsClassMethod];
}

- (BOOL)isClassMethod
{
    return [self resolveIsClassMethod];
}


/* ====================================================================================================================================== */
#pragma mark - Private Methods

- (BOOL)resolveIsClassMethod
{
    if (_definition.factory) {
        if (_isClassMethodStrategy == TyphoonComponentInitializerIsClassMethodYes) {
            [NSException raise:NSInvalidArgumentException
                format:@"'is-class-method' can't be 'TyphoonComponentInitializerIsClassMethodYes' when factory-component is used!"];
        }
        else {
            return NO;
        }
    }

    switch (_isClassMethodStrategy) {
        case TyphoonComponentInitializerIsClassMethodNo:
            return NO;
        case TyphoonComponentInitializerIsClassMethodYes:
            return YES;
        case TyphoonComponentInitializerIsClassMethodGuess:
            return [self selectorDoesNotStartWithInit];
        default:
            return NO;
    }
}

- (BOOL)selectorDoesNotStartWithInit
{
    return ![NSStringFromSelector(_selector) hasPrefix:@"init"];
}


- (NSMethodSignature *)methodSignatureWithTarget:(Class)clazz
{
    if (![self isValidForTarget:clazz]) {
        NSString *typeType = self.isClassMethod ? @"Class" : @"Instance";
        [NSException raise:NSInvalidArgumentException
            format:@"%@ method '%@' not found on '%@'. Did you include the required ':' characters to signify arguments?", typeType,
                   NSStringFromSelector(_selector), NSStringFromClass(clazz)];
    }

    NSMethodSignature *signature =
        self.isClassMethod ? [clazz methodSignatureForSelector:_selector] : [clazz instanceMethodSignatureForSelector:_selector];
    return signature;
}

- (BOOL)isValidForTarget:(Class)clazz
{
    return ([self isClassMethod] && [clazz respondsToSelector:_selector]) ||
        (![self isClassMethod] && [clazz instancesRespondToSelector:_selector]);
}

@end
