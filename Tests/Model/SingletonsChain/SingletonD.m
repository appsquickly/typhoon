//
//  SingletonD.m
//  Tests
//
//  Created by Cesar Estebanez Tascon on 10/08/13.
//
//

#import "SingletonD.h"

@implementation SingletonD

- (id)initWithSingletonB:(SingletonB *)singletonB
{
    self = [super init];
    if (self) {
        _dependencyOnB = singletonB;
    }
    return self;
}

@end
