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

#import <Foundation/Foundation.h>
#import "TyphoonDefinitionPostProcessor.h"
#import "TyphoonInjectionByType.h"
#import "TyphoonDefinition.h"

/**
 * Replaces property injections by-type with injectuins by-componentFactory when property type subclass of TyphoonComponentFactory
 */
@interface TyphoonFactoryPropertyInjectionPostProcessor : NSObject <TyphoonDefinitionPostProcessor>

/* Method to override in subclasses */
- (BOOL)shouldReplaceInjectionByType:(TyphoonInjectionByType *)propertyInjection
    withFactoryInjectionInDefinition:(TyphoonDefinition *)definition;

@end
