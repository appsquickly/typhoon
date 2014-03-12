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
#import "TyphoonInjectionByComponentFactory.h"
#import "TyphoonInjectionByType.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonTypeDescriptor.h"
#import "TyphoonAssembly.h"

@implementation TyphoonFactoryPropertyInjectionPostProcessor

/* ====================================================================================================================================== */
#pragma mark - Protocol Methods

- (void)postProcessComponentFactory:(TyphoonComponentFactory *)factory
{
    for (TyphoonDefinition *definition in [factory registry]) {
        for (TyphoonInjectionByType *typeInjection in [definition propertiesInjectedByType]) {
            if ([self shouldReplaceInjectionByType:typeInjection withFactoryInjectionInDefinition:definition]) {
                [self replaceTypePropertyInjection:typeInjection withFactoryInjectionInDefinition:definition];
            }
        }
    }
}

/* ====================================================================================================================================== */
#pragma mark - Instance Methods

- (BOOL) shouldReplaceInjectionByType:(TyphoonInjectionByType *)propertyInjection withFactoryInjectionInDefinition:(TyphoonDefinition *)definition
{
    BOOL isFactoryClass = NO;
    
    TyphoonTypeDescriptor *type = [TyphoonIntrospectionUtils typeForPropertyWithName:propertyInjection.propertyName inClass:definition.type];
    
    if (type.typeBeingDescribed) {
        isFactoryClass = [type.typeBeingDescribed isSubclassOfClass:[TyphoonComponentFactory class]];
    }
    
    return isFactoryClass;
}

- (void) replaceTypePropertyInjection:(TyphoonInjectionByType *)typeInjection withFactoryInjectionInDefinition:(TyphoonDefinition *)definition
{
    NSString *name = typeInjection.propertyName;
    [definition removeInjectedProperty:typeInjection];
    TyphoonInjectionByComponentFactory *newInjection = [[TyphoonInjectionByComponentFactory alloc] init];
    [newInjection setPropertyName:name];
    [definition addInjectedProperty:newInjection];
}

@end
