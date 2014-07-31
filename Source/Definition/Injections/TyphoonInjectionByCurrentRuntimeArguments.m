//
// Created by Aleksey Garbarev on 31.07.14.
// Copyright (c) 2014 typhoonframework.org. All rights reserved.
//

#import "TyphoonInjectionByCurrentRuntimeArguments.h"


@implementation TyphoonInjectionByCurrentRuntimeArguments

- (void)valueToInjectWithContext:(TyphoonInjectionContext *)context completion:(TyphoonInjectionValueBlock)result
{
    result(context.args);
}


- (id)copyWithZone:(NSZone *)zone
{
    id copied = [[self class] new];
    [self copyBasePropertiesTo:copied];
    return copied;
}

@end