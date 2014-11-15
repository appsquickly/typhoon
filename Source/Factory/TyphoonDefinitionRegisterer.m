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



#import "TyphoonDefinitionRegisterer.h"
#import "TyphoonDefinition.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonComponentFactory+TyphoonDefinitionRegisterer.h"
#import "TyphoonTypeConverter.h"
#import "TyphoonTypeConverterRegistry.h"
#import <objc/message.h>
#import "OCLogTemplate.h"
#import "TyphoonComponentPostProcessor.h"
#import "TyphoonMethod.h"
#import "TyphoonMethod+InstanceBuilder.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonDefinition+Infrastructure.h"

@implementation TyphoonDefinitionRegisterer
{
    TyphoonDefinition *_definition;
    TyphoonComponentFactory *_componentFactory;
}

- (id)initWithDefinition:(TyphoonDefinition *)aDefinition componentFactory:(TyphoonComponentFactory *)aComponentFactory
{
    self = [super init];
    if (self) {
        _definition = aDefinition;
        _componentFactory = aComponentFactory;
    }

    return self;
}

- (void)doRegistration
{
    [self setDefinitionKeyRandomlyIfNeeded];

    if ([self definitionAlreadyRegistered]) {
        [NSException raise:NSInvalidArgumentException format:@"Key '%@' is already registered.", _definition.key];
    }

    [self registerDefinitionWithFactory];
}

- (void)setDefinitionKeyRandomlyIfNeeded
{
    if ([_definition.key length] == 0) {
        NSString *uuidStr = [[NSProcessInfo processInfo] globallyUniqueString];
        _definition.key = [NSString stringWithFormat:@"%@_%@", NSStringFromClass(_definition.type), uuidStr];
    }
}

- (BOOL)definitionAlreadyRegistered
{
    return [_componentFactory definitionForKey:_definition.key] != nil;
}

- (void)registerDefinitionWithFactory
{
    if ([self definitionIsInfrastructureComponent]) {
        [self registerInfrastructureComponentFromDefinition];
    }
    else {
        LogTrace(@"Registering: %@ with key: %@", NSStringFromClass(_definition.type), _definition.key);
        [_componentFactory addDefinitionToRegistry:_definition];
    }
}

- (BOOL)definitionIsInfrastructureComponent
{
    if ([_definition.type conformsToProtocol:@protocol(TyphoonComponentFactoryPostProcessor)] ||
        [_definition.type conformsToProtocol:@protocol(TyphoonComponentPostProcessor)] ||
        [_definition.type conformsToProtocol:@protocol(TyphoonTypeConverter)]) {
        return YES;
    }
    return NO;
}

- (void)registerInfrastructureComponentFromDefinition
{
    LogTrace(@"Registering Infrastructure component: %@ with key: %@", NSStringFromClass(_definition.type), _definition.key);

    id infrastructureComponent = [_componentFactory objectForDefinition:_definition args:nil];
    if ([_definition.type conformsToProtocol:@protocol(TyphoonComponentFactoryPostProcessor)]) {
        [_componentFactory attachPostProcessor:infrastructureComponent];
    }
    else if ([_definition.type conformsToProtocol:@protocol(TyphoonComponentPostProcessor)]) {
        [_componentFactory addComponentPostProcessor:infrastructureComponent];
    }
    else if ([_definition.type conformsToProtocol:@protocol(TyphoonTypeConverter)]) {
        [[TyphoonTypeConverterRegistry shared] registerTypeConverter:infrastructureComponent];
    }
}


@end