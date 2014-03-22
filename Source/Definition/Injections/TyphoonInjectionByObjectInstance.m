//
//  TyphoonInjectionByObjectInstance.m
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 12.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonInjectionByObjectInstance.h"
#import "NSInvocation+TCFUnwrapValues.h"

@implementation TyphoonInjectionByObjectInstance

- (instancetype)initWithObjectInstance:(id)objectInstance
{
    self = [super init];
    if (self) {
        _objectInstance = objectInstance;
    }
    return self;
}

#pragma mark - Overrides

- (id)copyWithZone:(NSZone *)zone
{
    TyphoonInjectionByObjectInstance *copied = [[TyphoonInjectionByObjectInstance alloc] initWithObjectInstance:self.objectInstance];
    [self copyBaseProperiesTo:copied];
    return copied;
}

- (id)valueToInjectPropertyOnInstance:(id)instance withFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)args
{
    return _objectInstance;
}

- (void)setArgumentWithType:(TyphoonTypeDescriptor *)type onInvocation:(NSInvocation *)invocation withFactory:(TyphoonComponentFactory *)factory
                       args:(TyphoonRuntimeArguments *)args
{
    [invocation typhoon_setArgumentObject:_objectInstance atIndex:self.parameterIndex + 2];
}


@end
