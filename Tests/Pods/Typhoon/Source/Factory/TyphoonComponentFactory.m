////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import <objc/runtime.h>
#import <objc/message.h>
#import "TyphoonComponentFactory.h"
#import "TyphoonDefinition.h"
#import "TyphoonComponentFactory+InstanceBuilder.h"


@interface TyphoonDefinition (TyphoonComponentFactory)

@property(nonatomic, strong) NSString* key;

@end

@implementation TyphoonComponentFactory

static TyphoonComponentFactory* defaultFactory;


/* =========================================================== Class Methods ============================================================ */
+ (id)defaultFactory
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
        _currentlyResolvingReferences = [[NSMutableDictionary alloc] init];
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
    return [self objectForDefinition:[self definitionForType:classOrProtocol]];
}

- (NSArray*)allComponentsForType:(id)classOrProtocol
{
    [self performMutationsIfRequired];
    NSMutableArray* results = [[NSMutableArray alloc] init];
    NSArray* definitions = [self allDefinitionsForType:classOrProtocol];
    NSLog(@"Definitions: %@", definitions);
    for (TyphoonDefinition* definition in definitions)
    {
        [results addObject:[self objectForDefinition:definition]];
    }
    [_currentlyResolvingReferences removeAllObjects];
    return [results copy];
}


- (id)componentForKey:(NSString*)key
{
    if (key)
    {
        [self performMutationsIfRequired];
        TyphoonDefinition* definition = [self definitionForKey:key];
        if (!definition)
        {
            [NSException raise:NSInvalidArgumentException format:@"No component matching id '%@'.", key];
        }
        __autoreleasing id returnValue = [self objectForDefinition:definition];
        [_currentlyResolvingReferences removeAllObjects];
        return returnValue;
    }
    return nil;
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

- (void)injectProperties:(id)instance {
    Class class = [instance class];
    for (TyphoonDefinition* definition in _registry)
    {
        if(definition.type == class)
        {
            [self injectPropertyDependenciesOn:instance withDefinition:definition];
        }
    }
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
    if (definition.scope == TyphoonScopeDefault)
    {
        return [self buildInstanceWithDefinition:definition];
    }
    else
    {
        return [self singletonForDefinition:definition];
    }
}

- (id)singletonForDefinition:(TyphoonDefinition*)definition
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

- (void)performMutationsIfRequired
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