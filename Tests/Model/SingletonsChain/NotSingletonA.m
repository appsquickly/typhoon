//
//  NotSingletonA.m
//  CircularTyphoon
//
//  Created by Cesar Estebanez Tascon on 09/08/13.
//  Copyright (c) 2013 cestebanez. All rights reserved.
//

#import "NotSingletonA.h"

@implementation NotSingletonA

- (id)initWithSingletonB:(SingletonB *)singletonB
{
    self = [super init];
    if (self) {
        _dependencyOnB = singletonB;
    }
    return self;
}

@end
