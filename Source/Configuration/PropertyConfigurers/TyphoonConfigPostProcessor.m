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

static NSMutableDictionary *propertyPlaceholderRegistry;

@implementation TyphoonConfigPostProcessor
{
    NSDictionary *_configs;
}



/* ====================================================================================================================================== */
#pragma mark - Class Methods

+ (TyphoonConfigPostProcessor *)configurer
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

/* ====================================================================================================================================== */
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

/* ====================================================================================================================================== */
#pragma mark - Interface Methods

- (void)useResourceWithName:(NSString *)name
{
    [self useResource:[TyphoonBundleResource withName:name] withExtension:[name pathExtension]];
}

- (void)useResourceAtPath:(NSString *)path
{
    [self useResource:[TyphoonPathResource withPath:path] withExtension:[path pathExtension]];
}

- (void)useResource:(id <TyphoonResource>)resource withExtension:(NSString *)typeExtension
{
    id<TyphoonConfiguration>config = _configs[typeExtension];
    [config appendResource:resource];
}

- (id)configurationValueForKey:(NSString *)key
{
    __block id value = nil;
    __block NSString *foundExtension = nil;
    [_configs enumerateKeysAndObjectsUsingBlock:^(NSString *extension, id<TyphoonConfiguration>config, BOOL *stop) {

        id object = [config objectForKey:key];
#if !DEBUG
        if (object) {
            value = object;
            *stop = YES;
        }
#else
        if (object) {
            if (value) {
                [NSException raise:NSInternalInconsistencyException format:@"Value for key %@ already exists in %@ config", key, foundExtension];
            } else {
                value = object;
                foundExtension = extension;
            }
        }
#endif
    }];

    return value;
}

/* ====================================================================================================================================== */
#pragma mark - Protocol Methods

- (void)postProcessComponentFactory:(TyphoonComponentFactory *)factory
{
    for (TyphoonDefinition *definition in [factory registry]) {
        [definition enumerateInjectionsOfKind:[TyphoonInjectionByConfig class] options:TyphoonInjectionsEnumerationOptionAll
                                   usingBlock:^(TyphoonInjectionByConfig *injection, id *injectionToReplace, BOOL *stop) {
            injection.configuredInjection = [self injectionForConfigInjection:injection];
        }];
    }
}

- (id<TyphoonInjection>)injectionForConfigInjection:(TyphoonInjectionByConfig *)injection
{
    id value = [self configurationValueForKey:injection.configKey];
    id<TyphoonInjection>result = nil;

    if ([value isKindOfClass:[NSString class]]) {
        result = TyphoonInjectionWithObjectFromString(value);
    } else {
        result = TyphoonInjectionWithObject(value);
    }

    return result;
}

@end


@implementation TyphoonConfigPostProcessor (Deprecated)

+ (TyphoonConfigPostProcessor *)configurerWithResource:(id <TyphoonResource>)resource
{
    return [self configurerWithResourceList:@[resource]];
}

+ (TyphoonConfigPostProcessor *)configurerWithResources:(id <TyphoonResource>)first, ...
{
    NSMutableArray *resources = [[NSMutableArray alloc] init];
    [resources addObject:first];

    va_list resource_list;
    va_start(resource_list, first);
    id <TyphoonResource> resource;
    while ((resource = va_arg( resource_list, id < TyphoonResource >))) {
        [resources addObject:resource];
    }
    va_end(resource_list);

    return [self configurerWithResourceList:resources];
}

+ (TyphoonConfigPostProcessor *)configurerWithResourceList:(NSArray *)resources
{
    TyphoonConfigPostProcessor *configurer = [TyphoonConfigPostProcessor configurer];
    for (id <TyphoonResource> resource in resources) {
        [configurer useResource:resource withExtension:@"properties"];
    }
    return configurer;
}

- (void)usePropertyStyleResource:(id <TyphoonResource>)resource
{
    [self useResource:resource withExtension:@"properties"];
}

@end


id TyphoonConfig(NSString *configKey)
{
    return TyphoonInjectionWithConfigKey(configKey);
}