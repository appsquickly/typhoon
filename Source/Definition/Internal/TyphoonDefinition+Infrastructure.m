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
#import "TyphoonIntrospectionUtils.h"

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

+ (instancetype)configDefinitionWithPath:(NSString *)filePath
{
    return [self withClass:[TyphoonConfigPostProcessor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(useResourceAtPath:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:filePath];
        }];
        definition.key = [NSString stringWithFormat:@"%@-%@", NSStringFromClass(definition.class), [filePath lastPathComponent]];
    }];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction

- (id)initWithClass:(Class)clazz key:(NSString *)key
{
    self = [super init];
    if (self) {
        _type = clazz;
        _injectedProperties = [[NSMutableSet alloc] init];
        _injectedMethods = [[NSMutableSet alloc] init];
        _key = [key copy];
        _scope = TyphoonScopeObjectGraph;
        self.autoInjectionVisibility = TyphoonAutoInjectVisibilityDefault;
        [self validateRequiredParametersAreSet];
    }
    return self;
}

- (id)init
{
    return [self initWithClass:nil key:nil];
}

- (BOOL)matchesAutoInjectionWithType:(id)classOrProtocol includeSubclasses:(BOOL)includeSubclasses
{
    BOOL result = NO;

    BOOL isClass = IsClass(classOrProtocol);
    BOOL isProtocol = IsProtocol(classOrProtocol);

    if (isClass && self.autoInjectionVisibility & TyphoonAutoInjectVisibilityByClass) {
        BOOL isSameClass = self.type == classOrProtocol;
        BOOL isSubclass = includeSubclasses && [self.type isSubclassOfClass:classOrProtocol];
        result = isSameClass || isSubclass;
    }
    else if (isProtocol && self.autoInjectionVisibility & TyphoonAutoInjectVisibilityByProtocol) {
        result = [self.type conformsToProtocol:classOrProtocol];
    }

    return result;
}


//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods

- (void)validateRequiredParametersAreSet
{
    if (_type == nil) {
        [NSException raise:NSInvalidArgumentException format:@"Property 'clazz' is required."];
    }
}

@end
