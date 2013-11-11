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
#import "TyphoonAssembly.h"
#import "TyphoonDefinition.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonAssemblySelectorAdviser.h"
#import "OCLogTemplate.h"
#import "TyphoonDefinition+Infrastructure.h"

static NSMutableDictionary* resolveStackForSelector;
static NSMutableArray* reservedSelectorsAsStrings;

@implementation TyphoonAssembly


/* ====================================================================================================================================== */
#pragma mark - Class Methods

+ (TyphoonAssembly*)assembly
{
    TyphoonAssembly* assembly = [[self alloc] init];
    [assembly resolveCollaboratingAssemblies];
    return assembly;
}

+ (TyphoonAssembly*)defaultAssembly
{
    return (TyphoonAssembly*) [TyphoonComponentFactory defaultFactory];
}

+ (void)load
{
    [super load];
    [self reserveSelectors];
}

+ (void)reserveSelectors;
{
    reservedSelectorsAsStrings = [[NSMutableArray alloc] init];

    [self markSelectorReserved:@selector(init)];
    [self markSelectorReserved:@selector(cachedDefinitionsForMethodName)];
    [self markSelectorReservedFromString:@".cxx_destruct"];
    [self markSelectorReserved:@selector(defaultAssembly)];
    [self markSelectorReserved:@selector(resolveCollaboratingAssemblies)];
}

+ (void)markSelectorReserved:(SEL)selector
{
    [self markSelectorReservedFromString:NSStringFromSelector(selector)];
}

+ (void)markSelectorReservedFromString:(NSString*)stringFromSelector
{
    [reservedSelectorsAsStrings addObject:stringFromSelector];
}

/* ====================================================================================================================================== */
#pragma mark - Instance Method Resolution

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if ([self shouldProvideDynamicImplementationFor:sel])
    {
        [self provideDynamicImplementationToConstructDefinitionForSEL:sel];
        return YES;
    }

    return [super resolveInstanceMethod:sel];
}

+ (BOOL)shouldProvideDynamicImplementationFor:(SEL)sel;
{
    return (![TyphoonAssembly selectorReservedOrPropertySetter:sel]&&[TyphoonAssemblySelectorAdviser selectorIsAdvised:sel]);
}

+ (BOOL)selectorReservedOrPropertySetter:(SEL)selector
{
    NSString* selectorString = NSStringFromSelector(selector);
    if ([reservedSelectorsAsStrings containsObject:selectorString])
    {
        return YES;
    }
    else if ([selectorString hasPrefix:@"set"]&&[selectorString hasSuffix:@":"])
    {
        return YES;
    }
    return NO;
}

+ (void)provideDynamicImplementationToConstructDefinitionForSEL:(SEL)sel;
{
    IMP imp = [self implementationToConstructDefinitionForSEL:sel];
    class_addMethod(self, sel, imp, "@");
}

+ (IMP)implementationToConstructDefinitionForSEL:(SEL)selWithAdvicePrefix
{
    return imp_implementationWithBlock((__bridge id) objc_unretainedPointer((TyphoonDefinition*) ^(id me)
    {
        NSString* key = [TyphoonAssemblySelectorAdviser keyForAdvisedSEL:selWithAdvicePrefix];
        return [self buildAndCacheDefinitionForKey:key me:me];
    }));
}

+ (TyphoonDefinition*)buildAndCacheDefinitionForKey:(NSString*)key me:(TyphoonAssembly*)me
{
    NSMutableArray* resolveStack = [self resolveStackForKey:key];
    [self markCurrentlyResolvingKey:key resolveStack:resolveStack];

    if ([self dependencyForKey:key involvedInCircularDependencyInResolveStack:resolveStack])
    {
        return [self definitionToTerminateCircularDependencyForKey:key];
    }

    id cached = [self populateCacheWithDefinitionForKey:key me:me];
    [self markKeyResolved:key resolveStack:resolveStack];

    LogTrace(@"Did finish building definition for key: '%@'", key);

    return cached;
}

+ (BOOL)dependencyForKey:(NSString*)key involvedInCircularDependencyInResolveStack:(NSArray*)resolveStack;
{
    if ([resolveStack count] >= 2)
    {
        NSString* bottom = [resolveStack objectAtIndex:0];
        NSString* top = [resolveStack objectAtIndex:[resolveStack count] - 1];
        if ([top isEqualToString:bottom])
        {
            LogTrace(@"Circular dependency detected in definition for key '%@'. Breaking the cycle.", key);
            return YES;
        }
    }

    return NO;
}

+ (TyphoonDefinition*)definitionToTerminateCircularDependencyForKey:(NSString*)key
{
    // we return a 'dummy' definition just to terminate the cycle. This dummy definition will be overwritten by the real one, which will be set further up the stack and will overwrite this one in 'cachedDefinitionsForMethodName'.
    return [[TyphoonDefinition alloc] initWithClass:[NSString class] key:key];
}

+ (NSMutableArray*)resolveStackForKey:(NSString*)key
{
    NSMutableArray* resolveStack = [resolveStackForSelector objectForKey:key];
    if (!resolveStack)
    {
        if (!resolveStackForSelector)
        {
            resolveStackForSelector = [[NSMutableDictionary alloc] init];
        }
        resolveStack = [[NSMutableArray alloc] init];
        [resolveStackForSelector setObject:resolveStack forKey:key];
    }
    return resolveStack;
}

+ (void)markCurrentlyResolvingKey:(NSString*)key resolveStack:(NSMutableArray*)resolveStack
{
    [resolveStack addObject:key];
}

+ (TyphoonDefinition*)populateCacheWithDefinitionForKey:(NSString*)key me:(TyphoonAssembly*)me;
{
    id d = [self definitionByCallingAssemblyMethodForKey:key me:me];
    [self populateCacheWithDefinition:d forKey:key me:me];
    return d;
}

+ (id)definitionByCallingAssemblyMethodForKey:(NSString*)key me:(TyphoonAssembly*)me
{
    SEL sel = [TyphoonAssemblySelectorAdviser advisedSELForKey:key];
    id cached = objc_msgSend(me,
            sel); // the advisedSEL will call through to the original, unwrapped implementation because of the active swizzling.
    return cached;
}

+ (void)populateCacheWithDefinition:(TyphoonDefinition*)cached forKey:(NSString*)key me:(TyphoonAssembly*)me
{
    if (cached&&[cached isKindOfClass:[TyphoonDefinition class]])
    {
        TyphoonDefinition* definition = (TyphoonDefinition*) cached;
        [self setKey:key onDefinitionIfExistingKeyEmpty:definition];

        [[me cachedDefinitionsForMethodName] setObject:definition forKey:key];
    }
}

+ (void)setKey:(NSString*)key onDefinitionIfExistingKeyEmpty:(TyphoonDefinition*)definition
{
    if ([definition.key length] == 0)
    {
        definition.key = key;
    }
}

+ (void)markKeyResolved:(NSString*)key resolveStack:(NSMutableArray*)resolveStack
{
    if (resolveStack.count)
    {
        [resolveStack removeAllObjects];
    }
}

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)init
{
    self = [super init];
    if (self)
    {
        _cachedDefinitions = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    LogTrace(@"$$$$$$ %@ in dealloc!", [self class]);
}

/* ====================================================================================================================================== */
#pragma mark - Interface Methods

- (void)resolveCollaboratingAssemblies
{
}

/* ====================================================================================================================================== */
#pragma mark - Private Methods

- (NSMutableDictionary*)cachedDefinitionsForMethodName
{
    return _cachedDefinitions;
}



@end