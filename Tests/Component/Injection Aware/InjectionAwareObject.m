//
//  InjectionAwareObject.m
//  Tests
//
//  Created by Robert Gilliam on 8/4/13.
//  Copyright (c) 2013 Jasper Blues. All rights reserved.
//

#import "InjectionAwareObject.h"

@implementation InjectionAwareObject {
    id assembly;
}

@synthesize assembly;

- (void)setAssembly:(id)theAssembly
{
    assembly = theAssembly;
}

@end
