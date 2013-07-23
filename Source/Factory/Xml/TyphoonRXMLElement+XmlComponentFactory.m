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
#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonPropertyInjectedAsCollection.h"

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
	TyphoonScope scope = [self scopeForStringValue:[[self attribute:@"scope"] lowercaseString]];
	BOOL isLazy = (scope == TyphoonScopeSingleton) && [self attributeAsBool:@"lazy-init"];
    // Don't throw exception if a lazy init is set to a prototype.
	// Even if the input is wrong, this won't set the definition
	// in an unstable statement.
	
	TyphoonDefinition* definition = [[TyphoonDefinition alloc] initWithClass:clazz key:key factoryComponent:factory];
    [definition setBeforePropertyInjection:NSSelectorFromString([self attribute:@"before-property-injection"])];
    [definition setAfterPropertyInjection:NSSelectorFromString([self attribute:@"after-property-injection"])];
    [definition setLazy:isLazy];
	[definition setScope:scope];
    [self parseComponentDefinitionChildren:definition];
    return definition;
}

//TODO: Method too long, clean it up.
- (id <TyphoonInjectedProperty>)asInjectedProperty
{
    [self assertTagName:@"property"];

    NSString* propertyName = [self attribute:@"name"];
    NSString* referenceName = [self attribute:@"ref"];
    NSString* value = [self attribute:@"value"];

    TyphoonRXMLElement* collection = [self child:@"collection"];
    if ((referenceName || value) && collection)
    {
        [NSException raise:NSInvalidArgumentException format:@"'ref' and 'value' attributes cannot be used with 'collection'"];
    }

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
    else if (collection)
    {
        TyphoonPropertyInjectedAsCollection* property = [[TyphoonPropertyInjectedAsCollection alloc] initWithName:propertyName];
        [collection iterate:@"*" usingBlock:^(TyphoonRXMLElement* child)
        {
            if ([[child tag] isEqualToString:@"ref"])
            {
                [property addItemWithComponentName:[child text]];
            }
            else if ([[child tag] isEqualToString:@"value"])
            {
                Class type = NSClassFromString([child attribute:@"requiredType"]);
                if (!type)
                {
                    [NSException raise:NSInvalidArgumentException format:@"Type '%@' could not be resolved.",
                                                                         [child attribute:@"requiredType"]];
                }
                [property addItemWithText:[child text] requiredType:type];
            }
        }];
        NSLog(@"$$$$$$$$$$$$$$ Here's the injected property: %@", property);
        injectedProperty = property;
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

- (TyphoonScope)scopeForStringValue:(NSString*)scope
{
	NSArray *acceptedScopes = @[@"prototype", @"singleton"];
	if (([scope length] > 0) && (! [acceptedScopes containsObject:scope])) {
		[NSException raise:NSInvalidArgumentException format:@"Scope was '%@', but can only be 'singleton' or 'prototype'", scope];
	}
	
	// Here, we don't follow the Spring's implementation :
	// the "default" scope is the prototype.
	TyphoonScope result = TyphoonScopeDefault;
	if ([scope isEqualToString:@"singleton"]) {
		result = TyphoonScopeSingleton;
    }
	
	return result;
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
    NSString* index = [child attribute:@"index"];

    if (name && index)
    {
        [NSException raise:NSInvalidArgumentException format:@"'parameterName' and 'index' cannot be used together"];
    }

    NSString* reference = [child attribute:@"ref"];
    NSString* value = [child attribute:@"value"];

    if (reference)
    {
        if (name)
        {
            [initializer injectParameterNamed:name withReference:reference];
        }
        else if (index)
        {
            [initializer injectParameterAtIndex:[index integerValue] withReference:reference];
        }

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
        if (name)
        {
            [initializer injectParameterNamed:name withValueAsText:value requiredTypeOrNil:clazz];
        }
        else if (index)
        {
            [initializer injectParameterAtIndex:[index integerValue] withValueAsText:value requiredTypeOrNil:clazz];
        }

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