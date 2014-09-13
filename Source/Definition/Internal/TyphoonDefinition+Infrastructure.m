////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
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

@implementation TyphoonDefinition (Infrastructure)

@dynamic initializer, initializerGenerated, currentRuntimeArguments, key;

/* ====================================================================================================================================== */
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

+ (instancetype)configDefinitionWithPath:(NSString *)filePath
{
    return [self withClass:[TyphoonConfigPostProcessor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(useResourceAtPath:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:filePath];
        }];
        definition.key = [NSString stringWithFormat:@"%@-%@", NSStringFromClass(definition.class), [filePath lastPathComponent]];
    }];
}

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)initWithClass:(Class)clazz key:(NSString *)key
{
    return [self initWithClass:clazz key:key factoryComponent:nil];
}

- (id)init
{
    return [self initWithClass:nil key:nil factoryComponent:nil];
}

- (id)initWithClass:(Class)clazz key:(NSString *)key factoryComponent:(NSString *)factoryComponent
{
    self = [super init];
    if (self) {
        _type = clazz;
        _injectedProperties = [[NSMutableSet alloc] init];
        _injectedMethods = [[NSMutableSet alloc] init];
        self.key = [key copy];
        self.scope = TyphoonScopeObjectGraph;
        self.autoInjectionVisibility = TyphoonAutoInjectVisibilityDefault;
        if (factoryComponent) {
            _factory = [TyphoonReferenceDefinition definitionReferringToComponent:factoryComponent];
        }
        [self validateRequiredParametersAreSet];
    }
    return self;
}

/* ====================================================================================================================================== */
#pragma mark - Private Methods

- (void)validateRequiredParametersAreSet
{
    if (_type == nil) {
        [NSException raise:NSInvalidArgumentException format:@"Property 'clazz' is required."];
    }
}

@end
