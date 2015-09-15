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
#import "TyphoonConfigPostProcessor.h"
#import "TyphoonResource.h"
#import "TyphoonMethod.h"
#import "TyphoonMethod+InstanceBuilder.h"
#import "TyphoonReferenceDefinition.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonRuntimeArguments.h"

@implementation TyphoonDefinition (Infrastructure)

@dynamic initializer, initializerGenerated, currentRuntimeArguments, key;

//-------------------------------------------------------------------------------------------
#pragma mark - Class Methods

+ (instancetype)withClass:(Class)clazz key:(NSString *)key
{
    return [[TyphoonDefinition alloc] initWithClass:clazz key:key];
}

+ (instancetype)configDefinitionWithName:(NSString *)fileName
{
    return [self withClass:[TyphoonConfigPostProcessor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(useResourceWithName:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:fileName];
        }];
        definition.key = [NSString stringWithFormat:@"%@-%@", NSStringFromClass(definition.class), fileName];
    }];
}

+ (instancetype)configDefinitionWithName:(NSString *)fileName bundle:(NSBundle *)fileBundle {
    return [self withClass:[TyphoonConfigPostProcessor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(useResourceWithName:bundle:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:fileName];
            [method injectParameterWith:fileBundle];
        }];
        definition.key = [NSString stringWithFormat:@"%@-%@", NSStringFromClass(definition.class), fileName];
    }];
}

+ (instancetype)configDefinitionWithPath:(NSString *)filePath
{
    return [self withClass:[TyphoonConfigPostProcessor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(useResourceAtPath:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:filePath];
        }];
        definition.key = [NSString stringWithFormat:@"%@-%@", NSStringFromClass(definition.class), [filePath lastPathComponent]];
    }];
}

- (BOOL)isCandidateForInjectedClass:(Class)clazz includeSubclasses:(BOOL)includeSubclasses
{
    BOOL result = NO;
    if (self.autoInjectionVisibility & TyphoonAutoInjectVisibilityByClass) {
        BOOL isSameClass = self.type == clazz;
        BOOL isSubclass = includeSubclasses && [self.type isSubclassOfClass:clazz];
        result = isSameClass || isSubclass;
    }
    return result;
}

- (BOOL)isCandidateForInjectedProtocol:(Protocol *)aProtocol
{
    BOOL result = NO;
    if (self.autoInjectionVisibility & TyphoonAutoInjectVisibilityByProtocol) {
        result = [self.type conformsToProtocol:aProtocol];
    }
    return result;

}


- (void)setProcessed:(BOOL)processed
{
    _processed = processed;
}

- (BOOL)processed
{
    return _processed;
}

@end
