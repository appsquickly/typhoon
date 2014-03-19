//
//  TyphoonParameterInjection.h
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 11.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

@class TyphoonComponentFactory;
@class TyphoonRuntimeArguments;
@class TyphoonMethod;
@class TyphoonTypeDescriptor;

@protocol TyphoonParameterInjection <NSObject, NSCopying>

- (void)setParameterIndex:(NSUInteger)index;

- (void)setArgumentWithType:(TyphoonTypeDescriptor *)type onInvocation:(NSInvocation *)invocation withFactory:(TyphoonComponentFactory *)factory
    args:(TyphoonRuntimeArguments *)args;

@end
