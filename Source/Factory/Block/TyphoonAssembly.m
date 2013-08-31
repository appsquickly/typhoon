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
#import "TyphoonJRSwizzle.h"
#import "TyphoonDefinition.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonAssemblySelectorAdviser.h"
#import "OCLogTemplate.h"

static NSMutableDictionary *resolveStackForKey;
static NSMutableArray *reservedSelectorsAsStrings;

@implementation TyphoonAssembly


/* ====================================================================================================================================== */
#pragma mark - Class Methods

+ (TyphoonAssembly*)assembly
{
    return [[[self class] alloc] init];
}

+ (TyphoonAssembly*)defaultAssembly
{
    return (TyphoonAssembly*) [TyphoonComponentFactory defaultFactory];
}

+ (void)load
{
    [super load];
    resolveStackForKey = [[NSMutableDictionary alloc] init];
    [self reserveSelectors];
}

+ (void)reserveSelectors;
{
  reservedSelectorsAsStrings = [[NSMutableArray alloc] init];
  
  [self markSelectorReserved:@selector(init)];
  [self markSelectorReserved:@selector(cachedDefinitionsForMethodName)];
  [self markSelectorReservedFromString:@".cxx_destruct"];
  [self markSelectorReserved:@selector(defaultAssembly)];
}

+ (void)markSelectorReserved:(SEL)selector
{
  [self markSelectorReservedFromString:NSStringFromSelector(selector)];
}

+ (void)markSelectorReservedFromString:(NSString *)stringFromSelector
{
  [reservedSelectorsAsStrings addObject:stringFromSelector];
}

#pragma mark - Instance Method Resolution
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if ([self shouldProvideDynamicImplementationFor:sel]) {
        [self provideDynamicImplementationToConstructDefinitionForSEL:sel];
        return YES;
    }
    
    return [super resolveInstanceMethod:sel];
}

+ (BOOL)shouldProvideDynamicImplementationFor:(SEL)sel;
{
    return (![TyphoonAssembly selectorReserved:sel] && [TyphoonAssemblySelectorAdviser selectorIsAdvised:sel]);
}

+ (BOOL)selectorReserved:(SEL)selector
{
  return [reservedSelectorsAsStrings containsObject:NSStringFromSelector(selector)];
}

+ (void)provideDynamicImplementationToConstructDefinitionForSEL:(SEL)sel;
{
    IMP imp = [self implementationToConstructDefinitionForSEL:sel];
    class_addMethod(self, sel, imp, "@");
}

+ (IMP)implementationToConstructDefinitionForSEL:(SEL)selWithAdvicePrefix
{
    return imp_implementationWithBlock((__bridge id) objc_unretainedPointer((TyphoonDefinition *)^(id me)
       {
           NSString *key = [TyphoonAssemblySelectorAdviser keyForAdvisedSEL:selWithAdvicePrefix];
           return [self definitionForKey:key me:me];
       }));
}

+ (TyphoonDefinition *)definitionForKey:(NSString *)key me:(id)me
{
    LogTrace(@"Resolving request for definition for key: %@", key);

    TyphoonDefinition *cached = [self cachedDefinitionForKey:key me:me];
    if (!cached)
    {
        LogTrace(@"Definition for key: '%@' is not cached, building...", key);
        return [self buildDefinitionForKey:key me:me];
    }
        
    LogTrace(@"Using cached definition for key '%@.'", key);
    return cached;
}

+ (TyphoonDefinition *)cachedDefinitionForKey:(NSString *)key me:(id)me
{
    return [[me cachedDefinitionsForMethodName] objectForKey:key];
}

+ (TyphoonDefinition *)buildDefinitionForKey:(NSString *)key me:(TyphoonAssembly *)me;
{
    NSMutableArray *resolveStack = [self resolveStackForKey:key];
    [self markCurrentlyResolvingKey:key resolveStack:resolveStack];
    
    if ([self dependencyForKey:key involvedInCircularDependencyInResolveStack:resolveStack]) {
        return [self definitionToTerminateCircularDependencyForKey:key];
    }
    
    id cached = [self populateCacheWithDefinitionForKey:key me:me];
    [self markKeyResolved:key resolveStack:resolveStack];
    
    LogTrace(@"Did finish building definition for key: '%@'", key);
    
    return cached;
}

+ (BOOL)dependencyForKey:(NSString *)key involvedInCircularDependencyInResolveStack:(NSArray *)resolveStack;
{
    if ([resolveStack count] >= 2)
    {
        NSString* bottom = [resolveStack objectAtIndex:0];
        NSString* top = [resolveStack objectAtIndex:[resolveStack count] - 1];
        if ([top isEqualToString:bottom])
        {
            LogInfo(@"Circular dependency detected in definition for key '%@'. Breaking the cycle.", key);
            return YES;
        }
    }
    
    return NO;
}

+ (TyphoonDefinition *)definitionToTerminateCircularDependencyForKey:(NSString *)key
{
    // we return a 'dummy' definition just to terminate the cycle. This dummy definition will be overwritten by the real one, which will be set further up the stack and will overwrite this one in 'cachedDefinitionsForMethodName'.
    return [[TyphoonDefinition alloc] initWithClass:[NSString class] key:key];
}

+ (NSMutableArray *)resolveStackForKey:(NSString *)key
{
    NSMutableArray *resolveStack = [resolveStackForKey objectForKey:key];
    if (!resolveStack) {
        resolveStack = [[NSMutableArray alloc] init];
        [resolveStackForKey setObject:resolveStack forKey:key];
    }
    return resolveStack;
}

+ (void)markCurrentlyResolvingKey:(NSString *)key resolveStack:(NSMutableArray *)resolveStack
{
    [resolveStack addObject:key];
}

+ (TyphoonDefinition *)populateCacheWithDefinitionForKey:(NSString *)key me:(TyphoonAssembly *)me;
{
    id d = [self definitionByCallingAssemblyMethodForKey:key me:me];
    [self populateCacheWithDefinition:d forKey:key me:me];
    return d;
}

+ (id)definitionByCallingAssemblyMethodForKey:(NSString *)key me:(TyphoonAssembly *)me
{
    SEL sel = [TyphoonAssemblySelectorAdviser advisedSELForKey:key];
    id cached = objc_msgSend(me, sel); // the advisedSEL will call through to the original, unwrapped implementation because of the active swizzling.
    return cached;
}

+ (void)populateCacheWithDefinition:(TyphoonDefinition *)cached forKey:(NSString *)key me:(id)me
{
    if (cached && [cached isKindOfClass:[TyphoonDefinition class]])
    {
        TyphoonDefinition* definition = (TyphoonDefinition*) cached;
        [self setKey:key onDefinitionIfExistingKeyEmpty:definition];
        
        [[me cachedDefinitionsForMethodName] setObject:definition forKey:key];
    }
}

+ (void)setKey:(NSString *)key onDefinitionIfExistingKeyEmpty:(TyphoonDefinition *)definition
{
    if ([definition.key length] == 0)
    {
        definition.key = key;
    }
}

+ (void)markKeyResolved:(NSString *)key resolveStack:(NSMutableArray *)resolveStack
{
    if (resolveStack.count) {
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
#pragma mark - Private Methods

- (NSMutableDictionary*)cachedDefinitionsForMethodName
{
    return _cachedDefinitions;
}


@end