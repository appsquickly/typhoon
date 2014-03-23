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
    TyphoonTypeDescriptor *type = [instance typhoon_typeForPropertyWithName:self.propertyName];
    TyphoonDefinition *definition = [factory definitionForType:[type classOrProtocol]];
    
    if (instance) {
        [factory evaluateCircularDependency:definition.key propertyName:self.propertyName instance:instance args:args];
        if ([factory isCircularPropertyWithName:self.propertyName onInstance:instance]) {
            return nil;
        }
    }

    return [factory componentForKey:definition.key];
}

- (void)setParameterIndex:(NSUInteger)index withInitializer:(TyphoonMethod *)initializer
{
    [NSException raise:NSInternalInconsistencyException format:@"InjectionByType is not supported as parameter injection"];
}

@end
