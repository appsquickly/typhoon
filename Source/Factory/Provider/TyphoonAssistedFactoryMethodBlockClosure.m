//
//  TyphoonAssistedFactoryMethodBlockClosure.m
//  A-Typhoon
//
//  Created by Daniel Rodríguez Troitiño on 01/02/14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonAssistedFactoryMethodBlockClosure.h"

@implementation TyphoonAssistedFactoryMethodBlockClosure
{
    SEL _selector;
}

@synthesize methodSignature = _methodSignature;

- (instancetype)initWithSelector:(SEL)selector methodSignature:(NSMethodSignature *)methodSignature
{
    self = [super init];
    if (self) {
        NSParameterAssert(selector);
        NSParameterAssert(methodSignature);

        _selector = selector;
        _methodSignature = methodSignature;
    }

    return self;
}

- (NSInvocation *)invocationWithFactory:(id)factory forwardedInvocation:(NSInvocation *)anInvocation
{
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:_methodSignature];
    invocation.target = factory;
    invocation.selector = _selector;

    NSUInteger numberOfArguments = [_methodSignature numberOfArguments];
    for (NSUInteger idx = 2; idx < numberOfArguments; idx++) {
        NSUInteger argumentSize = 0;
        NSGetSizeAndAlignment([_methodSignature getArgumentTypeAtIndex:idx], &argumentSize, NULL);

        void *argument = malloc(argumentSize);
        [anInvocation getArgument:argument atIndex:idx];
        [invocation setArgument:argument atIndex:idx];
        free(argument);
    }

    return invocation;
}

@end
