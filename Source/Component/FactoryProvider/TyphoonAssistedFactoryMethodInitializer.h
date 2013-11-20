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

#import <Foundation/Foundation.h>

#import "TyphoonAssistedFactoryMethod.h"
#import "TyphoonAssistedFactoryInjectedParameter.h"

@class TyphoonAssistedFactoryMethodInitializer;

typedef void(^TyphoonAssistedFactoryInitializerBlock)(TyphoonAssistedFactoryMethodInitializer *initializer);

@interface TyphoonAssistedFactoryMethodInitializer : NSObject <TyphoonAssistedFactoryMethod>

@property (nonatomic, assign, readonly) SEL factoryMethod;
@property (nonatomic, assign, readonly) Class returnType;
@property (nonatomic, assign) SEL selector;

@property (nonatomic, copy, readonly) NSArray *parameters;

- (instancetype)initWithFactoryMethod:(SEL)factoryMethod returnType:(Class)returnType;

#pragma mark - Configuration methods

- (void)injectWithProperty:(SEL)property;

- (void)injectParameterNamed:(NSString *)parameterName withProperty:(SEL)property;

- (void)injectParameterAtIndex:(NSUInteger)parameterIndex withProperty:(SEL)property;

- (void)injectWithArgumentAtIndex:(NSUInteger)argumentIndex;

- (void)injectParameterNamed:(NSString *)parameterName withArgumentAtIndex:(NSUInteger)argumentIndex;

- (void)injectParameterAtIndex:(NSUInteger)parameterIndex withArgumentAtIndex:(NSUInteger)argumentIndex;

- (void)injectWithArgumentNamed:(NSString *)argumentName;

- (void)injectParameterNamed:(NSString *)parameterName withArgumentNamed:(NSString *)argumentName;

- (void)injectParameterAtIndex:(NSUInteger)parameterIndex withArgumentNamed:(NSString *)argumentName;

#pragma mark - Query methods

- (NSUInteger)countOfParameters;

@end
