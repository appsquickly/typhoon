////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "TyphoonAssemblyDefinitionBuilder.h"
#import "TyphoonAssembly.h"
#import "OCLogTemplate.h"
#import "TyphoonDefinition+Internal.h"
#import "TyphoonDefinition+Infrastructure.h"
#import "TyphoonBlockDefinition.h"
#import "TyphoonAssembly+TyphoonAssemblyFriend.h"
#import "TyphoonAssemblySelectorAdviser.h"
#import "TyphoonCircularDependencyTerminator.h"
#import "TyphoonSelector.h"
#import "TyphoonInjections.h"
#import "TyphoonUtils.h"
#import "TyphoonRuntimeArguments.h"
#import "TyphoonReferenceDefinition.h"
#import "TyphoonBlockDefinitionController.h"

#import <objc/runtime.h>
#import <objc/message.h>

static id objc_msgSend_InjectionArguments(id target, SEL selector, NSMethodSignature *signature);
static id InjectionForArgumentType(const char *argumentType, NSUInteger index);
static BOOL IsPrimitiveArgumentType(const char *argumentType);
static BOOL IsPrimitiveArgumentAllowed(id result);

@implementation TyphoonAssemblyDefinitionBuilder
{
    NSMutableDictionary *_resolveStackForSelector;
    NSMutableDictionary *_cachedDefinitionsForMethodName;
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
    // Use the configuration route for potential TyphoonBlockDefinitions.
    
    [[TyphoonBlockDefinitionController currentController] useConfigurationRouteWithinBlock:^{
        [[self.assembly definitionSelectors] enumerateObjectsUsingBlock:^(TyphoonSelector *wrappedSEL, BOOL *stop) {
            SEL selector = [wrappedSEL selector];
            NSString *key = [TyphoonAssemblySelectorAdviser keyForAdvisedSEL:selector];
            [self buildDefinitionForKey:key];
        }];
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
        
        BOOL shouldApplyConcreteNamespace = [((TyphoonDefinition *) cached) space] == nil;
        if (shouldApplyConcreteNamespace) {
            [((TyphoonDefinition *) cached) applyConcreteNamespace:NSStringFromClass([self.assembly class])];
        }
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
        d = [self populateCacheWithDefinition:d forKey:key];
    }

    return d;
}

- (id)cachedDefinitionForKey:(NSString *)key
{
    return _cachedDefinitionsForMethodName[key];
}

- (id)definitionForKey:(NSString *)key
{
    // Call the user's assembly method to get it.
    
    SEL sel = [self assemblySelectorForKey:key];

    NSMethodSignature *signature = [self.assembly methodSignatureForSelector:sel];

    id cached =
        objc_msgSend_InjectionArguments(self.assembly, sel, signature); // the advisedSEL will call through to the original, unwrapped implementation because prepareForUse has been called, and all our definition methods have been swizzled.
    // This method will likely call through to other definition methods on the assembly, which will go through the advising machinery because of this swizzling.
    // Therefore, the definitions a definition depends on will be fully constructed before they are needed to construct that definition.
    
    return cached;
}

- (SEL)assemblySelectorForKey:(NSString *)key
{
    return [TyphoonAssemblySelectorAdviser advisedSELForKey:key class:[self.assembly assemblyClassForKey:key]];
}

static id objc_msgSend_InjectionArguments(id target, SEL selector, NSMethodSignature *signature)
{
    if (signature.numberOfArguments > 2) {
        void *unsafeResult;
        NSUInteger primitiveArgumentIndex = NSNotFound;
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setSelector:selector];
        [invocation retainArguments];
        /* Fill invocation arguments with TyphoonInjectionWithRuntimeArgumentAtIndex injections */
        for (NSUInteger i = 0; i < signature.numberOfArguments - 2; i++) {
            const char *argumentType = [signature getArgumentTypeAtIndex:i + 2];
            if (!IsPrimitiveArgumentType(argumentType)) {
                id injection = InjectionForArgumentType(argumentType, i);
                [invocation setArgument:&injection atIndex:(NSInteger)(i + 2)];
            } else if (primitiveArgumentIndex == NSNotFound) {
                primitiveArgumentIndex = i;
            }
        }
        [invocation invokeWithTarget:target];
        [invocation getReturnValue:&unsafeResult];
        
        id result = (__bridge id) unsafeResult;
        
        if (primitiveArgumentIndex != NSNotFound && !IsPrimitiveArgumentAllowed(result)) {
            [NSException raise:NSInvalidArgumentException format:@"The method '%@' in assembly '%@', contains a runtime argument of primitive type (BOOL, int, CGFloat, etc) at index %@. Runtime arguments for TyphoonDefinitions can only be objects. Use TyphoonBlockDefinition, or wrappers like NSNumber or NSValue (they will be unwrapped into primitive value during injection) ", [TyphoonAssemblySelectorAdviser keyForAdvisedSEL:selector], [target class], @(primitiveArgumentIndex)];
        }
        
        return result;
    }
    else {
        return ((id (*)(id, SEL))objc_msgSend)(target, selector);
    }
}

static id InjectionForArgumentType(const char *argumentType, NSUInteger index)
{
    /** We are checking here, if argument type is block, then we have to wrap our injection into 'real' block,
    *   otherwise, during assignment runtime will try to call Block_copy and it will crash if object is not 'real' block */
    
    if (CStringEquals(argumentType, "@?")) {
        return TyphoonInjectionWithRuntimeArgumentAtIndexWrappedIntoBlock(index);
    } else {
        return TyphoonInjectionWithRuntimeArgumentAtIndex(index);
    }
}

static BOOL IsPrimitiveArgumentType(const char *argumentType)
{
    return (!CStringEquals(argumentType, "@") &&   // object
            !CStringEquals(argumentType, "@?") &&  // block
            !CStringEquals(argumentType, "#"));    // metaClass
}

static BOOL IsPrimitiveArgumentAllowed(id result)
{
    /* Primitive arguments are only allowed for TyphoonBlockDefinition */
    return [result isKindOfClass:[TyphoonBlockDefinition class]];
}

- (TyphoonDefinition *)populateCacheWithDefinition:(TyphoonDefinition *)definition forKey:(NSString *)key
{
    if (definition && [definition isKindOfClass:[TyphoonDefinition class]]) {
        definition = [self definitionBySettingKey:key toDefinition:definition];
        _cachedDefinitionsForMethodName[key] = definition;
    }
    return definition;
}

- (TyphoonDefinition *)definitionBySettingKey:(NSString *)key toDefinition:(TyphoonDefinition *)definition
{
    TyphoonDefinition *result = definition;

    if ([result.key length] == 0) {
        result.key = key;
    }
    
    if (result.processed && ![definition.key isEqualToString:key]) {
        result = [TyphoonShortcutDefinition definitionWithKey:key referringTo:definition];
    }
    
    if (!result.processed) {
        result.assembly = _assembly;
        result.assemblySelector = [self assemblySelectorForKey:key];
    }

    result.processed = YES;
    
    return result;
}

@end
