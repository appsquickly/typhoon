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
#import "TyphoonPropertyInjectedWithStringRepresentation.h"
#import "TyphoonDefinition+InstanceBuilder.h"
#import "OCLogTemplate.h"
#import "TyphoonComponentFactory.h"

@implementation TyphoonPropertyPlaceholderConfigurer

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

- (id)initWithPrefix:(NSString *)prefix suffix:(NSString *)suffix
{
    self = [super init];
    if (self) {
        _prefix = prefix;
        _suffix = suffix;
        _properties = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)init
{
    return [self initWithPrefix:@"${" suffix:@"}"];
}

/* ====================================================================================================================================== */
#pragma mark - Interface Methods

- (void)usePropertyStyleResource:(id <TyphoonResource>)resource
{
    NSArray *lines = [[resource asString] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    for (NSString *line in lines) {
        if (![line hasPrefix:@"#"]) {
            NSRange range = [line rangeOfString:@"="];
            if (range.location != NSNotFound) {
                NSString *property = [line substringToIndex:range.location];
                NSString *value = [line substringFromIndex:range.location + range.length];
                [_properties setObject:value forKey:property];
            }
        }
    }
}

- (NSDictionary *)properties
{
    return [_properties copy];
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
    if ([component.textValue hasPrefix:_prefix] && [component.textValue hasSuffix:_suffix]) {
        NSString *key = [component.textValue substringFromIndex:[_prefix length]];
        key = [key substringToIndex:[key length] - [_suffix length]];
        NSString *value = [_properties valueForKey:key];
        LogTrace(@"Setting property '%@' to value '%@'", key, value);
        component.textValue = value;
    }
}

@end