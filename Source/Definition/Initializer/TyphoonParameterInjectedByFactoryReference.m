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



#import "TyphoonParameterInjectedByFactoryReference.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonComponentFactory+InstanceBuilder.h"
#import "TyphoonCallStack.h"
#import "TyphoonStackElement.h"


@implementation TyphoonParameterInjectedByFactoryReference

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (instancetype)initWithParameterIndex:(NSUInteger)parameterIndex factoryReference:(NSString *)reference keyPath:(NSString *)keyPath
{
    self = [super init];
    if (self) {
        _index = parameterIndex;
        _factoryReference = reference;
        _keyPath = keyPath;
    }
    return self;
}

/* ====================================================================================================================================== */
#pragma mark - Overridden Methods

- (void)withFactory:(TyphoonComponentFactory *)factory setArgumentOnInvocation:(NSInvocation *)invocation
{
    [[[factory stack] peekForKey:_factoryReference] instance]; //Raises circular dependencies exception if already initializing.
    NSObject *factoryComponent = [factory componentForKey:_factoryReference];
    id valueToInject = [factoryComponent valueForKeyPath:_keyPath];

    [self setObject:valueToInject forInvocation:invocation];
}

/* ====================================================================================================================================== */


#pragma mark - Utility Methods

- (id)copyWithZone:(NSZone *)zone
{
    return [[TyphoonParameterInjectedByFactoryReference alloc]
        initWithParameterIndex:_index factoryReference:[_factoryReference copy] keyPath:[_keyPath copy]];
}


@end
