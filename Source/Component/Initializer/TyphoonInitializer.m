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
#import "TyphoonDefinition.h"


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

- (void)injectParameterAt:(NSUInteger)index withValueAsText:(NSString*)text requiredTypeOrNil:(id)requiredClass
{
    if (index != NSUIntegerMax && index < [_parameterNames count])
    {
        TyphoonParameterInjectedByValue* parameterInjectedByValue =
                [[TyphoonParameterInjectedByValue alloc] initWithIndex:index value:text requiredTypeOrNil:requiredClass];
        [parameterInjectedByValue setInitializer:self];
        [_injectedParameters addObject:parameterInjectedByValue];
    }
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