//
//  TyphoonInjectionByComponentFactory.m
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 12.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonInjectionByComponentFactory.h"
#import "NSInvocation+TCFUnwrapValues.h"

@implementation TyphoonInjectionByComponentFactory

#pragma mark - Overrides

- (id)valueToInjectPropertyOnInstance:(id)instance withFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)args
{
    return factory;
}

- (void)setArgumentWithType:(TyphoonTypeDescriptor *)type onInvocation:(NSInvocation *)invocation withFactory:(TyphoonComponentFactory *)factory
                       args:(TyphoonRuntimeArguments *)args
{
    [invocation typhoon_setArgumentObject:factory atIndex:self.parameterIndex + 2];
}

- (id)copyWithZone:(NSZone *)zone
{
    TyphoonInjectionByComponentFactory *copied = [[TyphoonInjectionByComponentFactory alloc] init];
    [self copyBaseProperiesTo:copied];
    return copied;
}

@end
