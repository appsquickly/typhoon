////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "SpringComponentInitializer.h"
#import "SpringParameterInjectedByReference.h"
#import "NSObject+SpringReflectionUtils.h"
#import "SpringParameterInjectedByValue.h"


@implementation SpringComponentInitializer


/* ============================================================ Initializers ============================================================ */
- (id)initWithSelector:(SEL)initializer
{
    return [self initWithSelector:initializer isFactoryMethod:NO];
}

- (id)initWithSelector:(SEL)initializer isFactoryMethod:(BOOL)isFactoryMethod;
{
    self = [super init];
    if (self)
    {
        _selector = initializer;
        _isFactoryMethod = isFactoryMethod;
        _parameterNames = [self parameterNamesForSelector:_selector];

        _injectedParameters = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)init
{
    return [self initWithSelector:@selector(init) isFactoryMethod:NO];
}

/* ========================================================== Interface Methods ========================================================= */

- (void)injectParameterNamed:(NSString*)name withReference:(NSString*)reference
{
    [self injectParameterAt:[self indexOfParameter:name] withReference:reference];
}


- (void)injectParameterAt:(NSUInteger)index withReference:(NSString*)reference
{
    if (index != NSUIntegerMax && index < [_parameterNames count])
    {
        [_injectedParameters addObject:[[SpringParameterInjectedByReference alloc] initWithParameterIndex:index reference:reference]];
    }
}

- (void)injectParameterNamed:(NSString*)name withValueAsText:(NSString*)text requiredTypeOrNil:(id)classOrProtocol
{
    [self injectParameterAt:[self indexOfParameter:name] withValueAsText:text requiredTypeOrNil:classOrProtocol];
}

- (void)injectParameterAt:(NSUInteger)index withValueAsText:(NSString*)text requiredTypeOrNil:(id)classOrProtocol
{
    if (index != NSUIntegerMax && index < [_parameterNames count])
    {
        [_injectedParameters addObject:[[SpringParameterInjectedByValue alloc]
                initWithIndex:index value:text classOrProtocol:classOrProtocol]];
    }
}

- (NSArray*)injectedParameters
{
    return [_injectedParameters copy];
}

- (NSInvocation*)asInvocationFor:(id)classOrInstance
{
    NSInvocation* invocation;
    if (_isFactoryMethod)
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

/* ============================================================ Utility Methods ========================================================= */
- (NSString*)description
{
    return [NSString stringWithFormat:@"Initializer: %@, isFactoryMethod? %@", NSStringFromSelector(_selector),
                                      _isFactoryMethod ? @"YES" : @"NO"];
}

/* ============================================================ Private Methods ========================================================= */
- (int)indexOfParameter:(NSString*)name
{
    int parameterIndex = NSUIntegerMax;
    for (int i = 0; i < [_parameterNames count]; i++)
    {
        NSString* parameterName = [_parameterNames objectAtIndex:i];
        if ([name isEqualToString:parameterName])
        {
            parameterIndex = i;
            break;
        }
    }
    return parameterIndex;
}

@end