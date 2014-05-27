//
//  TyphoonInjectionByFactoryReference.m
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 12.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonInjectionByFactoryReference.h"
#import "TyphoonComponentFactory+InstanceBuilder.h"
#import "TyphoonCallStack.h"
#import "TyphoonStackElement.h"
#import "NSInvocation+TCFUnwrapValues.h"

@implementation TyphoonInjectionByFactoryReference

- (instancetype)initWithReference:(NSString *)reference args:(TyphoonRuntimeArguments *)referenceArguments keyPath:(NSString *)keyPath
{
    self = [super initWithReference:reference args:referenceArguments];
    if (self) {
        _keyPath = keyPath;
    }
    return self;
}

#pragma mark - Overrides

- (id)copyWithZone:(NSZone *)zone
{
    TyphoonInjectionByFactoryReference *copied =
        [[TyphoonInjectionByFactoryReference alloc] initWithReference:self.reference args:self.referenceArguments keyPath:self.keyPath];
    [self copyBasePropertiesTo:copied];
    return copied;
}

- (id)resolveReferenceWithContext:(TyphoonInjectionContext *)context
{
    id referenceInstance = [super resolveReferenceWithContext:context];
    
    return [referenceInstance valueForKeyPath:self.keyPath];
}

@end
