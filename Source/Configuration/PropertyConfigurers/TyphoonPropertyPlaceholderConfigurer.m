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

NSString static *kTyphoonPropertyPlaceholderPrefix = @"${";
NSString static *kTyphoonPropertyPlaceholderSuffix = @"}";

@implementation TyphoonPropertyPlaceholderConfigurer {
    id<TyphoonConfiguration> _propertyStyleConfiguration;
    id<TyphoonConfiguration> _jsonStyleConfiguration;
}

/* ====================================================================================================================================== */
#pragma mark - Class Methods

+ (TyphoonPropertyPlaceholderConfigurer *)configurer
{
    return [[[self class] alloc] init];
}

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
        [configurer usePropertyStyleResource:resource];
    }
    return configurer;
}


/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)init
{
    self = [super init];
    if (self) {
        _propertyStyleConfiguration = [TyphoonPropertyStyleConfiguration new];
        _jsonStyleConfiguration = [TyphoonJsonStyleConfiguration new];
    }
    return self;
}

/* ====================================================================================================================================== */
#pragma mark - Interface Methods

- (void)usePropertyStyleResource:(id <TyphoonResource>)resource
{
    [_propertyStyleConfiguration appendResource:resource];
}

- (void)useJsonStyleResource:(id<TyphoonResource>)resource
{
    [_jsonStyleConfiguration appendResource:resource];
}

- (id)configurationValueForKey:(NSString *)key
{
    id value = [_jsonStyleConfiguration objectForKey:key];
    if (!value) {
        value = [_propertyStyleConfiguration objectForKey:key];
    }
    return value;
}

/* ====================================================================================================================================== */
#pragma mark - Protocol Methods

- (void)postProcessComponentFactory:(TyphoonComponentFactory *)factory
{
    for (TyphoonDefinition *definition in [factory registry]) {
        for (id <TyphoonInjectedWithStringRepresentation> component in [definition componentsInjectedByValue]) {
            [self mutateComponentInjectedByValue:component];
        }

    }
}

- (void)mutateComponentInjectedByValue:(id <TyphoonInjectedWithStringRepresentation>)component;
{
    if ([component.textValue hasPrefix:kTyphoonPropertyPlaceholderPrefix] && [component.textValue hasSuffix:kTyphoonPropertyPlaceholderSuffix]) {
        NSString *key = [component.textValue substringFromIndex:[kTyphoonPropertyPlaceholderPrefix length]];
        key = [key substringToIndex:[key length] - [kTyphoonPropertyPlaceholderSuffix length]];
        NSString *value = [self configurationValueForKey:key]
        LogTrace(@"Setting property '%@' to value '%@'", key, value);
        component.textValue = value;
    }
}

@end

id TyphoonConfig(NSString *configKey) {
    NSString *key = [NSString stringWithFormat:@"%@%@%@", kTyphoonPropertyPlaceholderPrefix, configKey, kTyphoonPropertyPlaceholderSuffix];
    return TyphoonInjectionWithObjectFromString(key);
}