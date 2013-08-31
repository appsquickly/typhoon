//
//  InjectionAwareAssembly.m
//  Tests
//
//  Created by Robert Gilliam on 8/4/13.
//  Copyright (c) 2013 Jasper Blues. All rights reserved.
//

#import "InjectionAwareAssembly.h"
#import <TyphoonDefinition.h>
#import "InjectionAwareObject.h"

@implementation InjectionAwareAssembly

- (id)injectionAwareObject;
{
    return [TyphoonDefinition withClass:[InjectionAwareObject class]];
}

@end
