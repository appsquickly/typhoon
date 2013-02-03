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
#import <objc/message.h>
#import "TyphoonComponentFactory.h"
#import "TyphoonDefinition.h"
#import "TyphoonComponentFactory+InstanceBuilder.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonDefinition+BlockAssembly.h"


@interface TyphoonDefinition (TyphoonComponentFactory)

@property(nonatomic, strong) NSString* key;

@end

@implementation TyphoonComponentFactory

static TyphoonComponentFactory* defaultFactory;


/* =========================================================== Class Methods ============================================================ */
+ (TyphoonComponentFactory*)defaultFactory
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
- (void)register:(TyphoonDefinition*)definition
{
    if ([definition.key length] == 0)
    {
        NSString* uuidStr = [[NSProcessInfo processInfo] globallyUniqueString];
        definition.key = [NSString stringWithFormat:@"%@_%@", NSStringFromClass(definition.type), uuidStr];
    }
    if ([self definitionForKey:definition.key])
    {
        [NSException raise:NSInvalidArgumentException format:@"Key '%@' is already registered.", definition.key];
    }
    if ([definition.type respondsToSelector:@selector(typhoonAutoInjectedProperties)])
    {
        for (NSString* autoWired in objc_msgSend(definition.type, @selector(typhoonAutoInjectedProperties)))
        {
            [definition injectProperty:NSSelectorFromString(autoWired)];
        }
    }
    NSLog(@"Registering: %@ with key: %@", NSStringFromClass(definition.type), definition.key);
    [_registry addObject:definition];
}

- (id)componentForType:(id)classOrProtocol
{
    NSArray* candidates = [self allComponentsForType:classOrProtocol];
    if ([candidates count] == 0)
    {
        if (class_isMetaClass(object_getClass(classOrProtocol)) &&
                [classOrProtocol respondsToSelector:@selector(typhoonAutoInjectedProperties)])
        {
            NSLog(@"Class %@ wants auto-wiring. . . registering.", NSStringFromClass(classOrProtocol));
            [self register:[TyphoonDefinition withClass:classOrProtocol]];
            return [self componentForType:classOrProtocol];
        }
        [NSException raise:NSInvalidArgumentException format:@"No components defined which satisify type: '%@'",
                                                             TyphoonTypeStringFor(classOrProtocol)];
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

    for (TyphoonDefinition* definition in _registry)
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
    TyphoonDefinition* definition = [self definitionForKey:key];
    if (!definition)
    {
        [NSException raise:NSInvalidArgumentException format:@"No component matching id '%@'.", key];
    }
    __autoreleasing id returnValue = [self objectForDefinition:definition];
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
- (id)objectForDefinition:(TyphoonDefinition*)definition
{
    if (definition.lifecycle == TyphoonComponentLifeCycleSingleton)
    {
        return [self singletonForKey:definition];
    }
    else
    {
        return [self buildInstanceWithDefinition:definition];
    }
}

- (id)singletonForKey:(TyphoonDefinition*)definition
{
    @synchronized (self)
    {
        id instance = [_singletons objectForKey:definition.key];
        if (instance == nil)
        {
            instance = [self buildInstanceWithDefinition:definition];
            [_singletons setObject:instance forKey:definition.key];
        }
        return instance;
    }
}

- (TyphoonDefinition*)definitionForKey:(NSString*)key
{
    for (TyphoonDefinition* definition in _registry)
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
    @synchronized (self)
    {
        if (!_hasPerformedMutations)
        {
            NSLog(@"Running mutators. . . %@", _mutators);
            for (id <TyphoonComponentFactoryMutator> mutator in _mutators)
            {
                [mutator mutateComponentDefinitionsIfRequired:_registry];
            }
            _hasPerformedMutations = YES;
        }
    }
}

@end