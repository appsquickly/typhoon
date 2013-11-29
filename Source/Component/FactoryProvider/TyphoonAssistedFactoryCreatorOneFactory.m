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

#import "TyphoonAssistedFactoryCreatorOneFactory.h"
#import "TyphoonAssistedFactoryCreator+Private.h"

#include <objc/runtime.h>

@implementation TyphoonAssistedFactoryCreatorOneFactory

static SEL GuessFactoryMethodForProtocol(Protocol *protocol)
{
    // Lets create two sets: the property getters and all the methods (including
    // those getters). The difference must be only one, and must be our method.
    NSMutableSet *propertyNames = [NSMutableSet set];
    NSMutableSet *methodNames = [NSMutableSet set];

    unsigned int methodCount = 0;
    struct objc_method_description *methodDescriptions = protocol_copyMethodDescriptionList(protocol, YES, YES, &methodCount);
    for (unsigned int idx = 0; idx < methodCount; idx++)
    {
        struct objc_method_description methodDescription = methodDescriptions[idx];
        [methodNames addObject:NSStringFromSelector(methodDescription.name)];
    }
    free(methodDescriptions);

    unsigned int propertiesCount = 0;
    objc_property_t *properties = protocol_copyPropertyList(protocol, &propertiesCount);
    for (unsigned int idx = 0; idx < propertiesCount; idx++)
    {
        objc_property_t property = properties[idx];
        [propertyNames addObject:[NSString stringWithCString:property_getName(property) encoding:NSASCIIStringEncoding]];
    }
    free(properties);

    [methodNames minusSet:propertyNames];
    NSString *factoryMethod = [methodNames anyObject];

    return NSSelectorFromString(factoryMethod);
}

- (instancetype)initWithProtocol:(Protocol *)protocol factoryBlock:(id)factoryBlock
{
    return [super initWithProtocol:protocol factoryDefinitionProvider:^{
        SEL factoryMethod = GuessFactoryMethodForProtocol(protocol);

        TyphoonAssistedFactoryDefinition *factoryDefinition = [[TyphoonAssistedFactoryDefinition alloc] init];
        [factoryDefinition factoryMethod:factoryMethod body:factoryBlock];

        return factoryDefinition;
    }];
}

@end
