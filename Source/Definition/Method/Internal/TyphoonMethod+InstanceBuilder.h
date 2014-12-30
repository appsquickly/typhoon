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

@class TyphoonInjectionContext;
@protocol TyphoonParameterInjection;

@interface TyphoonMethod (InstanceBuilder)

- (NSArray *)injectedParameters;

- (void)createInvocationWithContext:(TyphoonInjectionContext *)context completion:(void(^)(NSInvocation *invocation))result;

- (BOOL)isClassMethodOnClass:(Class)clazz;

- (void)checkParametersCount;

- (void)replaceInjection:(id<TyphoonParameterInjection>)injection with:(id<TyphoonParameterInjection>)injectionToReplace;

@end
