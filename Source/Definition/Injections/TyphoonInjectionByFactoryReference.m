//
//  TyphoonInjectionByFactoryReference.m
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 12.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonInjectionByFactoryReference.h"
#import "TyphoonComponentFactory+InstanceBuilder.h"
#import "TyphoonCallStack.h"
#import "TyphoonStackElement.h"
#import "NSInvocation+TCFUnwrapValues.h"

@implementation TyphoonInjectionByFactoryReference

- (instancetype)initWithReference:(NSString *)reference args:(TyphoonRuntimeArguments *)referenceArguments keyPath:(NSString *)keyPath
{
    self = [super initWithReference:reference args:referenceArguments];
    if (self) {
        _keyPath = keyPath;
    }
    return self;
}

#pragma mark - Overrides

- (id)copyWithZone:(NSZone *)zone
{
    TyphoonInjectionByFactoryReference *copied =
        [[TyphoonInjectionByFactoryReference alloc] initWithReference:self.reference args:self.referenceArguments keyPath:self.keyPath];
    [self copyBaseProperiesTo:copied];
    return copied;
}

- (id)valueToInjectPropertyOnInstance:(id)instance withFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)args
{
    if (instance) {
        [factory evaluateCircularDependency:self.reference propertyName:self.propertyName instance:instance];
        if ([factory isCircularPropertyWithName:self.propertyName onInstance:instance]) {
            return nil;
        }
    }

    id factoryReference = [self componentForReferenceWithFactory:factory args:args];
    return [factoryReference valueForKeyPath:self.keyPath];
}

- (void)setArgumentWithType:(TyphoonTypeDescriptor *)type onInvocation:(NSInvocation *)invocation withFactory:(TyphoonComponentFactory *)factory
                       args:(TyphoonRuntimeArguments *)args
{
    id factoryReference = [self componentForReferenceWithFactory:factory args:args];
    id valueToInject = [factoryReference valueForKeyPath:_keyPath];

    [invocation typhoon_setArgumentObject:valueToInject atIndex:self.parameterIndex + 2];
}

@end
