//
//  PrototypeInitInjected.m
//  Tests
//
//  Created by Cesar Estebanez Tascon on 05/09/13.
//
//

#import "PrototypeInitInjected.h"

@implementation PrototypeInitInjected

- (id)initWithDependency:(PrototypePropertyInjected *)prototypePropertyInjected;
{
    self = [super init];
    if (self) {
        _prototypePropertyInjected = prototypePropertyInjected;
    }
    return self;
}

@end
