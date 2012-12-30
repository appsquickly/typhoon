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


#import <Foundation/Foundation.h>
#import "RXMLElement+SpringXmlComponentFactory.h"
#import "SpringComponentDefinition.h"
#import "SpringInjectedProperty.h"
#import "SpringPropertyInjectedByReference.h"
#import "SpringPropertyInjectedByValue.h"
#import "SpringPropertyInjectedByType.h"
#import "SpringComponentInitializer.h"
#import "SpringInjectedParameter.h"

@implementation RXMLElement (SpringXmlComponentFactory)

- (SpringComponentDefinition*)asComponentDefinition
{
    [self assertTagName:@"component"];
    Class clazz = NSClassFromString([self attribute:@"class"]);
    if (clazz == nil)
    {
        [NSException raise:NSInvalidArgumentException format:@"Class '%@' can't be resolved.", [self attribute:@"class"]];
    }
    NSString* key = [self createOrRetrieveIdComponentId];
    SpringComponentDefinition* componentDefinition = [[SpringComponentDefinition alloc] initWithClazz:clazz key:key];

    [self setScopeForDefinition:componentDefinition withStringValue:[[self attribute:@"scope"] lowercaseString]];
    [self parseComponentDefinitionChildren:componentDefinition];
    return componentDefinition;
}


- (id <SpringInjectedProperty>)asInjectedProperty
{
    [self assertTagName:@"property"];

    NSString* propertyName = [self attribute:@"name"];
    NSString* referenceName = [self attribute:@"ref"];
    NSString* value = [self attribute:@"value"];

    id <SpringInjectedProperty> injectedProperty = nil;
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
        injectedProperty = [[SpringPropertyInjectedByReference alloc] initWithName:propertyName reference:referenceName];
    }
    else if (value)
    {
        injectedProperty = [[SpringPropertyInjectedByValue alloc] initWithName:propertyName value:value];
    }
    else
    {
        injectedProperty = [[SpringPropertyInjectedByType alloc] initWithName:propertyName];
    }
    return injectedProperty;
}

- (SpringComponentInitializer*)asInitializer
{
    [self assertTagName:@"initializer"];
    return [self asInitializerIsFactoryMethod:NO];
}

- (SpringComponentInitializer*)asFactoryMethod
{
    [self assertTagName:@"factory-method"];
    return [self asInitializerIsFactoryMethod:YES];
}


/* ============================================================ Private Methods ========================================================= */
- (SpringComponentInitializer*)asInitializerIsFactoryMethod:(BOOL)isFactoryMethod
{
    SEL selector = NSSelectorFromString([self attribute:@"selector"]);
    SpringComponentInitializer
            * initializer = [[SpringComponentInitializer alloc] initWithSelector:selector isFactoryMethod:isFactoryMethod];

    [self iterate:@"*" usingBlock:^(RXMLElement* child)
    {
        if ([[child tag] isEqualToString:@"argument"])
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
                        [NSException raise:NSInvalidArgumentException format:@"Class '%@' could not be resolved."];
                    }
                }
                [initializer injectParameterNamed:name withValueAsText:value requiredTypeOrNil:clazz];
            }

        }
        else
        {
            [NSException raise:NSInvalidArgumentException format:@"The tag '%@' can't be used as part of an initializer.", [child tag]];
        }
    }];
    return initializer;
}

- (void)assertTagName:(NSString*)tagName
{
    if (![self.tag isEqualToString:tagName])
    {
        [NSException raise:NSInvalidArgumentException format:@"Element is not a '%@'.", tagName];
    }
}

- (void)setScopeForDefinition:(SpringComponentDefinition*)definition withStringValue:(NSString*)scope;
{

    if ([scope isEqualToString:@"singleton"])
    {
        [definition setLifecycle:SpringComponentLifeCycleSingleton];
    }
    else if ([scope isEqualToString:@"prototype"])
    {
        [definition setLifecycle:SpringComponentLifeCyclePrototype];
    }
    else if ([scope length] > 0)
    {
        [NSException raise:NSInvalidArgumentException format:@"Scope was '%@', but can only be 'singleton' or 'prototype'", scope];
    }
}

- (NSString*)createOrRetrieveIdComponentId
{
    NSString* componentId = [self attribute:@"id"];
    if (componentId == nil)
    {
        [NSException raise:NSInternalInconsistencyException format:@"$$$$$$$$$$$$$$ Need to implement support for nil id"];
    }
    return componentId;
}

- (void)parseComponentDefinitionChildren:(SpringComponentDefinition*)componentDefinition
{
    [self iterate:@"*" usingBlock:^(RXMLElement* child)
    {
        if ([[child tag] isEqualToString:@"property"])
        {
            [componentDefinition addInjectedProperty:[child asInjectedProperty]];
        }
        else if ([[child tag] isEqualToString:@"initializer"])
        {
            [componentDefinition setInitializer:[child asInitializer]];
        }
        else if ([[child tag] isEqualToString:@"factory-method"])
        {
            [componentDefinition setInitializer:[child asFactoryMethod]];
        }
        else
        {
            [NSException raise:NSInvalidArgumentException format:@"The tag '%@' can't be used as part of a component definition.",
                                                                 [child tag]];
        }
    }];
}

@end