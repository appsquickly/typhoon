////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 - 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "SpringComponentInitializer.h"
#import "SpringComponentDefinition.h"
#import "SpringPropertyInjectedByType.h"
#import "SpringPropertyInjectedByReference.h"
#import "SpringPropertyInjectedByValue.h"


@implementation SpringComponentDefinition



/* ============================================================ Initializers ============================================================ */
- (id)initWithClazz:(Class)clazz key:(NSString*)key factoryComponent:(NSString*)factoryComponent
{
    self = [super init];
    if (self)
    {
        _type = clazz;
        _key = [key copy];
        _factoryComponent = [factoryComponent copy];
        _injectedProperties = [[NSMutableSet alloc] init];
        [self validateRequiredParametersAreSet];
    }
    return self;
}

- (id)initWithClazz:(Class)clazz key:(NSString*)key
{
    return [self initWithClazz:clazz key:key factoryComponent:nil];
}

- (id)init
{
    return [self initWithClazz:nil key:nil factoryComponent:nil];
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

- (void)setInitializer:(SpringComponentInitializer*)initializer
{
    _initializer = initializer;
    [_initializer setComponentDefinition:self];
}

- (NSSet*)propertiesInjectedByValue
{
    return [self injectedPropertiesWithKindClass:[SpringPropertyInjectedByValue class]];
}

- (NSSet*)propertiesInjectedByType
{
    return [self injectedPropertiesWithKindClass:[SpringPropertyInjectedByType class]];
}

- (NSSet*)propertiesInjectedByReference
{
    return [self injectedPropertiesWithKindClass:[SpringPropertyInjectedByReference class]];
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

- (void)dealloc
{
    //Null out the __unsafe_unretained property on initializer
    [_initializer setComponentDefinition:nil];
}

/* ============================================================ Private Methods ========================================================= */
- (void)validateRequiredParametersAreSet
{
    if (_type == nil)
    {
        [NSException raise:NSInvalidArgumentException format:@"Property 'clazz' is required."];
    }
}

- (NSSet*)injectedPropertiesWithKindClass:(Class)clazz
{
    NSPredicate* predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary* bindings)
    {
        return [evaluatedObject isKindOfClass:clazz];
    }];
    return [_injectedProperties filteredSetUsingPredicate:predicate];
}

@end