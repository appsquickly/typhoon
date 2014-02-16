//
//  CROSingletonB.m
//  Tests
//
//  Created by Cesar Estebanez Tascon on 11/09/13.
//
//

#import "CROSingletonB.h"

@implementation CROSingletonB

- (id)initWithPrototypeB:(CROPrototypeB *)prototypeB
{
    self = [super init];
    if (self) {
        _prototypeB = prototypeB;
    }
    return self;
}
@end
