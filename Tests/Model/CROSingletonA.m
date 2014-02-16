//
//  SingletonA.m
//  Tests
//
//  Created by Cesar Estebanez Tascon on 11/09/13.
//
//

#import "CROSingletonA.h"

@implementation CROSingletonA

- (id)initWithPrototypeB:(id)b
{
    self = [super init];
    if (self) {
        self.prototypeB = b;
    }
    return self;
}

@end
