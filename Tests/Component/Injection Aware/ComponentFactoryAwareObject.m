//
//  ComponentFactoryAwareObject.m
//  Tests
//
//  Created by Robert Gilliam on 8/4/13.
//  Copyright (c) 2013 Jasper Blues. All rights reserved.
//

#import "ComponentFactoryAwareObject.h"

@implementation ComponentFactoryAwareObject
{
    id factory;
}

@synthesize factory;

- (void)setFactory:(id)theFactory
{
    factory = theFactory;
}

@end
