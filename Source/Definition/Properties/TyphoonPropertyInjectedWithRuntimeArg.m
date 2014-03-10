//
//  TyphoonPropertyInjectedWithRuntimeArg.m
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 10.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonPropertyInjectedWithRuntimeArg.h"

@implementation TyphoonPropertyInjectedWithRuntimeArg

- (instancetype)initWithArgumentIndex:(NSUInteger)index
{
    self = [super init];
    if (self) {
        self.index = index;
    }
    return self;
}

- (id)withFactory:(TyphoonComponentFactory *)factory computeValueToInjectOnInstance:(id)instance args:(TyphoonRuntimeArguments *)args
{
    return [args argumentValueAtIndex:self.index];
}

@end
