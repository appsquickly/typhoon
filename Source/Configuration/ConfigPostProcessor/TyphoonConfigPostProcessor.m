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


#import "TyphoonConfigPostProcessor.h"
#import "TyphoonResource.h"
#import "TyphoonDefinition.h"
#import "TyphoonInjectionByConfig.h"
#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonPropertyStyleConfiguration.h"
#import "TyphoonInjections.h"
#import "TyphoonJsonStyleConfiguration.h"
#import "TyphoonBundleResource.h"
#import "TyphoonPlistStyleConfiguration.h"
#import "TyphoonInjectionByReference.h"
#import "TyphoonRuntimeArguments.h"

static NSMutableDictionary *propertyPlaceholderRegistry;

@implementation TyphoonConfigPostProcessor
{
    NSDictionary *_configs;
}



//-------------------------------------------------------------------------------------------
#pragma mark - Class Methods

+ (TyphoonConfigPostProcessor *)postProcessor
{
    return [[[self class] alloc] init];
}

+ (void)registerConfigurationClass:(Class)configClass forExtension:(NSString *)typeExtension
{
    @synchronized (self) {
        if (!propertyPlaceholderRegistry) {
            propertyPlaceholderRegistry = [NSMutableDictionary new];
        }
        propertyPlaceholderRegistry[typeExtension] = configClass;
    }
}

+ (NSArray *)availableExtensions
{
    return [propertyPlaceholderRegistry allKeys];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction

- (id)init
{
    self = [super init];
    if (self) {
        NSMutableDictionary *mutableConfigs = [[NSMutableDictionary alloc] initWithCapacity:[propertyPlaceholderRegistry count]];
        [propertyPlaceholderRegistry enumerateKeysAndObjectsUsingBlock:^(NSString *key, id configClass, BOOL *stop) {
            mutableConfigs[key] = [configClass new];
        }];
        _configs = mutableConfigs;
    }
    return self;
}

+ (void)initialize
{
    [super initialize];

    [self registerConfigurationClass:[TyphoonJsonStyleConfiguration class] forExtension:@"json"];
    [self registerConfigurationClass:[TyphoonPropertyStyleConfiguration class] forExtension:@"properties"];
    [self registerConfigurationClass:[TyphoonPlistStyleConfiguration class] forExtension:@"plist"];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods

- (void)useResourceWithName:(NSString *)name
{
    [self useResource:[TyphoonBundleResource withName:name inBundle:[NSBundle mainBundle]]
        withExtension:[name pathExtension]];
}

- (void)useResourceAtPath:(NSString *)path
{
    [self useResource:[TyphoonPathResource withPath:path] withExtension:[path pathExtension]];
}

- (void)useResource:(id<TyphoonResource>)resource withExtension:(NSString *)typeExtension
{
    id<TyphoonConfiguration> config = _configs[typeExtension];
    [config appendResource:resource];
}

- (id)configurationValueForKey:(NSString *)key
{
    __block id value = nil;
#if DEBUG
    __block NSString *foundExtension = nil;
#endif
    [_configs enumerateKeysAndObjectsUsingBlock:^(NSString *extension, id<TyphoonConfiguration> config, BOOL *stop) {
        id object = [config objectForKey:key];
#if !DEBUG
        if (object) {
            value = object;
            *stop = YES;
        }
#else
        if (object) {
            if (value) {
                [NSException raise:NSInternalInconsistencyException
                    format:@"Value for key %@ already exists in %@ config", key, foundExtension];
            } else {
                value = object;
                foundExtension = extension;
            }
        }
#endif
    }];

    return value;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Protocol Methods

- (void)postProcessDefinitionsInFactory:(TyphoonComponentFactory *)factory
{
    for (TyphoonDefinition *definition in [factory registry]) {
        [self configureInjectionsInDefinition:definition];
        [self configureInjectionsInRuntimeArgumentsInDefinition:definition];
    }
}

- (void)configureInjectionsInDefinition:(TyphoonDefinition *)definition
{
    [definition enumerateInjectionsOfKind:[TyphoonInjectionByConfig class] options:TyphoonInjectionsEnumerationOptionAll
        usingBlock:^(TyphoonInjectionByConfig *injection, id *injectionToReplace, BOOL *stop) {
            id configuredInjection = [self injectionForConfigInjection:injection];
            if (configuredInjection) {
                injection.configuredInjection = configuredInjection;
            }
        }];
}

- (void)configureInjectionsInRuntimeArgumentsInDefinition:(TyphoonDefinition *)definition
{
    [definition enumerateInjectionsOfKind:[TyphoonInjectionByReference class]
        options:TyphoonInjectionsEnumerationOptionAll
        usingBlock:^(TyphoonInjectionByReference *injection, id *injectionToReplace, BOOL *stop) {
            [injection.referenceArguments enumerateArgumentsUsingBlock:^(TyphoonInjectionByConfig *argument, NSUInteger index, BOOL *stop) {
                if ([argument isKindOfClass:[TyphoonInjectionByConfig class]]) {
                    id configuredInjection = [self injectionForConfigInjection:argument];
                    if (configuredInjection) {
                        argument.configuredInjection = configuredInjection;
                    }
                }
            }];
        }];
}

- (id<TyphoonInjection>)injectionForConfigInjection:(TyphoonInjectionByConfig *)injection
{
    id value = [self configurationValueForKey:injection.configKey];
    id<TyphoonInjection> result = nil;

    if ([value isKindOfClass:[NSString class]]) {
        result = TyphoonInjectionWithObjectFromString(value);
    } else if (value) {
        result = TyphoonInjectionWithObject(value);
    }

    return result;
}

@end

id TyphoonConfig(NSString *configKey)
{
    return TyphoonInjectionWithConfigKey(configKey);
}