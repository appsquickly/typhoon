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
#import "TyphoonDefinitionBase+Internal.h"
#import "TyphoonBlockDefinitionController.h"

@implementation TyphoonBlockDefinition

+ (id)withClass:(Class)clazz initializer:(TyphoonBlockDefinitionInitializerBlock)initializer
                              injections:(TyphoonBlockDefinitionInjectionsBlock)injections
                           configuration:(TyphoonBlockDefinitionBlock)configuration
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
            configuration(definition);
            return definition;
        }
            
        case TyphoonBlockDefinitionRouteInitializer:
        {
            id instance = initializer();
            return instance;
        }
            
        case TyphoonBlockDefinitionRouteInjections:
        {
            if (controller.instance) {
                injections(controller.instance);
            }
            return controller.instance;
        }
    }
}

@end
