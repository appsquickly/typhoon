//
//  TyphoonInjectionByType.m
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 12.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonInjectionByType.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonTypeDescriptor.h"
#import "TyphoonComponentFactory+InstanceBuilder.h"
#import "TyphoonDefinition.h"

@implementation TyphoonInjectionByType

#pragma mark - Overrides

- (id)copyWithZone:(NSZone *)zone
{
    TyphoonInjectionByType *copied = [[TyphoonInjectionByType alloc] init];
    [self copyBaseProperiesTo:copied];
    return copied;
}

- (id)valueToInjectPropertyOnInstance:(id)instance withFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)args
{
    id value = nil;

    TyphoonTypeDescriptor *type = [instance typhoon_typeForPropertyWithName:self.propertyName];
    TyphoonDefinition *definition = [factory definitionForType:[type classOrProtocol]];

    [factory evaluateCircularDependency:definition.key propertyName:self.propertyName instance:instance];
    if (![factory isCircularPropertyWithName:self.propertyName onInstance:instance]) {
        value = [factory componentForKey:definition.key];
    }

    return value;
}

- (void)setParameterIndex:(NSUInteger)index withInitializer:(TyphoonInitializer *)initializer
{
    [NSException raise:NSInternalInconsistencyException format:@"InjectionByType is not supported as parameter injection"];
}

@end
