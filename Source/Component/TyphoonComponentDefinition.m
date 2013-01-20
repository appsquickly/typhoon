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


#import "TyphoonComponentInitializer.h"
#import "TyphoonComponentDefinition.h"
#import "TyphoonPropertyInjectedByType.h"
#import "TyphoonPropertyInjectedByReference.h"
#import "TyphoonPropertyInjectedByValue.h"


@implementation TyphoonComponentDefinition


/* ============================================================ Initializers ============================================================ */
- (id)initWithClass:(Class)clazz key:(NSString*)key factoryComponent:(NSString*)factoryComponent
{
    self = [super init];
    if (self)
    {
        _type = clazz;
        if ([key length] == 0)
        {
            NSString* uuidStr = [[NSProcessInfo processInfo] globallyUniqueString];
            _key = [NSString stringWithFormat:@"%@%@", NSStringFromClass(_type), uuidStr];
        }
        else
        {
            _key = [key copy];
        }
        _factoryComponent = [factoryComponent copy];
        _injectedProperties = [[NSMutableSet alloc] init];
        [self validateRequiredParametersAreSet];
    }
    return self;
}

- (id)initWithClass:(Class)clazz key:(NSString*)key
{
    return [self initWithClass:clazz key:key factoryComponent:nil];
}

- (id)init
{
    return [self initWithClass:nil key:nil factoryComponent:nil];
}


/* ========================================================== Interface Methods ========================================================= */
- (void)injectProperty:(NSString*)propertyName
{
    [_injectedProperties addObject:[[TyphoonPropertyInjectedByType alloc] initWithName:propertyName]];
}

- (void)injectProperty:(NSString*)propertyName withReference:(NSString*)reference
{
    [_injectedProperties addObject:[[TyphoonPropertyInjectedByReference alloc] initWithName:propertyName reference:reference]];
}

- (void)injectProperty:(NSString*)propertyName withValueAsText:(NSString*)textValue
{
    [_injectedProperties addObject:[[TyphoonPropertyInjectedByValue alloc] initWithName:propertyName value:textValue]];
}

- (void)addInjectedProperty:(id <TyphoonInjectedProperty>)property
{
    if ([property isKindOfClass:[TyphoonPropertyInjectedByReference class]])
    {
        TyphoonPropertyInjectedByReference* referenceProperty = (TyphoonPropertyInjectedByReference*) property;
        [self injectProperty:referenceProperty.name withReference:referenceProperty.reference];
    }
    else if ([property isKindOfClass:[TyphoonPropertyInjectedByType class]])
    {
        [self injectProperty:property.name];
    }
    else if ([property isKindOfClass:[TyphoonPropertyInjectedByValue class]])
    {
        TyphoonPropertyInjectedByValue* valueProperty = (TyphoonPropertyInjectedByValue*) property;
        [self injectProperty:valueProperty.name withValueAsText:valueProperty.textValue];
    }
}

- (NSSet*)injectedProperties
{
    return [_injectedProperties copy];
}

- (void)setInitializer:(TyphoonComponentInitializer*)initializer
{
    _initializer = initializer;
    [_initializer setComponentDefinition:self];
}

- (NSSet*)propertiesInjectedByValue
{
    return [self injectedPropertiesWithKindClass:[TyphoonPropertyInjectedByValue class]];
}

- (NSSet*)propertiesInjectedByType
{
    return [self injectedPropertiesWithKindClass:[TyphoonPropertyInjectedByType class]];
}

- (NSSet*)propertiesInjectedByReference
{
    return [self injectedPropertiesWithKindClass:[TyphoonPropertyInjectedByReference class]];
}


/* ============================================================ Utility Methods ========================================================= */
- (NSString*)description
{
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.injectedProperties=%@", self.injectedProperties];
    [description appendFormat:@", self.type=%@", self.type];
    [description appendFormat:@", self.key=%@", self.key];
    [description appendFormat:@", self.initializer=%@", self.initializer];
    [description appendFormat:@", self.lifecycle=%@", self.lifecycle == TyphoonComponentLifeCycleSingleton ? @"Singleton" : @"Prototype"];
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