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

#import "TyphoonMethod.h"

@class TyphoonInjectionContext;
@protocol TyphoonParameterInjection;

@interface TyphoonMethod (InstanceBuilder)

- (NSArray *)injectedParameters;

- (void)createInvocationOnClass:(Class)clazz withContext:(TyphoonInjectionContext *)context completion:(void(^)(NSInvocation *invocation))result;

- (BOOL)isClassMethodOnClass:(Class)clazz;

- (void)checkParametersCount;

- (void)replaceInjection:(id<TyphoonParameterInjection>)injection with:(id<TyphoonParameterInjection>)injectionToReplace;

@end
