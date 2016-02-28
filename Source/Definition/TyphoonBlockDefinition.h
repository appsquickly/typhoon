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

typedef id (^TyphoonBlockDefinitionInitializerBlock)();

typedef void (^TyphoonBlockDefinitionInjectionsBlock)(id instance);


@interface TyphoonBlockDefinition : TyphoonDefinition

+ (id)withBlock:(TyphoonBlockDefinitionInitializerBlock)block;

+ (id)withBlock:(TyphoonBlockDefinitionInitializerBlock)block configuration:(TyphoonDefinitionBlock)configuration;

+ (id)withInitializer:(TyphoonBlockDefinitionInitializerBlock)initializer
           injections:(TyphoonBlockDefinitionInjectionsBlock)injections;

+ (id)withInitializer:(TyphoonBlockDefinitionInitializerBlock)initializer
           injections:(TyphoonBlockDefinitionInjectionsBlock)injections
        configuration:(TyphoonDefinitionBlock)configuration;

+ (id)withClass:(Class)clazz block:(TyphoonBlockDefinitionInitializerBlock)block;

+ (id)withClass:(Class)clazz block:(TyphoonBlockDefinitionInitializerBlock)block
                             configuration:(TyphoonDefinitionBlock)configuration;

+ (id)withClass:(Class)clazz injections:(TyphoonBlockDefinitionInjectionsBlock)injections;

+ (id)withClass:(Class)clazz injections:(TyphoonBlockDefinitionInjectionsBlock)injections
                             configuration:(TyphoonDefinitionBlock)configuration;

+ (id)withClass:(Class)clazz initializer:(TyphoonBlockDefinitionInitializerBlock)initializer
                             injections:(TyphoonBlockDefinitionInjectionsBlock)injections
                             configuration:(TyphoonDefinitionBlock)configuration;

@end
