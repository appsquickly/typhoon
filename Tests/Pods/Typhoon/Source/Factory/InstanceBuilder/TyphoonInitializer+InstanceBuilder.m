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



#import "TyphoonInitializer+InstanceBuilder.h"
#import "TyphoonParameterInjectedByValue.h"
#import "TyphoonDefinition.h"
#import "TyphoonDefinition+InstanceBuilder.h"


@implementation TyphoonInitializer (InstanceBuilder)

/* ========================================================== Interface Methods ========================================================= */
- (NSArray*)injectedParameters
{
    return [_injectedParameters copy];
}

- (NSArray *)parametersInjectedByValue
{
    NSPredicate* predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary* bindings)
    {
        return [evaluatedObject isKindOfClass:[TyphoonParameterInjectedByValue class]];
    }];
    return [_injectedParameters filteredArrayUsingPredicate:predicate];

}

- (NSInvocation*)asInvocationFor:(id)classOrInstance
{
    if (![classOrInstance respondsToSelector:_selector])
    {
        NSString* typeType = self.isClassMethod ? @"Class" : @"Instance";
        NSString* typeName = self.isClassMethod ? NSStringFromClass(classOrInstance) : NSStringFromClass([classOrInstance class]);
        [NSException raise:NSInvalidArgumentException
                format:@"%@ method '%@' not found on '%@'. Did you include the required ':' characters to signify arguments?", typeType,
                       NSStringFromSelector(_selector), typeName];
    }

    NSInvocation* invocation;
    if (self.isClassMethod)
    {
        invocation = [NSInvocation invocationWithMethodSignature:[classOrInstance methodSignatureForSelector:_selector]];
    }
    else
    {
        invocation = [NSInvocation invocationWithMethodSignature:[[classOrInstance class] instanceMethodSignatureForSelector:_selector]];
    }
    [invocation setTarget:classOrInstance];
    [invocation setSelector:_selector];
    return invocation;
}


- (void)setComponentDefinition:(TyphoonDefinition*)definition
{
    _definition = definition;
    [self resolveIsClassMethod];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"Initializer: %@, isFactoryMethod? %@, parameters: %@", NSStringFromSelector(_selector),
                                      self.isClassMethod ? @"YES" : @"NO", _injectedParameters];
}

- (BOOL)isClassMethod
{
    return [self resolveIsClassMethod];
}


/* ============================================================ Private Methods ========================================================= */
- (BOOL)resolveIsClassMethod
{
    if (_definition.factoryReference)
    {
        if (_isClassMethodStrategy == YES)
        {
            [NSException raise:NSInvalidArgumentException format:@"'is-class-method' can't be 'YES' when factory-component is used!"];
        }
        else
        {
            return NO;
        }
    }

    switch (_isClassMethodStrategy)
    {
        case TyphoonComponentInitializerIsClassMethodNo:
            return NO;
        case TyphoonComponentInitializerIsClassMethodYes:
            return YES;
        case TyphoonComponentInitializerIsClassMethodGuess:
            return ![NSStringFromSelector(_selector) hasPrefix:@"init"];
    }
}


@end