//
//  TyphoonInjectionByRuntimeArgument.m
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 12.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonInjectionByRuntimeArgument.h"
#import "TyphoonRuntimeArguments.h"
#import "NSInvocation+TCFUnwrapValues.h"

@implementation TyphoonInjectionByRuntimeArgument

- (instancetype)initWithArgumentIndex:(NSUInteger)index
{
    self = [super init];
    if (self) {
        _runtimeArgumentIndex = index;
    }
    return self;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    [NSException raise:NSInvalidArgumentException
        format:@"You can't call a method on the runtime argument being passed in. It has to be passed in as-is"];
    return nil;
}

#pragma mark - Overrides

- (id)valueToInjectPropertyOnInstance:(id)instance withFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)args
{
    return [args argumentValueAtIndex:self.runtimeArgumentIndex];
}

- (void)setArgumentWithType:(TyphoonTypeDescriptor *)type onInvocation:(NSInvocation *)invocation withFactory:(TyphoonComponentFactory *)factory
                       args:(TyphoonRuntimeArguments *)args
{
    id runtimeArgument = [args argumentValueAtIndex:self.runtimeArgumentIndex];
    [invocation typhoon_setArgumentObject:runtimeArgument atIndex:self.parameterIndex + 2];
}

- (id)copyWithZone:(NSZone *)zone
{
    TyphoonInjectionByRuntimeArgument *copied = [[TyphoonInjectionByRuntimeArgument alloc] initWithArgumentIndex:self.runtimeArgumentIndex];
    [self copyBaseProperiesTo:copied];
    return copied;
}

@end

