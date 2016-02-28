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


#import "TyphoonInject.h"
#import "TyphoonConfigPostProcessor+Internal.h"
#import "TyphoonBlockDefinitionController.h"
#import "TyphoonBlockDefinition.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonInjectionContext.h"
#import "TyphoonInjection.h"
#import "TyphoonInjections.h"

@implementation TyphoonInject

+ (id)byType:(id)classOrProtocol {
    return [self resultWithInjection:TyphoonInjectionWithType(classOrProtocol) definitionBlock:nil];
}

+ (id)byConfigKey:(NSString *)configKey {
    return [self byConfigKey:configKey type:nil];
}

+ (id)byConfigKey:(NSString *)configKey type:(id)classOrProtocol {
    id configInjection = TyphoonInjectionWithConfigKey(configKey);
    
    return [self resultWithInjection:configInjection definitionBlock:^id(TyphoonBlockDefinition *definition, TyphoonInjectionContext *context) {
        TyphoonInjectionContext *typedContext = [context copy];
        if (classOrProtocol) {
            typedContext.destinationType = [TyphoonTypeDescriptor descriptorWithType:classOrProtocol];
        }
        
        TyphoonComponentFactory *factory = context.factory;
        
        for (id<TyphoonDefinitionPostProcessor> postProcessor in factory.definitionPostProcessors) {
            if (![postProcessor isKindOfClass:[TyphoonConfigPostProcessor class]]) {
                continue;
            }
            
            TyphoonConfigPostProcessor *configPostProcessor = (TyphoonConfigPostProcessor *)postProcessor;
            
            if (![configPostProcessor shouldInjectDefinition:definition]) {
                continue;
            }
            
            id<TyphoonInjection> injection = [configPostProcessor injectionForConfigInjection:configInjection];
            
            if (!injection) {
                continue;
            }
            
            return [self valueToInjectWithInjection:injection context:typedContext];
        }
        
        [NSException raise:NSInternalInconsistencyException format:@"Value for config key %@ is not configured. Make sure that you applied TyphoonConfigPostProcessor.", configKey];
        
        return nil;
    }];
}

+ (id)resultWithInjection:(id<TyphoonInjection>)injection
          definitionBlock:(id (^)(TyphoonBlockDefinition *definition, TyphoonInjectionContext *context))definitionBlock
{
    TyphoonBlockDefinitionController *controller = [TyphoonBlockDefinitionController currentController];
    
    if (controller.buildingInstance) {
        if (definitionBlock) {
            return definitionBlock(controller.definition, controller.injectionContext);
        } else {
            return [self valueToInjectWithInjection:injection context:controller.injectionContext];
        }
    } else {
        return injection;
    }
}

+ (id)valueToInjectWithInjection:(id<TyphoonInjection>)injection context:(TyphoonInjectionContext *)context
{
    __block id result = nil;
    
    [injection valueToInjectWithContext:context completion:^(id value) {
        result = value;
    }];
    
    return result;
}

@end


@implementation NSObject (TyphoonBlockInjection)

+ (instancetype)typhoonInjectByType {
    return [TyphoonInject byType:[self class]];
}

+ (instancetype)typhoonInjectByConfigKey:(NSString *)configKey {
    return [TyphoonInject byConfigKey:configKey type:[self class]];
}

@end
