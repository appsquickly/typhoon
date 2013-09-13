//
//  CROPrototypeA.m
//  Tests
//
//  Created by Cesar Estebanez Tascon on 11/09/13.
//
//

#import "CROPrototypeA.h"

@implementation CROPrototypeA

- (id)initWithCROPrototypeB:(CROPrototypeB *)prototypeB
{
    self = [super init];
    if (self) {
        _prototypeB = prototypeB;
    }
    return self;
}

@end
