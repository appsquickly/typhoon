//
//  TyphoonFactoryPropertyInjectionPostProcessor.m
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 16.02.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonFactoryPropertyInjectionPostProcessor.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonDefinition.h"
#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonPropertyInjectedByType.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonTypeDescriptor.h"
#import "TyphoonAssembly.h"
#import "TyphoonPropertyInjectedByComponentFactory.h"

@implementation TyphoonFactoryPropertyInjectionPostProcessor

/* ====================================================================================================================================== */
#pragma mark - Protocol Methods

- (void)postProcessComponentFactory:(TyphoonComponentFactory *)factory
{
    for (TyphoonDefinition *definition in [factory registry]) {
        for (TyphoonPropertyInjectedByType *typeInjection in [definition propertiesInjectedByType]) {
            if ([self shouldReplaceInjectionByType:typeInjection withFactoryInjectionInDefinition:definition]) {
                [self replaceTypePropertyInjection:typeInjection withFactoryInjectionInDefinition:definition];
            }
        }
    }
}

/* ====================================================================================================================================== */
#pragma mark - Instance Methods

- (BOOL) shouldReplaceInjectionByType:(TyphoonPropertyInjectedByType *)propertyInjection withFactoryInjectionInDefinition:(TyphoonDefinition *)definition
{
    BOOL isFactoryClass = NO;
    
    TyphoonTypeDescriptor *type = [TyphoonIntrospectionUtils typeForPropertyWithName:propertyInjection.name inClass:definition.type];
    
    if (type.typeBeingDescribed) {
        isFactoryClass = [type.typeBeingDescribed isSubclassOfClass:[TyphoonComponentFactory class]];
    }
    
    return isFactoryClass;
}

- (void) replaceTypePropertyInjection:(TyphoonPropertyInjectedByType *)typeInjection withFactoryInjectionInDefinition:(TyphoonDefinition *)definition
{
    NSString *name = typeInjection.name;
    [definition removeInjectedProperty:typeInjection];
    [definition addInjectedProperty:[[TyphoonPropertyInjectedByComponentFactory alloc] initWithName:name]];
}

@end
