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



#import "TyphoonCollaboratingAssemblyProxy.h"
#import "TyphoonInitializer.h"
#import "NSObject+TyphoonIntrospectionUtils.h"
#import "TyphoonDefinition.h"

#import "TyphoonParameterInjection.h"

#import "TyphoonInjections.h"

@implementation TyphoonInitializer


/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)initWithSelector:(SEL)initializer
{
    return [self initWithSelector:initializer isClassMethodStrategy:TyphoonComponentInitializerIsClassMethodGuess];
}

- (id)initWithSelector:(SEL)initializer isClassMethodStrategy:(TyphoonComponentInitializerIsClassMethod)isClassMethod;
{
    self = [super init];
    if (self) {
        _injectedParameters = [[NSMutableArray alloc] init];
        _isClassMethodStrategy = isClassMethod;
        self.selector = initializer;
    }
    return self;
}

- (id)init
{
    return [self initWithSelector:@selector(init) isClassMethodStrategy:TyphoonComponentInitializerIsClassMethodGuess];
}

/* ====================================================================================================================================== */
#pragma mark - Interface Methods

- (TyphoonDefinition *)definition
{
    return _definition;
}

- (NSArray *)injectedParameters
{
    return [_injectedParameters copy];
}

#pragma mark - manipulations with _injectedParameters

- (void)addParameterInjection:(id <TyphoonParameterInjection>)injection
{
    [_injectedParameters addObject:injection];
}

- (BOOL)canAddParameterAtIndex:(NSUInteger)index
{
    return index < [_parameterNames count];
}

- (NSUInteger)indexToAddParameter
{
    return [_injectedParameters count];
}

#pragma mark - Injections

- (void)injectParameterAtIndex:(NSUInteger)index with:(id)injection
{
    if ([self canAddParameterAtIndex:index]) {
        injection = TyphoonMakeInjectionFromObjectIfNeeded(injection);
        [injection setParameterIndex:index withInitializer:self];
        [self addParameterInjection:injection];
    }
}

- (void)injectParameterWith:(id)injection
{
    [self injectParameterAtIndex:[self indexToAddParameter] with:injection];
}

- (void)injectParameter:(NSString *)parameterName with:(id)injection
{
    [self injectParameterNamed:parameterName success:^(NSInteger index) {
        [self injectParameterAtIndex:index with:injection];
    }];
}

//============================================================================================================================================
#pragma mark - Parameters names

- (void)injectParameterNamed:(NSString *)name success:(void (^)(NSInteger))success
{
    NSInteger index = [self indexOfParameter:name];
    if (index == NSNotFound) {
        [NSException raise:NSInvalidArgumentException format:@"%@", [self parameterNotFoundErrorMessageWithParameterNamed:name]];
    }

    if (success) {
        success(index);
    }
}

- (NSString *)parameterNotFoundErrorMessageWithParameterNamed:(NSString *)name
{
    if ([_parameterNames count] == 0) {
        return [NSString stringWithFormat:@"Specified a parameter named '%@', but method '%@' takes no parameters.", name,
                                          NSStringFromSelector([self selector])];
    }

    NSString *failureExplanation =
        [NSString stringWithFormat:@"Unrecognized parameter name: '%@' for method '%@'.", name, NSStringFromSelector([self selector])];
    NSString *recoverySuggestion = [self recoverySuggestionForMissingParameter];
    return [NSString stringWithFormat:@"%@ %@", failureExplanation, recoverySuggestion];
}

- (NSString *)recoverySuggestionForMissingParameter
{
    if ([_parameterNames count] == 1) {
        return [NSString stringWithFormat:@"Did you mean '%@'?", _parameterNames[0]];
    }
    else if ([_parameterNames count] == 2) {
        return [NSString stringWithFormat:@"Valid parameter names are '%@' or '%@'.", _parameterNames[0], _parameterNames[1]];
    }
    else {
        return [self recoverySuggestionForMultipleMissingParameters];
    }
}

- (NSString *)recoverySuggestionForMultipleMissingParameters
{
    NSMutableString *messageBuilder = [NSMutableString stringWithFormat:@"Valid parameter names are"];
    [_parameterNames enumerateObjectsUsingBlock:^(NSString *aParameterName, NSUInteger idx, BOOL *stop) {
        BOOL thisIsLastParameter = (idx == [_parameterNames count] - 1);
        if (idx == 0) {
            [messageBuilder appendFormat:@" '%@'", aParameterName];
        }
        else if (!thisIsLastParameter) { // middleParameter
            [messageBuilder appendFormat:@", '%@'", aParameterName];
        }
        else { // lastParameter
            [messageBuilder appendFormat:@", or '%@'.", aParameterName];
        }
    }];

    return [NSString stringWithString:messageBuilder];
}

- (void)setSelector:(SEL)selector
{
    _selector = selector;
    _parameterNames = [self parameterNamesForSelector:_selector];
}

/* ====================================================================================================================================== */
#pragma mark - Utility Methods

- (id)copyWithZone:(NSZone *)zone
{
    TyphoonInitializer *copy = [[TyphoonInitializer alloc] initWithSelector:_selector isClassMethodStrategy:_isClassMethodStrategy];
    for (id <TyphoonParameterInjection> parameter in _injectedParameters) {
        [copy addParameterInjection:[parameter copyWithZone:NSDefaultMallocZone()]];
    }
    return copy;
}


/* ====================================================================================================================================== */
#pragma mark - Private Methods

- (NSInteger)indexOfParameter:(NSString *)name
{
    NSInteger parameterIndex = NSNotFound;
    for (NSInteger i = 0; i < [_parameterNames count]; i++) {
        NSString *parameterName = [_parameterNames objectAtIndex:i];
        if ([name isEqualToString:parameterName]) {
            parameterIndex = i;
            break;
        }
    }
    return parameterIndex;
}


@end
