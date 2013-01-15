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
#import "SpringComponentFactoryMutator.h"


@interface SpringComponentDefinition (SpringComponentFactory)

@property(nonatomic, strong) NSString* key;

@end

@implementation SpringComponentFactory

static SpringComponentFactory* defaultFactory;


/* =========================================================== Class Methods ============================================================ */
+ (SpringComponentFactory*)defaultFactory
{
    return defaultFactory;
}

/* ============================================================ Initializers ============================================================ */
- (id)init
{
    self = [super init];
    if (self)
    {
        _registry = [[NSMutableArray alloc] init];
        _singletons = [[NSMutableDictionary alloc] init];
        _currentlyResolvingReferences = [[NSMutableSet alloc] init];
        _mutators = [[NSMutableArray alloc] init];
        _hasPerformedMutations = NO;
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
    if ([definition.key length] == 0)
    {
        NSString* uuidStr = [[NSProcessInfo processInfo] globallyUniqueString];
        definition.key = [NSString stringWithFormat:@"%@%@", NSStringFromClass(definition.type), uuidStr];
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
    [self performMutations];
    NSMutableArray* results = [[NSMutableArray alloc] init];
    BOOL isClass = class_isMetaClass(object_getClass(classOrProtocol));

    for (SpringComponentDefinition* definition in _registry)
    {
        if (isClass)
        {
            if (definition.type == classOrProtocol || [definition.type isSubclassOfClass:classOrProtocol])
            {
                [self assertNotCircularDependency:definition.key];
                [results addObject:[self objectForDefinition:definition]];
            }
        }
        else
        {
            if ([definition.type conformsToProtocol:classOrProtocol])
            {
                [self assertNotCircularDependency:definition.key];
                [results addObject:[self objectForDefinition:definition]];
            }
        }
    }
    [_currentlyResolvingReferences removeAllObjects];
    return [results copy];
}


- (id)componentForKey:(NSString*)key
{
    [self performMutations];
    [self assertNotCircularDependency:key];
    SpringComponentDefinition* definition = [self definitionForKey:key];
    if (!definition)
    {
        [NSException raise:NSInvalidArgumentException format:@"No component matching id '%@'.", key];
    }
    id returnValue = [self objectForDefinition:definition];
    [_currentlyResolvingReferences removeAllObjects];
    return returnValue;
}

- (void)makeDefault
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
{
    defaultFactory = self;
});
}

- (NSArray*)registry
{
    return [_registry copy];
}

- (void)attachMutator:(id)mutator
{
    NSLog(@"Attaching mutator: %@", mutator);
    [_mutators addObject:mutator];
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
    @synchronized (self)
    {
        id instance = [_singletons objectForKey:definition.key];
        if (instance == nil)
        {
            instance = [self buildInstanceWithDefinition:definition];
            NSLog(@"Setting %@ for key %@", instance, definition.key);
            [_singletons setObject:instance forKey:definition.key];
        }
        return instance;
    }
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

- (void)assertNotCircularDependency:(NSString*)key
{
    if ([_currentlyResolvingReferences containsObject:key])
    {
        [NSException raise:NSInvalidArgumentException format:@"Circular dependency detected: %@", _currentlyResolvingReferences];
    }
    [_currentlyResolvingReferences addObject:key];
}

- (void)performMutations
{
    if (!_hasPerformedMutations)
    {
        NSLog(@"Running mutators. . . %@", _mutators);
        for (id <SpringComponentFactoryMutator> mutator in _mutators)
        {
            [mutator mutateComponentDefinitionsIfRequired:_registry];
        }
        _hasPerformedMutations = YES;
    }
}

@end