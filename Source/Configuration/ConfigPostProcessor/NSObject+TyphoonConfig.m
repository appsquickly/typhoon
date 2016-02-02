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


#import "NSObject+TyphoonConfig.h"
#import "TyphoonConfigPostProcessor.h"
#import "TyphoonBlockDefinitionController.h"
#import "TyphoonBlockDefinition.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonInjectionContext.h"

@interface TyphoonConfigPostProcessor ()

- (BOOL)shouldInjectDefinition:(TyphoonDefinition *)definition;

- (id)valueForConfigKey:(NSString *)configKey type:(Class)type typeConverterRegistry:(TyphoonTypeConverterRegistry *)typeConverterRegistry;

@end


@implementation NSObject (TyphoonConfig)

+ (instancetype)typhoonForConfigKey:(NSString *)configKey
{
    TyphoonBlockDefinitionController *controller = [TyphoonBlockDefinitionController currentController];
    if (!controller.buildingInstance) {
        return TyphoonConfig(configKey);
    }
    
    TyphoonComponentFactory *factory = controller.injectionContext.factory;
    
    for (id<TyphoonDefinitionPostProcessor> postProcessor in factory.definitionPostProcessors) {
        if (![postProcessor isKindOfClass:[TyphoonConfigPostProcessor class]]) {
            continue;
        }
        
        TyphoonConfigPostProcessor *configPostProcessor = (TyphoonConfigPostProcessor *)postProcessor;
        
        if (![configPostProcessor shouldInjectDefinition:controller.definition]) {
            continue;
        }
                
        id value = [configPostProcessor valueForConfigKey:configKey
                                                     type:[self class]
                                    typeConverterRegistry:factory.typeConverterRegistry];
        if (value) {
            return value;
        }
    }
    
    [NSException raise:NSInternalInconsistencyException format:@"Value for config key %@ is not configured. Make sure that you applied TyphoonConfigPostProcessor.", configKey];
    
    return nil;
}

@end
