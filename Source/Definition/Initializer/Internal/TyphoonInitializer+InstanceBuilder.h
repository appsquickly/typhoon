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
#import "TyphoonInitializer.h"

@class TyphoonComponentFactory;
@class TyphoonRuntimeArguments;

@interface TyphoonInitializer (InstanceBuilder)

@property(nonatomic, readonly) BOOL isClassMethod;

- (NSArray *)parametersInjectedByValue;
- (NSArray *)parametersInjectedByRuntimeArgument;

- (NSInvocation *)newInvocationInFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)args;

- (void)setDefinition:(TyphoonDefinition *)definition;

- (BOOL)isPrimitiveParameterAtIndex:(NSUInteger)index;

@end
