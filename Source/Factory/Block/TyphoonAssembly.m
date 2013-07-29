////////////////////////////////////////////////////////////////////////////////
//
//  AppsQuick.ly
//  Copyright 2013 AppsQuick.ly
//  All Rights Reserved.
//
//  NOTICE: AppsQuick.ly permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import <objc/runtime.h>
#import <objc/message.h>
#import "TyphoonAssembly.h"
#import "TyphoonJRSwizzle.h"
#import "TyphoonDefinition.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonAssemblySelectorWrapper.h"

static NSMutableDictionary *resolveStackForKey;

@implementation TyphoonAssembly


/* =========================================================== Class Methods ============================================================ */
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
    return (![TyphoonAssembly selectorReserved:sel] && [TyphoonAssemblySelectorWrapper selectorIsWrapped:sel]);
}

+ (BOOL)selectorReserved:(SEL)selector
{
    return selector == @selector(init) || selector == @selector(cachedDefinitionsForMethodName) || selector == NSSelectorFromString(@".cxx_destruct") ||
    selector == @selector(defaultAssembly);
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
           NSString *key = [TyphoonAssemblySelectorWrapper keyForWrappedSEL:selWithAdvicePrefix];
           return [self definitionForKey:key me:me];
       }));
}

+ (TyphoonDefinition *)definitionForKey:(NSString *)key me:(id)me
{
    NSLog(@"Resolving request for definition for key: %@", key);

    TyphoonDefinition *cached = [self cachedDefinitionForKey:key me:me];
    if (!cached)
    {
        NSLog(@"Definition for key: '%@' is not cached, building...", key);
        return [self buildDefinitionForKey:key me:me];
    }
        
    NSLog(@"Using cached definition for key '%@.'", key);
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
    
    NSLog(@"Did finish building definition for key: '%@'", key);
    
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
            NSLog(@"Circular dependency detected in definition for key '%@'. Breaking the cycle.", key);
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
    NSLog(@"Definition resolve stack: '%@' for key: '%@'", resolveStack, key);
}

+ (TyphoonDefinition *)populateCacheWithDefinitionForKey:(NSString *)key me:(TyphoonAssembly *)me;
{
    id d = [self definitionByCallingAssemblyMethodForKey:key me:me];
    [self populateCacheWithDefinition:d forKey:key me:me];
    return d;
}

+ (id)definitionByCallingAssemblyMethodForKey:(NSString *)key me:(TyphoonAssembly *)me
{
    SEL sel = [TyphoonAssemblySelectorWrapper wrappedSELForKey:key];
    id cached = objc_msgSend(me, sel); // the wrappedSEL will call through to the original, unwrapped implementation because of the active swizzling.
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
        NSLog(@"Will clear definition resolve stack: '%@' for key: '%@'", resolveStack, key);
        [resolveStack removeAllObjects];
    }
}

#pragma mark - Initializers
/* ============================================================ Initializers ============================================================ */
- (id)init
{
    self = [super init];
    if (self)
    {
        _cachedDefinitions = [[NSMutableDictionary alloc] init];
    }
    return self;
}

/* ============================================================ Utility Methods ========================================================= */
- (void)dealloc
{
    NSLog(@"$$$$$$ %@ in dealloc!", [self class]);
}

/* ============================================================ Private Methods ========================================================= */
- (NSMutableDictionary*)cachedDefinitionsForMethodName
{
    return _cachedDefinitions;
}


@end