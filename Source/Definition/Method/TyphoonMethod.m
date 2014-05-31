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
#import "TyphoonMethod.h"
#import "NSObject+TyphoonIntrospectionUtils.h"
#import "TyphoonDefinition.h"

#import "TyphoonParameterInjection.h"

#import "TyphoonInjections.h"

#import <objc/runtime.h>

@implementation TyphoonMethod {
    BOOL _needUpdateHash;
    NSUInteger _hash;
}

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)initWithSelector:(SEL)selector
{
    self = [super init];
    if (self) {
        _injectedParameters = [[NSMutableArray alloc] init];
        self.selector = selector;
        _needUpdateHash = YES;
    }
    return self;
}

- (id)init
{
    return [self initWithSelector:nil];
}

#pragma mark - manipulations with _injectedParameters

- (void)addParameterInjection:(id <TyphoonParameterInjection>)injection
{
    [_injectedParameters addObject:injection];
}

- (NSUInteger)indexToAddParameter
{
    return [_injectedParameters count];
}

#pragma mark - Injections

- (void)injectParameterAtIndex:(NSUInteger)index with:(id)injection
{
    injection = TyphoonMakeInjectionFromObjectIfNeeded(injection);
    [injection setParameterIndex:index];
    [self addParameterInjection:injection];
    _needUpdateHash = YES;
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
    _parameterNames = [self typhoon_parameterNamesForSelector:_selector];
    _needUpdateHash = YES;
}

/* ====================================================================================================================================== */
#pragma mark - Utility Methods

- (id)copyWithZone:(NSZone *)zone
{
    TyphoonMethod *copy = [[TyphoonMethod alloc] initWithSelector:_selector];
    for (id <TyphoonParameterInjection> parameter in _injectedParameters) {
        [copy addParameterInjection:[parameter copyWithZone:NSDefaultMallocZone()]];
    }
    return copy;
}

- (NSUInteger)hash
{
    if (_needUpdateHash) {
        _hash = [self calculateHash];
        _needUpdateHash = NO;
    }
    return _hash;
}

- (NSUInteger)calculateHash
{
    NSUInteger hash = (NSUInteger) sel_getName(_selector);

    for (id <TyphoonParameterInjection> parameter in _injectedParameters) {
        hash = (NSUInteger) ((5 << hash) - hash + [[parameter description] hash]);
    }

    return hash;
}


- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    }
    if (!other || ![[other class] isEqual:[self class]]) {
        return NO;
    }
    
    return [self isEqualToMethod:other];
}

- (BOOL)isEqualToMethod:(TyphoonMethod *)method
{
    if (self == method) {
        return YES;
    }
    if (method == nil) {
        return NO;
    }
    
    return _selector == method.selector && [method->_injectedParameters isEqualToArray:_injectedParameters];
}

/* ====================================================================================================================================== */
#pragma mark - Private Methods

- (NSInteger)indexOfParameter:(NSString *)name
{
    NSInteger parameterIndex = NSNotFound;
    for (NSUInteger i = 0; i < [_parameterNames count]; i++) {
        NSString *parameterName = [_parameterNames objectAtIndex:i];
        if ([name isEqualToString:parameterName]) {
            parameterIndex = i;
            break;
        }
    }
    return parameterIndex;
}


@end
