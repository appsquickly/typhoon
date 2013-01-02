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


#import <objc/runtime.h>
#import "SpringComponentFactory.h"
#import "SpringComponentDefinition.h"
#import "SpringComponentFactory+InstanceBuilder.h"


@implementation SpringComponentFactory

/* ============================================================ Initializers ============================================================ */
- (id)init
{
    self = [super init];
    if (self)
    {
        _registry = [[NSMutableArray alloc] init];
        _singletons = [[NSMutableDictionary alloc] init];
        _currentlyResolvingReferences = [[NSMutableSet alloc] init];
    }
    return self;
}

/* ========================================================== Interface Methods ========================================================= */
- (void)register:(SpringComponentDefinition*)definition
{
    if ([self definitionForKey:definition.key])
    {
        [NSException raise:NSInvalidArgumentException format:@"Key '%@' is already registered.", definition.key];
    }
    [_registry addObject:definition];
}

- (id)componentForType:(id)classOrProtocol
{
    NSArray* candidates = [self allComponentsForType:classOrProtocol];
    if ([candidates count] == 0)
    {
        [NSException raise:NSInvalidArgumentException format:@"No components defined which satisify type: '%@'", classOrProtocol];
    }
    if ([candidates count] > 1)
    {
        [NSException raise:NSInvalidArgumentException format:@"More than one component is defined satisfying type: '%@'", classOrProtocol];
    }
    return [candidates objectAtIndex:0];
}

- (NSArray*)allComponentsForType:(id)classOrProtocol
{
    NSMutableArray* results = [[NSMutableArray alloc] init];
    BOOL isClass = class_isMetaClass(object_getClass(classOrProtocol));

    for (SpringComponentDefinition* definition in _registry)
    {
        if (isClass)
        {
            if (definition.type == classOrProtocol || [definition.type isSubclassOfClass:classOrProtocol])
            {
                [results addObject:[self objectForDefinition:definition]];
            }
        }
        else
        {
            if ([definition.type conformsToProtocol:classOrProtocol])
            {
                [results addObject:[self objectForDefinition:definition]];
            }
        }
    }
    return [results copy];
}

- (id)componentForKey:(NSString*)key
{
    if ([_currentlyResolvingReferences containsObject:key])
    {
        [NSException raise:NSInvalidArgumentException format:@"Circular dependency detected: %@", _currentlyResolvingReferences];
    }
    [_currentlyResolvingReferences addObject:key];
    SpringComponentDefinition* definition = [self definitionForKey:key];
    if (!definition)
    {
        [NSException raise:NSInvalidArgumentException format:@"No component matching id '%@'.", key];
    }
    id returnValue = [self objectForDefinition:definition];
    [_currentlyResolvingReferences removeAllObjects];
    return returnValue;
}

/* ============================================================ Utility Methods ========================================================= */
- (NSString*)description
{
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"_registry=%@", _registry];
    [description appendString:@">"];
    return description;
}


/* ============================================================ Private Methods ========================================================= */
- (id)objectForDefinition:(SpringComponentDefinition*)definition
{
    if (definition.lifecycle == SpringComponentLifeCycleSingleton)
    {
        return [self singletonForKey:definition];
    }
    else
    {
        return [self buildInstanceWithDefinition:definition];
    }
}

- (id)singletonForKey:(SpringComponentDefinition*)definition
{
    id instance = [_singletons objectForKey:definition.key];
    if (instance == nil)
    {
        instance = [self buildInstanceWithDefinition:definition];
        [_singletons setObject:instance forKey:definition.key];
    }
    return instance;
}

- (SpringComponentDefinition*)definitionForKey:(NSString*)key
{
    for (SpringComponentDefinition* definition in _registry)
    {
        if ([definition.key isEqualToString:key])
        {
            return definition;
        }
    }
    return nil;
}

@end