////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "TyphoonPropertyInjectedByFactoryReference.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonComponentFactory+InstanceBuilder.h"

@implementation TyphoonPropertyInjectedByFactoryReference

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (instancetype)initWithName:(NSString *)name reference:(NSString *)reference keyPath:(NSString *)keyPath
{
    self = [super initWithName:name reference:reference];
    if (self) {
        _keyPath = keyPath;
    }
    return self;
}

/* ====================================================================================================================================== */
#pragma mark - Overridden Methods

- (id)withFactory:(TyphoonComponentFactory *)factory computeValueToInjectOnInstance:(id)instance
{
    [factory evaluateCircularDependency:self.reference propertyName:self.name instance:instance];

    if (![factory propertyIsCircular:self onInstance:instance]) {
        id factoryReference = [factory componentForKey:self.reference];
        return [factoryReference valueForKeyPath:self.keyPath];
    }
    return nil;
}

/* ====================================================================================================================================== */
#pragma mark - Utility Methods

- (id)copyWithZone:(NSZone *)zone
{
    return [[TyphoonPropertyInjectedByFactoryReference alloc]
        initWithName:[self.name copy] reference:[self.reference copy] keyPath:[self.keyPath copy]];
}

@end
