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

#import "TyphoonAssistedFactoryMethodInitializer.h"

#import "NSObject+TyphoonIntrospectionUtils.h"
#import "TyphoonAssistedFactoryParameterInjectedWithArgumentIndex.h"
#import "TyphoonAssistedFactoryParameterInjectedWithProperty.h"

@interface TyphoonAssistedFactoryMethodInitializer ()

@property(nonatomic, copy) NSMutableArray *injectedParameters;

@end

@implementation TyphoonAssistedFactoryMethodInitializer
{
@private
    NSArray *_parameterNames;
    NSArray *_argumentNames;
}

#pragma mark - Initializers & dealloc

- (instancetype)initWithFactoryMethod:(SEL)factoryMethod returnType:(Class)returnType
{
    self = [super init];
    if (self) {
        _factoryMethod = factoryMethod;
        _returnType = returnType;
        _injectedParameters = [[NSMutableArray alloc] init];
    }

    return self;
}

#pragma mark - Properties

- (void)setSelector:(SEL)selector
{
    _selector = selector;
    _parameterNames = nil;
}

- (NSArray *)parameters
{
    return [self.injectedParameters sortedArrayWithOptions:0
        usingComparator:^NSComparisonResult(id <TyphoonAssistedFactoryInjectedParameter> p1, id <TyphoonAssistedFactoryInjectedParameter> p2) {
            if (p1.parameterIndex < p2.parameterIndex) {return NSOrderedAscending;}
            if (p1.parameterIndex > p2.parameterIndex) {return NSOrderedDescending;}
            return NSOrderedSame;
        }];
}

#pragma mark - Configuration methods

- (void)injectWithProperty:(SEL)property
{
    [self injectParameterAtIndex:[_injectedParameters count] withProperty:property];
}

- (void)injectParameterNamed:(NSString *)parameterName withProperty:(SEL)property
{
    [self injectParameterAtIndex:[self indexOfParameter:parameterName] withProperty:property];
}

- (void)injectParameterAtIndex:(NSUInteger)parameterIndex withProperty:(SEL)property
{
    if (parameterIndex != NSNotFound && parameterIndex < [[self parameterNames] count]) {
        [_injectedParameters addObject:[[TyphoonAssistedFactoryParameterInjectedWithProperty alloc]
            initWithParameterIndex:parameterIndex property:property]];
    }
}

- (void)injectWithArgumentAtIndex:(NSUInteger)argumentIndex
{
    [self injectParameterAtIndex:[_injectedParameters count] withArgumentAtIndex:argumentIndex];
}

- (void)injectParameterNamed:(NSString *)parameterName withArgumentAtIndex:(NSUInteger)argumentIndex
{
    [self injectParameterAtIndex:[self indexOfParameter:parameterName] withArgumentAtIndex:argumentIndex];
}

- (void)injectParameterAtIndex:(NSUInteger)parameterIndex withArgumentAtIndex:(NSUInteger)argumentIndex
{
    if (parameterIndex != NSNotFound && parameterIndex < [[self parameterNames] count] && argumentIndex != NSNotFound && argumentIndex <
        [[self argumentNames] count]) {
        [_injectedParameters addObject:[[TyphoonAssistedFactoryParameterInjectedWithArgumentIndex alloc]
            initWithParameterIndex:parameterIndex argumentIndex:argumentIndex]];
    }
}

- (void)injectWithArgumentNamed:(NSString *)argumentName
{
    [self injectParameterAtIndex:[_injectedParameters count] withArgumentNamed:argumentName];
}

- (void)injectParameterNamed:(NSString *)parameterName withArgumentNamed:(NSString *)argumentName
{
    [self injectParameterAtIndex:[self indexOfParameter:parameterName] withArgumentNamed:argumentName];
}

- (void)injectParameterAtIndex:(NSUInteger)parameterIndex withArgumentNamed:(NSString *)argumentName
{
    [self injectParameterAtIndex:parameterIndex withArgumentAtIndex:[self indexOfArgument:argumentName]];
}

#pragma mark - Query methods

- (NSUInteger)countOfParameters
{
    return [self.injectedParameters count];
}

#pragma mark - Private properties

- (NSArray *)parameterNames
{
    if (_parameterNames == nil) {
        _parameterNames = [self parameterNamesForSelector:_selector];
    }

    return _parameterNames;
}

- (NSArray *)argumentNames
{
    if (!_argumentNames) {
        _argumentNames = [self parameterNamesForSelector:_factoryMethod];
    }

    return _argumentNames;
}

#pragma mark - Private methods

- (NSInteger)indexOfParameter:(NSString *)name
{
    return [[self parameterNames] indexOfObject:name];
}

- (NSInteger)indexOfArgument:(NSString *)name
{
    return [[self argumentNames] indexOfObject:name];
}

@end
