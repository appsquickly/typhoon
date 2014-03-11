//
//  TyphoonInjectionByComponentFactory.m
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 12.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonInjectionByComponentFactory.h"

@implementation TyphoonInjectionByComponentFactory

#pragma mark - Overrides

- (id)valueToInjectPropertyOnInstance:(id)instance withFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)args
{
    return factory;
}

- (void)setArgumentOnInvocation:(NSInvocation *)invocation withFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)args
{
    [self setObject:factory forInvocation:invocation];
}

- (id)copyWithZone:(NSZone *)zone
{
    TyphoonInjectionByComponentFactory *copied = [[TyphoonInjectionByComponentFactory alloc] init];
    [self copyBaseProperiesTo:copied];
    return copied;
}

@end
