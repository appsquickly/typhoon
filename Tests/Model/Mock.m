////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

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