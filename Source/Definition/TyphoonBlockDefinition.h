////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2016, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "TyphoonDefinition.h"

@class TyphoonBlockDefinition;

typedef id (^TyphoonBlockDefinitionInitializerBlock)();

typedef void (^TyphoonBlockDefinitionInjectionsBlock)(id instance);

typedef void (^TyphoonBlockDefinitionBlock)(TyphoonBlockDefinition *definition);


@interface TyphoonBlockDefinition : TyphoonDefinition

+ (id)withClass:(Class)clazz initializer:(TyphoonBlockDefinitionInitializerBlock)initializer
                              injections:(TyphoonBlockDefinitionInjectionsBlock)injections
                           configuration:(TyphoonBlockDefinitionBlock)configuration;

@end
