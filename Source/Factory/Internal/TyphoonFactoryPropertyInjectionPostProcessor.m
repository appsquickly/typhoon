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
