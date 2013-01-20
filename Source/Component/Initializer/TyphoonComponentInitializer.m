////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 - 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import "TyphoonComponentInitializer.h"
#import "TyphoonParameterInjectedByReference.h"
#import "NSObject+TyphoonIntrospectionUtils.h"
#import "TyphoonParameterInjectedByValue.h"
#import "TyphoonComponentDefinition.h"


@implementation TyphoonComponentInitializer


/* ============================================================ Initializers ============================================================ */
- (id)initWithSelector:(SEL)initializer
{
    return [self initWithSelector:initializer isClassMethod:TyphoonComponentInitializerIsClassMethodGuess];
}

- (id)initWithSelector:(SEL)initializer isClassMethod:(TyphoonComponentInitializerIsClassMethod)isClassMethod;
{
    self = [super init];
    if (self)
    {
        _injectedParameters = [[NSMutableArray alloc] init];
        _isClassMethodStrategy = isClassMethod;
        self.selector = initializer;
    }
    return self;
}

- (id)init
{
    return [self initWithSelector:@selector(init) isClassMethod:NO];
}


/* ========================================================== Interface Methods ========================================================= */
- (void)injectParameterNamed:(NSString*)name withReference:(NSString*)reference
{
    [self injectParameterAtIndex:[self indexOfParameter:name] withReference:reference];
}


- (void)injectParameterAtIndex:(NSUInteger)index withReference:(NSString*)reference
{
    if (index != NSUIntegerMax && index < [_parameterNames count])
    {
        [_injectedParameters addObject:[[TyphoonParameterInjectedByReference alloc] initWithParameterIndex:index reference:reference]];
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
        TyphoonParameterInjectedByValue* parameterInjectedByValue =
                [[TyphoonParameterInjectedByValue alloc] initWithIndex:index value:text classOrProtocol:classOrProtocol];
        [parameterInjectedByValue setInitializer:self];
        [_injectedParameters addObject:parameterInjectedByValue];
    }
}

- (NSArray*)injectedParameters
{
    return [_injectedParameters copy];
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

- (void)setComponentDefinition:(TyphoonComponentDefinition*)definition
{
    _definition = definition;
    [self resolveIsClassMethod];
}

- (BOOL)isClassMethod
{
    return [self resolveIsClassMethod];
}

- (void)setSelector:(SEL)selector
{
    _selector = selector;
    _parameterNames = [self parameterNamesForSelector:_selector];
}

/* ============================================================ Utility Methods ========================================================= */
- (NSString*)description
{
    return [NSString stringWithFormat:@"Initializer: %@, isFactoryMethod? %@, parameters: %@", NSStringFromSelector(_selector),
                                      self.isClassMethod ? @"YES" : @"NO", _injectedParameters];
}

- (void)dealloc
{
    for (id <TyphoonInjectedParameter> parameter in _injectedParameters)
    {
        //Null out the __unsafe_unretained pointer back to self.
        [parameter setInitializer:nil];
    }
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

- (BOOL)resolveIsClassMethod
{
    if (_definition.factoryComponent)
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