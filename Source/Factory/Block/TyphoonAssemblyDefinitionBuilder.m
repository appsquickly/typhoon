//
// Created by Robert Gilliam on 12/2/13.
// Copyright (c) 2013 Jasper Blues. All rights reserved.
//


#import "TyphoonAssemblyDefinitionBuilder.h"
#import "TyphoonAssembly.h"
#import "TyphoonDefinition.h"
#import "OCLogTemplate.h"
#import "TyphoonDefinition+Infrastructure.h"
#import "TyphoonAssembly+TyphoonBlockFactoryFriend.h"
#import "TyphoonAssemblySelectorAdviser.h"
#import <objc/runtime.h>
#import "TyphoonAssemblyAdviser.h"


@implementation TyphoonAssemblyDefinitionBuilder
{
    TyphoonAssembly* _assembly;

    NSMutableDictionary* _resolveStackForSelector;
    NSMutableDictionary* _cachedDefinitionsForMethodName;
}

- (instancetype)initWithAssembly:(TyphoonAssembly*)assembly
{
    self = [super init];
    if (self)
    {
        _assembly = assembly;

        _resolveStackForSelector = [[NSMutableDictionary alloc] init];
        _cachedDefinitionsForMethodName = [[NSMutableDictionary alloc] init];
    }

    return self;
}

+ (instancetype)builderWithAssembly:(TyphoonAssembly*)assembly
{
    return [[self alloc] initWithAssembly:assembly];
}


- (id)init
{
    self = [super init];
    if (self)
    {
        _resolveStackForSelector = [[NSMutableDictionary alloc] init];
        _cachedDefinitionsForMethodName = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (NSArray*)builtDefinitions
{
    @synchronized (self)
    {
        [self populateCache];
        return [_cachedDefinitionsForMethodName allValues];
    }
}

- (void)populateCache
{
    NSSet* definitionSelectors = [TyphoonAssemblyAdviser definitionSelectors:_assembly]; // the Assembly should know what its own definition selectors are.

    [definitionSelectors enumerateObjectsUsingBlock:^(id obj, BOOL* stop)
    {
        SEL selector = (SEL) [obj pointerValue];
        NSString* key = [TyphoonAssemblySelectorAdviser keyForAdvisedSEL:selector];
        [self buildDefinitionForKey:key];
    }];
}

- (void)buildDefinitionForKey:(NSString*)key
{
    [self builtDefinitionForKey:key];
}

- (TyphoonDefinition*)builtDefinitionForKey:(NSString*)key
{
    [self markCurrentlyResolvingKey:key];

    if ([self keyInvolvedInCircularDependency:key])
    {
        return [self definitionToTerminateCircularDependencyForKey:key];
    }

    id cached = [self populateCacheWithDefinitionForKey:key];
    [self markKeyResolved:key];

    LogTrace(@"Did finish building definition for key: '%@'", key);

    return cached;
}

#pragma mark - Circular Dependencies
- (NSMutableArray*)resolveStackForKey:(NSString*)key
{
    NSMutableArray* resolveStack = [_resolveStackForSelector objectForKey:key];
    if (!resolveStack)
    {
        resolveStack = [[NSMutableArray alloc] init];
        [_resolveStackForSelector setObject:resolveStack forKey:key];
    }

    return resolveStack;
}

- (void)markCurrentlyResolvingKey:(NSString*)key
{
    [[self resolveStackForKey:key] addObject:key];
}

- (BOOL)keyInvolvedInCircularDependency:(NSString*)key
{
    NSMutableArray* resolveStack = [self resolveStackForKey:key];
    if ([resolveStack count] >= 2)
    {
        NSString* bottom = [resolveStack objectAtIndex:0];
        NSString* top = [resolveStack lastObject];
        if ([top isEqualToString:bottom])
        {
            LogTrace(@"Circular dependency detected in definition for key '%@'.", key);
            return YES;
        }
    }

    return NO;
}

- (TyphoonDefinition*)definitionToTerminateCircularDependencyForKey:(NSString*)key
{
    // we return a 'dummy' definition just to terminate the cycle. This dummy definition will be overwritten by the real one in the cache, which will be set further up the stack and will overwrite this one in 'cachedDefinitionsForMethodName'.
    return [[TyphoonDefinition alloc] initWithClass:[NSString class] key:key];
}

- (void)markKeyResolved:(NSString*)key
{
    NSMutableArray* resolveStack = [self resolveStackForKey:key];

    if (resolveStack.count)
    {
        [resolveStack removeAllObjects];
    }
}

#pragma mark - Building
- (TyphoonDefinition*)populateCacheWithDefinitionForKey:(NSString*)key
{
    id d = [self definitionForKey:key];
    [self populateCacheWithDefinition:d forKey:key];
    return d;
}

- (id)definitionForKey:(NSString*)key
{
    // call the user's assembly method to get it.
    SEL sel = [TyphoonAssemblySelectorAdviser advisedSELForKey:key];
    id cached = objc_msgSend(_assembly,
            sel); // the advisedSEL will call through to the original, unwrapped implementation because prepareForUse has been called, and all our definition methods have been swizzled.
    // This method will likely call through to other definition methods on the assembly, which will go through the advising machinery because of this swizzling.
    // Therefore, the definitions a definition depends on will be fully constructed before they are needed to construct that definition.
    return cached;
}

- (void)populateCacheWithDefinition:(TyphoonDefinition*)definition forKey:(NSString*)key
{
    if (definition && [definition isKindOfClass:[TyphoonDefinition class]])
    {
        [self setKey:key onDefinitionIfExistingKeyEmpty:definition];

        [_cachedDefinitionsForMethodName setObject:definition forKey:key];
    }
}

- (void)setKey:(NSString*)key onDefinitionIfExistingKeyEmpty:(TyphoonDefinition*)definition
{
    if ([definition.key length] == 0)
    {
        definition.key = key;
    }
}

@end