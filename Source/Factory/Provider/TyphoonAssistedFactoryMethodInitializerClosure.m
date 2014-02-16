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

#import "TyphoonAssistedFactoryMethodInitializerClosure.h"

#include <objc/message.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>

#endif

#import "TyphoonAssistedFactoryMethodInitializer.h"
#import "TyphoonAssistedFactoryParameterInjectedWithArgumentIndex.h"
#import "TyphoonAssistedFactoryParameterInjectedWithProperty.h"


@implementation TyphoonAssistedFactoryMethodInitializerClosure
{
    Class _returnType;
    SEL _initSelector;
    NSArray *_parameters;
    NSMethodSignature *_closedMethodSignature;
}

@synthesize methodSignature = _methodSignature;

- (instancetype)initWithInitializer:(TyphoonAssistedFactoryMethodInitializer *)initializer
    methodSignature:(NSMethodSignature *)methodSignature
{
    self = [super init];
    if (self) {
        NSParameterAssert(initializer.returnType);
        NSParameterAssert(initializer.selector);
        NSParameterAssert(methodSignature);

        _returnType = initializer.returnType;
        _initSelector = initializer.selector;
        _parameters = initializer.parameters;
        _methodSignature = methodSignature;
        _closedMethodSignature = [_returnType instanceMethodSignatureForSelector:_initSelector];

        NSUInteger count = _closedMethodSignature.numberOfArguments - 2;
        NSAssert([self validateInitializerParameterCount:count], @"parameter map for %s do not fill all %lu parameters", sel_getName(_initSelector), (unsigned long) count);
    }

    return self;
}

- (NSInvocation *)invocationWithFactory:(id)factory forwardedInvocation:(NSInvocation *)anInvocation
{
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:_closedMethodSignature];
    NSMutableArray *allocations = [NSMutableArray array];

    id instance = [_returnType alloc];
    if (instance) {[allocations addObject:instance];}
    invocation.target = instance;

    invocation.selector = _initSelector;

    for (id <TyphoonAssistedFactoryInjectedParameter> parameter in _parameters) {

        // Move to other solution which doesn't involve isKindOf?
        if ([parameter isKindOfClass:[TyphoonAssistedFactoryParameterInjectedWithArgumentIndex class]]) {
            TyphoonAssistedFactoryParameterInjectedWithArgumentIndex *p = parameter;

            NSUInteger argumentSize = 0;
            NSGetSizeAndAlignment([_methodSignature getArgumentTypeAtIndex:[p argumentIndex] + 2], &argumentSize, NULL);
            void *argument = malloc(argumentSize);
            [anInvocation getArgument:argument atIndex:[p argumentIndex] + 2];
            [invocation setArgument:argument atIndex:[p parameterIndex] + 2];
            free(argument);

        }
        else if ([parameter isKindOfClass:[TyphoonAssistedFactoryParameterInjectedWithProperty class]]) {
            TyphoonAssistedFactoryParameterInjectedWithProperty *p = parameter;

            // Using valueForKey will try using the property first.
            NSString *selector = [NSString stringWithCString:sel_getName([p property]) encoding:NSASCIIStringEncoding];
            id value = [factory valueForKey:selector];
            if (value) {[allocations addObject:value];}

            [invocation setArgument:&value atIndex:[p parameterIndex] + 2];
        }
        else {
            NSAssert(NO, @"Unknown parameter type %@", NSStringFromClass([parameter class]));
        }
    }

    [invocation retainArguments];
    allocations = nil;

    return invocation;
}

- (BOOL)validateInitializerParameterCount:(NSUInteger)count
{
    NSMutableIndexSet *parameters = [NSMutableIndexSet indexSet];

    for (id <TyphoonAssistedFactoryInjectedParameter> parameter in _parameters) {
        [parameters addIndex:[parameter parameterIndex]];
    }

    return [parameters containsIndexesInRange:NSMakeRange(0, count)];
}

@end
