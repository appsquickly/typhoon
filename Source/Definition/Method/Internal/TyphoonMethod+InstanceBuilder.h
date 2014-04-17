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
#import "TyphoonMethod.h"

@class TyphoonComponentFactory;
@class TyphoonRuntimeArguments;
@class TyphoonInjectionContext;

@interface TyphoonMethod (InstanceBuilder)

- (NSArray *)injectedParameters;

- (NSArray *)parametersInjectedByValue;

- (NSArray *)parametersInjectedByRuntimeArgument;

- (void)createInvocationOnClass:(Class)clazz withContext:(TyphoonInjectionContext *)context completion:(void(^)(NSInvocation *invocation))result;

- (BOOL)isClassMethodOnClass:(Class)clazz;

- (void)checkParametersCount;

@end
