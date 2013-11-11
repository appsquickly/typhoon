//
// Created by Robert Gilliam on 11/10/13.
// Copyright (c) 2013 Jasper Blues. All rights reserved.
//


#import "TyphoonDefinitionRegisterer.h"
#import "TyphoonDefinition.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonComponentFactory+TyphoonDefinitionRegisterer.h"
#import <objc/message.h>
#import "OCLogTemplate.h"

@implementation TyphoonDefinitionRegisterer
{
    TyphoonDefinition* _definition;
    TyphoonComponentFactory* _componentFactory;
}

- (id)initWithDefinition:(TyphoonDefinition*)aDefinition componentFactory:(TyphoonComponentFactory*)aComponentFactory
{
    self = [super init];
    if (self)
    {
        _definition = aDefinition;
        _componentFactory = aComponentFactory;
    }

    return self;
}

- (void)register
{
    [self setDefinitionKeyRandomlyIfNeeded];

    if ([self definitionAlreadyRegistered])
    {
        [NSException raise:NSInvalidArgumentException format:@"Key '%@' is already registered.", _definition.key];
    }

    [self injectAutowiredPropertiesIfNeeded];

    [self registerDefinitionWithFactory];
}

- (void)setDefinitionKeyRandomlyIfNeeded
{
    if ([_definition.key length] == 0)
    {
        NSString* uuidStr = [[NSProcessInfo processInfo] globallyUniqueString];
        _definition.key = [NSString stringWithFormat:@"%@_%@", NSStringFromClass(_definition.type), uuidStr];
    }
}

- (BOOL)definitionAlreadyRegistered
{
    return [_componentFactory definitionForKey:_definition.key] != nil;
}

- (void)injectAutowiredPropertiesIfNeeded
{
    SEL autoInjectedProperties = sel_registerName("typhoonAutoInjectedProperties");
    if ([_definition.type respondsToSelector:autoInjectedProperties])
    {
        id autoWiredProperties = objc_msgSend(_definition.type, autoInjectedProperties);
        for (NSString* anAutoWiredProperty in autoWiredProperties)
        {
            [_definition injectProperty:NSSelectorFromString(anAutoWiredProperty)];
        }
    }
}

- (void)registerDefinitionWithFactory
{
    if ([self definitionIsInfrastructureComponent])
    {
        [self registerInfrastructureComponentFromDefinition];
    }
    else
    {
        LogTrace(@"Registering: %@ with key: %@", NSStringFromClass(_definition.type), _definition.key);
        [_componentFactory addDefinitionToRegistry:_definition];
    }
}

- (BOOL)definitionIsInfrastructureComponent
{
    if ([_definition.type conformsToProtocol:@protocol(TyphoonComponentFactoryPostProcessor)])
    {
        return YES;
    }
    return NO;
}

- (void)registerInfrastructureComponentFromDefinition
{
    LogTrace(@"Registering Infrastructure component: %@ with key: %@", NSStringFromClass(_definition.type), _definition.key);
    [_componentFactory attachPostProcessor:[_componentFactory objectForDefinition:_definition]];
}


@end