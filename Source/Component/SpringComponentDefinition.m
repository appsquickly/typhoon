////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "SpringComponentDefinition.h"
#import "SpringPropertyInjectedByType.h"
#import "SpringPropertyInjectedByReference.h"
#import "SpringPropertyInjectedByValue.h"


@implementation SpringComponentDefinition

/* ============================================================ Initializers ============================================================ */
- (id)initWithClazz:(Class)clazz key:(NSString*)key
{
    self = [super init];
    if (self)
    {
        _type = clazz;
        _key = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        _injectedProperties = [[NSMutableSet alloc] init];
        [self validateRequiredParametersAreSet];
    }
    return self;
}

- (id)init
{
    return [self initWithClazz:nil key:nil];
}

/* ========================================================== Interface Methods ========================================================= */
- (void)injectProperty:(NSString*)propertyName
{
    [_injectedProperties addObject:[[SpringPropertyInjectedByType alloc] initWithName:propertyName]];
}

- (void)injectProperty:(NSString*)propertyName withReference:(NSString*)reference
{
    [_injectedProperties addObject:[[SpringPropertyInjectedByReference alloc] initWithName:propertyName reference:reference]];
}

- (void)injectProperty:(NSString*)propertyName withValueAsText:(NSString*)textValue
{
    [_injectedProperties addObject:[[SpringPropertyInjectedByValue alloc] initWithName:propertyName value:textValue]];
}

- (void)addInjectedProperty:(id <SpringInjectedProperty>)property
{
    if ([property isKindOfClass:[SpringPropertyInjectedByReference class]])
    {
        SpringPropertyInjectedByReference* referenceProperty = (SpringPropertyInjectedByReference*) property;
        [self injectProperty:referenceProperty.name withReference:referenceProperty.reference];
    }
    else if ([property isKindOfClass:[SpringPropertyInjectedByType class]])
    {
        [self injectProperty:property.name];
    }
    else if ([property isKindOfClass:[SpringPropertyInjectedByValue class]])
    {
        SpringPropertyInjectedByValue* valueProperty = (SpringPropertyInjectedByValue*) property;
        [self injectProperty:valueProperty.name withValueAsText:valueProperty.textValue];
    }
}

- (NSSet*)injectedProperties
{
    return [_injectedProperties copy];
}


/* ============================================================ Utility Methods ========================================================= */
- (NSString*)description
{
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.injectedProperties=%@", self.injectedProperties];
    [description appendFormat:@", self.type=%@", self.type];
    [description appendFormat:@", self.key=%@", self.key];
    [description appendFormat:@", self.initializer=%@", self.initializer];
    [description appendFormat:@", self.lifecycle=%@", self.lifecycle == SpringComponentLifeCycleSingleton ? @"Singleton" : @"Prototype"];
    [description appendString:@">"];
    return description;
}


/* ============================================================ Private Methods ========================================================= */
- (void)validateRequiredParametersAreSet
{
    if (_type == nil)
    {
        [NSException raise:NSInvalidArgumentException format:@"Property 'clazz' is required."];
    }

    if ([_key length] == 0)
    {
        [NSException raise:NSInvalidArgumentException format:@"Property 'key' is required."];
    }

}

@end