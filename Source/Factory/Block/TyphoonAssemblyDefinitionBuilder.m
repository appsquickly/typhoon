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


#import "TyphoonAssemblyDefinitionBuilder.h"
#import "TyphoonAssembly.h"
#import "TyphoonDefinition.h"
#import "OCLogTemplate.h"
#import "TyphoonDefinition+Infrastructure.h"
#import "TyphoonAssembly+TyphoonAssemblyFriend.h"
#import "TyphoonAssemblySelectorAdviser.h"
#import <objc/message.h>
#import "TyphoonCircularDependencyTerminator.h"
#import "TyphoonSelector.h"
#import "TyphoonInjections.h"

@implementation TyphoonAssemblyDefinitionBuilder
{
    NSMutableDictionary *_resolveStackForSelector;
    NSMutableDictionary *_cachedDefinitionsForMethodName;
}

+ (instancetype)builderWithAssembly:(TyphoonAssembly *)assembly
{
    return [[self alloc] initWithAssembly:assembly];
}

- (instancetype)initWithAssembly:(TyphoonAssembly *)assembly
{
    self = [super init];
    if (self) {
        _assembly = assembly;

        _resolveStackForSelector = [[NSMutableDictionary alloc] init];
        _cachedDefinitionsForMethodName = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (NSArray *)builtDefinitions
{
    @synchronized (self) {
        [self populateCache];
        return [_cachedDefinitionsForMethodName allValues];
    }
}

- (void)populateCache
{
    [[self.assembly definitionSelectors] enumerateObjectsUsingBlock:^(TyphoonSelector *wrappedSEL, BOOL *stop) {
        SEL selector = [wrappedSEL selector];
        NSString *key = [TyphoonAssemblySelectorAdviser keyForAdvisedSEL:selector];
        [self buildDefinitionForKey:key];
    }];
}

- (void)buildDefinitionForKey:(NSString *)key
{
    [self builtDefinitionForKey:key args:nil];
}

- (TyphoonDefinition *)builtDefinitionForKey:(NSString *)key args:(TyphoonRuntimeArguments *)args
{
    [self markCurrentlyResolvingKey:key];

    if ([self keyInvolvedInCircularDependency:key]) {
        return [self definitionToTerminateCircularDependencyForKey:key args:args];
    }

    id cached = [self populateCacheWithDefinitionForKey:key];
    [self markKeyResolved:key];

    if ([cached isKindOfClass:[TyphoonDefinition class]]) {
        /* Set current runtime args to know passed arguments when build definition */
        ((TyphoonDefinition *) cached).currentRuntimeArguments = args;
    }

    LogTrace(@"Did finish building definition for key: '%@'", key);

    return cached;
}

#pragma mark - Circular Dependencies
- (NSMutableArray *)resolveStackForKey:(NSString *)key
{
    NSMutableArray *resolveStack = [_resolveStackForSelector objectForKey:key];
    if (!resolveStack) {
        resolveStack = [[NSMutableArray alloc] init];
        [_resolveStackForSelector setObject:resolveStack forKey:key];
    }

    return resolveStack;
}

- (void)markCurrentlyResolvingKey:(NSString *)key
{
    [[self resolveStackForKey:key] addObject:key];
}

- (BOOL)keyInvolvedInCircularDependency:(NSString *)key
{
    NSMutableArray *resolveStack = [self resolveStackForKey:key];
    if ([resolveStack count] >= 2) {
        NSString *bottom = [resolveStack objectAtIndex:0];
        NSString *top = [resolveStack lastObject];
        if ([top isEqualToString:bottom]) {
            LogTrace(@"Circular dependency detected in definition for key '%@'.", key);
            return YES;
        }
    }

    return NO;
}

- (TyphoonDefinition *)definitionToTerminateCircularDependencyForKey:(NSString *)key args:(TyphoonRuntimeArguments *)args
{
    // we return a 'dummy' definition just to terminate the cycle. This dummy definition will be overwritten by the real one in the cache,
    // which will be set further up the stack and will overwrite this one in 'cachedDefinitionsForMethodName'.
    TyphoonDefinition *dummy = [[TyphoonDefinition alloc] initWithClass:[TyphoonCircularDependencyTerminator class] key:key];
    dummy.currentRuntimeArguments = args;
    return dummy;
}

- (void)markKeyResolved:(NSString *)key
{
    NSMutableArray *resolveStack = [self resolveStackForKey:key];

    if (resolveStack.count) {
        [resolveStack removeAllObjects];
    }
}

#pragma mark - Building
- (TyphoonDefinition *)populateCacheWithDefinitionForKey:(NSString *)key
{
    id d = [self cachedDefinitionForKey:key];

    if (!d) {
        d = [self definitionForKey:key];
        [self populateCacheWithDefinition:d forKey:key];
    }

    return d;
}

- (id)cachedDefinitionForKey:(NSString *)key
{
    return _cachedDefinitionsForMethodName[key];
}

- (id)definitionForKey:(NSString *)key
{
    // call the user's assembly method to get it.
    SEL sel = [TyphoonAssemblySelectorAdviser advisedSELForKey:key];

    // Using signature of original (not-adviced) method because they are same and signature
    // of method created at runtime are wrong
    NSMethodSignature *signature = [self.assembly methodSignatureForSelector:NSSelectorFromString(key)];

    id cached =
        objc_msgSend_InjectionArguments(self.assembly, sel, signature); // the advisedSEL will call through to the original, unwrapped implementation because prepareForUse has been called, and all our definition methods have been swizzled.
    // This method will likely call through to other definition methods on the assembly, which will go through the advising machinery because of this swizzling.
    // Therefore, the definitions a definition depends on will be fully constructed before they are needed to construct that definition.
    return cached;
}

static id objc_msgSend_InjectionArguments(id target, SEL selector, NSMethodSignature *signature) {
    if (signature.numberOfArguments > 2) {
        void *result;
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setSelector:selector];
        [invocation retainArguments];
        /* Fill invocation arguments with TyphoonInjectionWithRuntimeArgumentAtIndex injections */
        for (int i = 0; i < signature.numberOfArguments - 2; i++) {
            id injection = TyphoonInjectionWithRuntimeArgumentAtIndex(i);
            [invocation setArgument:&injection atIndex:i + 2];
        }
        [invocation invokeWithTarget:target];
        [invocation getReturnValue:&result];
        return (__bridge id) result;
    }
    else {
        return objc_msgSend(target, selector);
    }
}

- (void)populateCacheWithDefinition:(TyphoonDefinition *)definition forKey:(NSString *)key
{
    if (definition && [definition isKindOfClass:[TyphoonDefinition class]]) {
        [self setKey:key onDefinitionIfExistingKeyEmpty:definition];

        [_cachedDefinitionsForMethodName setObject:definition forKey:key];
    }
}

- (void)setKey:(NSString *)key onDefinitionIfExistingKeyEmpty:(TyphoonDefinition *)definition
{
    if ([definition.key length] == 0) {
        definition.key = key;
    }
}

@end