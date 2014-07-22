//
// Created by Aleksey Garbarev on 22.07.14.
// Copyright (c) 2014 typhoonframework.org. All rights reserved.
//

#import "Mock.h"


@implementation Mock
{

}

- (instancetype)initWithObject:(id)object clazz:(Class)clazz block:(void (^)())block
{
    self = [super init];
    if (self) {
        self.object = object;
        self.clazz = clazz;
        self.block = block;
    }

    return self;
}

@end