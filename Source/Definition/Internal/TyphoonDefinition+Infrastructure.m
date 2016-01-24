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


#import "TyphoonLinkerCategoryBugFix.h"

TYPHOON_LINK_CATEGORY(TyphoonDefinition_Infrastructure)

#import "TyphoonDefinition+Infrastructure.h"
#import "TyphoonDefinitionBase+Infrastructure.h"
#import "TyphoonDefinition+Namespacing.h"
#import "TyphoonConfigPostProcessor.h"
#import "TyphoonResource.h"
#import "TyphoonMethod.h"
#import "TyphoonMethod+InstanceBuilder.h"
#import "TyphoonReferenceDefinition.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonRuntimeArguments.h"

@implementation TyphoonDefinition (Infrastructure)

//-------------------------------------------------------------------------------------------
#pragma mark - Class Methods

+ (instancetype)withConfigName:(NSString *)fileName {
    return [self withClass:[TyphoonConfigPostProcessor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(useResourceWithName:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:fileName];
        }];
        definition.key = [NSString stringWithFormat:@"%@-%@", NSStringFromClass(definition.class), fileName];
    }];
}

+ (instancetype)withConfigName:(NSString *)fileName bundle:(NSBundle *)fileBundle {
    return [self withClass:[TyphoonConfigPostProcessor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(useResourceWithName:bundle:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:fileName];
            [method injectParameterWith:fileBundle];
        }];
        definition.key = [NSString stringWithFormat:@"%@-%@", NSStringFromClass(definition.class), fileName];
    }];
}

+ (instancetype)withConfigPath:(NSString *)filePath {
    return [self withClass:[TyphoonConfigPostProcessor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(useResourceAtPath:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:filePath];
        }];
        definition.key = [NSString stringWithFormat:@"%@-%@", NSStringFromClass(definition.class), [filePath lastPathComponent]];
    }];
}

#pragma mark - Deprecated methods

+ (instancetype)configDefinitionWithName:(NSString *)fileName
{
    TyphoonDefinition *configDefinition = [self withConfigName:fileName];
    [configDefinition applyGlobalNamespace];
    return configDefinition;
}

+ (instancetype)configDefinitionWithName:(NSString *)fileName bundle:(NSBundle *)fileBundle {
    TyphoonDefinition *configDefinition = [self withConfigName:fileName bundle:fileBundle];
    [configDefinition applyGlobalNamespace];
    return configDefinition;
}

+ (instancetype)configDefinitionWithPath:(NSString *)filePath
{
    TyphoonDefinition *configDefinition = [self withConfigPath:filePath];
    [configDefinition applyGlobalNamespace];
    return configDefinition;
}

@end
