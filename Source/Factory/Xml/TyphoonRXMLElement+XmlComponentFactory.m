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



#import "TyphoonRXMLElement+XmlComponentFactory.h"
#import "TyphoonDefinition.h"
#import "TyphoonInjectedProperty.h"
#import "TyphoonPropertyInjectedByReference.h"
#import "TyphoonPropertyInjectedByValue.h"
#import "TyphoonPropertyInjectedByType.h"
#import "TyphoonInitializer.h"

@implementation TyphoonRXMLElement (XmlComponentFactory)

- (TyphoonDefinition*)asComponentDefinition
{
    [self assertTagName:@"component"];
    Class clazz = NSClassFromString([self attribute:@"class"]);
    if (clazz == nil)
    {
        [NSException raise:NSInvalidArgumentException format:@"Class '%@' can't be resolved.", [self attribute:@"class"]];
    }
    NSString* key = [self attribute:@"key"];
    NSString* factory = [self attributeOrNilIfEmpty:@"factory-component"];
    TyphoonDefinition* definition = [[TyphoonDefinition alloc] initWithClass:clazz key:key factoryComponent:factory];

    [definition setBeforePropertyInjection:NSSelectorFromString([self attribute:@"before-property-injection"])];
    [definition setAfterPropertyInjection:NSSelectorFromString([self attribute:@"after-property-injection"])];
    [self setScopeForDefinition:definition withStringValue:[[self attribute:@"scope"] lowercaseString]];
    [self parseComponentDefinitionChildren:definition];
    return definition;
}


- (id <TyphoonInjectedProperty>)asInjectedProperty
{
    [self assertTagName:@"property"];

    NSString* propertyName = [self attribute:@"name"];
    NSString* referenceName = [self attribute:@"ref"];
    NSString* value = [self attribute:@"value"];

    id <TyphoonInjectedProperty> injectedProperty = nil;
    if (referenceName && value)
    {
        [NSException raise:NSInvalidArgumentException format:@"Ambigous - both reference and value attributes are set. Can only be one."];
    }
    else if (referenceName && [referenceName length] == 0)
    {
        [NSException raise:NSInvalidArgumentException format:@"Reference cannot be empty."];
    }

    else if ([referenceName length] > 0)
    {
        injectedProperty = [[TyphoonPropertyInjectedByReference alloc] initWithName:propertyName reference:referenceName];
    }
    else if (value)
    {
        injectedProperty = [[TyphoonPropertyInjectedByValue alloc] initWithName:propertyName value:value];
    }
    else
    {
        injectedProperty = [[TyphoonPropertyInjectedByType alloc] initWithName:propertyName];
    }
    return injectedProperty;
}

- (TyphoonInitializer*)asInitializer
{
    [self assertTagName:@"initializer"];
    SEL selector = NSSelectorFromString([self attribute:@"selector"]);
    TyphoonComponentInitializerIsClassMethod isClassMethod = [self handleIsClassMethod:[self attribute:@"is-class-method"]];
    TyphoonInitializer* initializer = [[TyphoonInitializer alloc] initWithSelector:selector isClassMethod:isClassMethod];

    [self iterate:@"*" usingBlock:^(TyphoonRXMLElement* child)
    {
        if ([[child tag] isEqualToString:@"argument"])
        {
            [self setArgumentOnInitializer:initializer withChildTag:child];
        }
        else if ([[child tag] isEqualToString:@"description"])
        {
            //do nothing.
        }
        else
        {
            [NSException raise:NSInvalidArgumentException format:@"The tag '%@' can't be used as part of an initializer.", [child tag]];
        }
    }];
    return initializer;
}

/* ============================================================ Private Methods ========================================================= */
- (void)assertTagName:(NSString*)tagName
{
    if (![self.tag isEqualToString:tagName])
    {
        [NSException raise:NSInvalidArgumentException format:@"Element is not a '%@'.", tagName];
    }
}

- (void)setScopeForDefinition:(TyphoonDefinition*)definition withStringValue:(NSString*)scope;
{

    if ([scope isEqualToString:@"singleton"])
    {
        [definition setScope:TyphoonScopeSingleton];
    }
    else if ([scope isEqualToString:@"prototype"])
    {
        [definition setScope:TyphoonScopeDefault];
    }
    else if ([scope length] > 0)
    {
        [NSException raise:NSInvalidArgumentException format:@"Scope was '%@', but can only be 'singleton' or 'prototype'", scope];
    }
}



- (void)parseComponentDefinitionChildren:(TyphoonDefinition*)componentDefinition
{
    [self iterate:@"*" usingBlock:^(TyphoonRXMLElement* child)
    {
        if ([[child tag] isEqualToString:@"property"])
        {
            [componentDefinition addInjectedProperty:[child asInjectedProperty]];
        }
        else if ([[child tag] isEqualToString:@"initializer"])
        {
            [componentDefinition setInitializer:[child asInitializer]];
        }
        else if ([[child tag] isEqualToString:@"description"])
        {
            // do nothing
        }
        else
        {
            [NSException raise:NSInvalidArgumentException format:@"The tag '%@' can't be used as part of a component definition.",
                                                                 [child tag]];
        }
    }];
}

- (void)setArgumentOnInitializer:(TyphoonInitializer*)initializer withChildTag:(TyphoonRXMLElement*)child
{
    NSString* name = [child attribute:@"parameterName"];
    NSString* reference = [child attribute:@"ref"];
    NSString* value = [child attribute:@"value"];

    if (reference)
    {
        [initializer injectParameterNamed:name withReference:reference];
    }
    else if (value)
    {
        NSString* classAsString = [child attribute:@"required-class"];
        Class clazz;
        if (classAsString)
        {
            clazz = NSClassFromString(classAsString);
            if (clazz == nil)
            {
                [NSException raise:NSInvalidArgumentException format:@"Class '%@' could not be resolved.", classAsString];
            }
        }
        [initializer injectParameterNamed:name withValueAsText:value requiredTypeOrNil:clazz];
    }
}

- (TyphoonComponentInitializerIsClassMethod)handleIsClassMethod:(NSString*)isClassMethodString
{
    if ([[isClassMethodString lowercaseString] isEqualToString:@"yes"] || [[isClassMethodString lowercaseString] isEqualToString:@"true"])
    {
        return TyphoonComponentInitializerIsClassMethodYes;
    }
    else if ([[isClassMethodString lowercaseString] isEqualToString:@"no"] || [[isClassMethodString lowercaseString] isEqualToString:@"no"])
    {
        return TyphoonComponentInitializerIsClassMethodNo;
    }
    else
    {
        return TyphoonComponentInitializerIsClassMethodGuess;
    }
}

- (NSString*)attributeOrNilIfEmpty:(NSString*)attributeName
{
    NSString* attribute = [self attribute:attributeName];
    if ([attribute length] > 0)
    {
        return attribute;
    }
    return nil;
}

@end