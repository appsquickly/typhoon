////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "TyphoonParentReferenceHydratingPostProcessor.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonDefinition.h"
#import "TyphoonComponentFactory+TyphoonDefinitionRegisterer.h"
#import "TyphoonDefinition+Infrastructure.h"

@implementation TyphoonParentReferenceHydratingPostProcessor

- (void)postProcessDefinitionsInFactory:(TyphoonComponentFactory *)factory
{
    [factory.registry enumerateObjectsUsingBlock:^(TyphoonDefinition *definition, NSUInteger idx, BOOL *stop) {
        if (definition.parent) {
            TyphoonDefinition *parentDefinition = [factory definitionForKey:[(TyphoonDefinition *)definition.parent key]];
            [definition setParent:parentDefinition];
        }
    }];
}


@end