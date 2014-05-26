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


#import "TyphoonPropertyPlaceholderConfigurer.h"
#import "TyphoonResource.h"
#import "TyphoonDefinition.h"
#import "TyphoonInjectionByObjectFromString.h"
#import "TyphoonDefinition+InstanceBuilder.h"
#import "OCLogTemplate.h"
#import "TyphoonPropertyStyleConfiguration.h"
#import "TyphoonInjections.h"
#import "TyphoonJsonStyleConfiguration.h"
#import "TyphoonBundleResource.h"
#import "TyphoonPlistStyleConfiguration.h"

NSString static *kTyphoonPropertyPlaceholderPrefix = @"${";
NSString static *kTyphoonPropertyPlaceholderSuffix = @"}";

static NSMutableDictionary *propertyPlaceholderRegistry;

@implementation TyphoonPropertyPlaceholderConfigurer {
    NSDictionary *_configs;
}



/* ====================================================================================================================================== */
#pragma mark - Class Methods

+ (TyphoonPropertyPlaceholderConfigurer *)configurer
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
        [definition enumerateInjectionsOfKind:[TyphoonInjectionByObjectFromString class] options:TyphoonInjectionsEnumerationOptionAll
                                   usingBlock:^(TyphoonInjectionByObjectFromString *injection, id *injectionToReplace, BOOL *stop) {
            if ([self shouldMutateInjection:injection]) {
                [self mutateInjection:injection injectionToReplace:injectionToReplace];
            }
        }];
    }
}

- (BOOL)shouldMutateInjection:(TyphoonInjectionByObjectFromString *)injection
{
    return [injection.textValue hasPrefix:kTyphoonPropertyPlaceholderPrefix] && [injection.textValue hasSuffix:kTyphoonPropertyPlaceholderSuffix];
}

- (void)mutateInjection:(TyphoonInjectionByObjectFromString *)injection injectionToReplace:(id*)injectionToReplace
{
    NSString *key = [injection.textValue substringFromIndex:[kTyphoonPropertyPlaceholderPrefix length]];
    key = [key substringToIndex:[key length] - [kTyphoonPropertyPlaceholderSuffix length]];
    id value = [self configurationValueForKey:key];

    if ([value isKindOfClass:[NSString class]]) {
        injection.textValue = value;
    } else {
        *injectionToReplace = TyphoonInjectionWithObject(value);
    }
}

@end


@implementation TyphoonPropertyPlaceholderConfigurer (Deprecated)

+ (TyphoonPropertyPlaceholderConfigurer *)configurerWithResource:(id <TyphoonResource>)resource
{
    return [self configurerWithResourceList:@[resource]];
}

+ (TyphoonPropertyPlaceholderConfigurer *)configurerWithResources:(id <TyphoonResource>)first, ...
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

+ (TyphoonPropertyPlaceholderConfigurer *)configurerWithResourceList:(NSArray *)resources
{
    TyphoonPropertyPlaceholderConfigurer *configurer = [TyphoonPropertyPlaceholderConfigurer configurer];
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

id TyphoonConfig(NSString *configKey) {
    NSString *key = [NSString stringWithFormat:@"%@%@%@", kTyphoonPropertyPlaceholderPrefix, configKey, kTyphoonPropertyPlaceholderSuffix];
    return TyphoonInjectionWithObjectFromString(key);
}
