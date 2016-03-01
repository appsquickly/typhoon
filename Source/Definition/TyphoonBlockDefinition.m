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


#import "TyphoonBlockDefinition.h"
#import "TyphoonBlockDefinition+Internal.h"
#import "TyphoonDefinition+Infrastructure.h"
#import "TyphoonBlockDefinitionController.h"

@implementation TyphoonBlockDefinition

#pragma mark - Definitions

+ (id)withBlock:(TyphoonBlockDefinitionInitializerBlock)block
{
    return [self withInitializer:block injections:nil configuration:nil];
}

+ (id)withBlock:(TyphoonBlockDefinitionInitializerBlock)block configuration:(TyphoonDefinitionBlock)configuration
{
    return [self withInitializer:block injections:nil configuration:configuration];
}

+ (id)withInitializer:(TyphoonBlockDefinitionInitializerBlock)initializer
           injections:(TyphoonBlockDefinitionInjectionsBlock)injections
{
    return [self withInitializer:initializer injections:injections configuration:nil];
}

+ (id)withInitializer:(TyphoonBlockDefinitionInitializerBlock)initializer
           injections:(TyphoonBlockDefinitionInjectionsBlock)injections
        configuration:(TyphoonDefinitionBlock)configuration
{
    return [self withClass:[NSObject class] initializer:initializer injections:injections configuration:configuration];
}

+ (id)withClass:(Class)clazz block:(TyphoonBlockDefinitionInitializerBlock)block
{
    return [self withClass:clazz initializer:block injections:nil configuration:nil];
}

+ (id)withClass:(Class)clazz block:(TyphoonBlockDefinitionInitializerBlock)block
                             configuration:(TyphoonDefinitionBlock)configuration
{
    return [self withClass:clazz initializer:block injections:nil configuration:configuration];
}

+ (id)withClass:(Class)clazz injections:(TyphoonBlockDefinitionInjectionsBlock)injections
{
    return [self withClass:clazz initializer:nil injections:injections configuration:nil];
}

+ (id)withClass:(Class)clazz injections:(TyphoonBlockDefinitionInjectionsBlock)injections
                             configuration:(TyphoonDefinitionBlock)configuration
{
    return [self withClass:clazz initializer:nil injections:injections configuration:configuration];
}

+ (id)withClass:(Class)clazz initializer:(TyphoonBlockDefinitionInitializerBlock)initializer
                             injections:(TyphoonBlockDefinitionInjectionsBlock)injections
                             configuration:(TyphoonDefinitionBlock)configuration
{
    TyphoonBlockDefinitionController *controller = [TyphoonBlockDefinitionController currentController];
    
    switch (controller.route) {
        case TyphoonBlockDefinitionRouteInvalid:
        {
            [NSException raise:NSInternalInconsistencyException
                        format:@"TyphoonBlockDefinition cannot be used directly. You should only use it inside TyphoonAssembly methods."];
            return nil;
        }
            
        case TyphoonBlockDefinitionRouteConfiguration:
        {
            TyphoonBlockDefinition *definition = [[TyphoonBlockDefinition alloc] initWithClass:clazz key:nil];
            definition.hasInitializerBlock = initializer != nil;
            definition.hasInjectionsBlock = injections != nil;
            
            if (configuration) {
                configuration(definition);
            }
            
            return definition;
        }
            
        case TyphoonBlockDefinitionRouteInitializer:
        {
            if (!initializer) {
                [NSException raise:NSInternalInconsistencyException
                            format:@"TyphoonBlockDefinition is supposed to have an initializer block at this point."];
            }
            
            id instance = initializer();
            return instance;
        }
            
        case TyphoonBlockDefinitionRouteInjections:
        {
            if (injections && controller.instance) {
                injections(controller.instance);
            }
            return controller.instance;
        }
    }
}

#pragma mark - Overriden properties

- (TyphoonMethod *)initializer
{
    return self.hasInitializerBlock ? nil : [super initializer];
}

- (BOOL)isInitializerGenerated
{
    return self.hasInitializerBlock ? NO : [super isInitializerGenerated];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    TyphoonBlockDefinition *copy = [super copyWithZone:zone];
    copy->_hasInitializerBlock = _hasInitializerBlock;
    return copy;
}

@end
