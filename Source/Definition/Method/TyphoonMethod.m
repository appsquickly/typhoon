////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import "TyphoonMethod.h"
#import "TyphoonParameterInjection.h"
#import "TyphoonInjections.h"

@implementation TyphoonMethod {
    BOOL _needUpdateHash;
    NSUInteger _hash;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction

- (id)initWithSelector:(SEL)selector
{
    self = [super init];
    if (self) {
        _injectedParameters = [[NSMutableArray alloc] init];
        _selector = selector;
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

//-------------------------------------------------------------------------------------------
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
        hash = (NSUInteger) ((5u << hash) - hash + [[parameter description] hash]);
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

@end
