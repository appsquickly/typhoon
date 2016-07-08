//
//  PrototypePropertyInjected.m
//  Tests
//
//  Created by Cesar Estebanez Tascon on 05/09/13.
//
//

#import <XCTest/XCTest.h>
#import "PrototypePropertyInjected.h"

@implementation PrototypePropertyInjected


- (void)checkThatPropertyAHasPropertyBandC
{
    if (!self.propertyA) {
        [NSException raise:@"self.propertyA" format:@"self.propertyA is nil"];
    }
    if (!self.propertyA.propertyB) {
        [NSException raise:@"self.propertyA.propertyB" format:@"self.propertyA.propertyB is nil"];
    }
    if (!self.propertyA.propertyC) {
        [NSException raise:@"self.propertyA.propertyC" format:@"self.propertyA.propertyC is nil"];
    }
}

@end
