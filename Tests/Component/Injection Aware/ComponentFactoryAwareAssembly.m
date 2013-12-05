//
//  ComponentFactoryAwareAssembly.m
//  Tests
//
//  Created by Robert Gilliam on 8/4/13.
//  Copyright (c) 2013 Jasper Blues. All rights reserved.
//

#import "ComponentFactoryAwareAssembly.h"
#import <TyphoonDefinition.h>
#import "ComponentFactoryAwareObject.h"

@implementation ComponentFactoryAwareAssembly

- (id)injectionAwareObject;
{
    return [TyphoonDefinition withClass:[ComponentFactoryAwareObject class]];
}

@end
