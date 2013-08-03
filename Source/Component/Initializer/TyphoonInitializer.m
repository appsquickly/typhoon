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



#import "TyphoonInitializer.h"
#import "TyphoonParameterInjectedByReference.h"
#import "NSObject+TyphoonIntrospectionUtils.h"
#import "TyphoonParameterInjectedByValue.h"
#import "TyphoonParameterInjectedByRawValue.h"
#import "TyphoonDefinition.h"
#import "TyphoonParameterInjectedAtRuntime.h"
#import "TyphoonRuntimeObjectPlaceholder.h"


@implementation TyphoonInitializer


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
    return [self initWithSelector:@selector(init) isClassMethod:TyphoonComponentInitializerIsClassMethodGuess];
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
    [self injectParameterAtIndex:[self indexOfParameter:name] withValueAsText:text requiredTypeOrNil:classOrProtocol];
}

- (void)injectParameterAtIndex:(NSUInteger)index withValueAsText:(NSString*)text requiredTypeOrNil:(id)requiredClass
{
    if (index != NSUIntegerMax && index < [_parameterNames count])
    {
        TyphoonParameterInjectedByValue* parameterInjectedByValue =
                [[TyphoonParameterInjectedByValue alloc] initWithIndex:index value:text requiredTypeOrNil:requiredClass];
        [parameterInjectedByValue setInitializer:self];
        [_injectedParameters addObject:parameterInjectedByValue];
    }
}

/* ====================================================================================================================================== */
- (void)injectParameterNamed:(NSString*)name withDefinition:(TyphoonDefinition*)definition;
{
    [self injectParameterNamed:name withReference:definition.key];
}

- (void)injectWithDefinition:(TyphoonDefinition*)definition;
{
    [self injectParameterAtIndex:[_injectedParameters count] withDefinition:definition];
}

- (void)injectWithRuntimeObject:(id)anObject
{
    [self injectParameterAtIndex:[_injectedParameters count] withRuntimeObject:anObject];
}

- (void)injectParameterAtIndex:(NSUInteger)index withRuntimeObject:(TyphoonRuntimeObjectPlaceholder *)placeholder;
{
    if (index != NSUIntegerMax && index < [_parameterNames count])
    {
        [_injectedParameters addObject:[[TyphoonParameterInjectedAtRuntime alloc] initWithParameterIndex:index runtimeArgumentIndex:placeholder.indexInArguments]];
    }
}

- (void)injectWithRuntimeObjectAtIndex:(NSUInteger)runtimeArgumentIndex;
{
    [self injectParameterAtIndex:[_injectedParameters count] withRuntimeObjectAtIndex:runtimeArgumentIndex];
}

- (void)injectParameterAtIndex:(NSUInteger)index withRuntimeObjectAtIndex:(NSUInteger)runtimeArgumentIndex;
{
    if (index != NSUIntegerMax && index < [_parameterNames count])
    {
        [_injectedParameters addObject:[[TyphoonParameterInjectedAtRuntime alloc] initWithParameterIndex:index runtimeArgumentIndex:runtimeArgumentIndex]];
    }
}

- (void)injectWithValueAsText:(NSString*)text
{
    [self injectWithValueAsText:text requiredTypeOrNil:nil];
}

- (void)injectWithValueAsText:(NSString*)text requiredTypeOrNil:(id)requiredTypeOrNil
{
    [self injectParameterAtIndex:[_injectedParameters count] withValueAsText:text requiredTypeOrNil:requiredTypeOrNil];
}

- (void)injectParameterAtIndex:(NSUInteger)index withObject:(id)value
{
    if (index != NSUIntegerMax && index < [_parameterNames count])
    {
        [_injectedParameters addObject:[[TyphoonParameterInjectedByRawValue alloc] initWithParameterIndex:index value:value]];
    }
}

- (void)injectParameterNamed:(NSString*)name withObject:(id)value
{
    [self injectParameterAtIndex:[self indexOfParameter:name] withObject:value];
}

- (void)injectParameterWithObject:(id)value
{
    [self injectParameterAtIndex:[_injectedParameters count] withObject:value];
}

/* ====================================================================================================================================== */
#pragma mark - Block assembly

- (void)injectParameterAtIndex:(NSUInteger)index1 withDefinition:(TyphoonDefinition*)definition
{
    [self injectParameterAtIndex:index1 withReference:definition.key];
}


- (void)setSelector:(SEL)selector
{
    _selector = selector;
    _parameterNames = [self parameterNamesForSelector:_selector];
}

/* ============================================================ Utility Methods ========================================================= */
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



@end