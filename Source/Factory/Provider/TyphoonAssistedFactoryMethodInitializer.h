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


/**
 * Describes how a factory method will use an init method, by mapping the
 * factory method arguments and factory properties to the init method arguments.
 */
@interface TyphoonAssistedFactoryMethodInitializer : NSObject <TyphoonAssistedFactoryMethod>

/** The init method name. Should be an instance method in the returnType. */
@property(nonatomic, assign) SEL selector;

/** The factory method name */
@property(nonatomic, assign, readonly) SEL factoryMethod;

/** Type of the returned instance from the factory method */
@property(nonatomic, assign, readonly) Class returnType;

/**
 * The parameters definitions, sorted by parameter index.
 * Users should not use this property directly.
 */
@property(nonatomic, copy, readonly) NSArray *parameters;

/**
 * Creates a description for the given factoryMethod that will return an
 * instance of the given returnType.
 */
- (instancetype)initWithFactoryMethod:(SEL)factoryMethod returnType:(Class)returnType;

#pragma mark - Configuration methods

/**
 * Inject the given property as next parameter.
 */
- (void)injectWithProperty:(SEL)property;

/**
 * Inject the given property as given named parameter.
 */
- (void)injectParameterNamed:(NSString *)parameterName withProperty:(SEL)property;

/**
 * Inject the given property as given positional parameter.
 */
- (void)injectParameterAtIndex:(NSUInteger)parameterIndex withProperty:(SEL)property;

/**
 * Inject the positional factory method argument as next parameter.
 */
- (void)injectWithArgumentAtIndex:(NSUInteger)argumentIndex;

/**
 * Inject the positional factory method argument as the given named parameter.
 */
- (void)injectParameterNamed:(NSString *)parameterName withArgumentAtIndex:(NSUInteger)argumentIndex;

/**
 * Inject the positional factory method argument as the given positional parameter.
 */
- (void)injectParameterAtIndex:(NSUInteger)parameterIndex withArgumentAtIndex:(NSUInteger)argumentIndex;

/**
 * Inject the named factory method argument as next parameter.
 */
- (void)injectWithArgumentNamed:(NSString *)argumentName;

/**
 * Inject the named factory method argument as the given named parameter.
 */
- (void)injectParameterNamed:(NSString *)parameterName withArgumentNamed:(NSString *)argumentName;

/**
 * Inject the named factory method argument as the given positional parameter.
 */
- (void)injectParameterAtIndex:(NSUInteger)parameterIndex withArgumentNamed:(NSString *)argumentName;

#pragma mark - Query methods

/**
 * Number of configured parameters. Use this instead of recovering the
 * parameters property.
 *
 * Users should not use this method directly.
 */
- (NSUInteger)countOfParameters;

@end
