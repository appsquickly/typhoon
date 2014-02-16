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



#import "TyphoonPropertyInjectedByType.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonTypeDescriptor.h"
#import "TyphoonComponentFactory+InstanceBuilder.h"
#import "TyphoonDefinition.h"
#import "TyphoonAssembly.h"

@implementation TyphoonPropertyInjectedByType


/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}

/* ====================================================================================================================================== */
#pragma mark - Overridden Methods

- (id)withFactory:(TyphoonComponentFactory *)factory computeValueToInjectOnInstance:(id)instance
{
    id value = nil;
    
    TyphoonTypeDescriptor *type = [instance typeForPropertyWithName:self.name];
    TyphoonDefinition *definition = [factory definitionForType:[type classOrProtocol]];
    
    [factory evaluateCircularDependency:definition.key propertyName:self.name instance:instance];
    if (![factory propertyIsCircular:self onInstance:instance]) {
        value = [factory componentForKey:definition.key];
    }

    return value;
}

/* ====================================================================================================================================== */
#pragma mark - Utility Methods

- (id)copyWithZone:(NSZone *)zone
{
    return [[TyphoonPropertyInjectedByType alloc] initWithName:[self.name copy]];
}

@end
