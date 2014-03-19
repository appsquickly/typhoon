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

@interface TyphoonMethod (InstanceBuilder)

- (NSArray *)injectedParameters;

- (NSArray *)parametersInjectedByValue;

- (NSArray *)parametersInjectedByRuntimeArgument;

- (NSInvocation *)newInvocationOnClass:(Class)clazz withFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)args;

- (BOOL)isClassMethodOnClass:(Class)clazz;

@end
