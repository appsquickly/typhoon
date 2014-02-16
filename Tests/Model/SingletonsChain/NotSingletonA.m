//
//  SingletonC.m
//  Tests
//
//  Created by Cesar Estebanez Tascon on 10/08/13.
//
//

#import "NotSingletonA.h"

@implementation NotSingletonA

- (id)initWithSingletonA:(SingletonA *)singletonA
{
    self = [super init];
    if (self) {
        _dependencyOnA = singletonA;
    }
    return self;
}

@end
