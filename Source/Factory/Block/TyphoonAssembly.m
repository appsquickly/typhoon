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
#import "OCLogTemplate.h"
#import "TyphoonRuntimeObjectPlaceholder.h"

static NSMutableDictionary *resolveStackForKey;
static NSMutableArray *reservedSelectorsAsStrings;

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
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if ([[self class] shouldProvideDynamicImplementationFor:aSelector]) {
        return [[self class] methodSignatureForDynamicImplementationOf:aSelector];
    }
    
    return [super methodSignatureForSelector:aSelector];
}

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

+ (char *)typesForAssemblyMethodWithUserArguments:(NSUInteger)args
{
    char *types = malloc([self sizeOfTypesForMethodWithUserArguments:args]);
    
    [self setReturnValueAndHiddenArgumentTypes:types];
    [self setTypes:types forUserArgumentsOfTypeId:args];
    [self setNullTerminator:types afterUserArguments:args];
    
    return types;
}

+ (void)setReturnValueAndHiddenArgumentTypes:(char *)types;
{
    types[0] = '@';
    types[1] = '@';
    types[2] = ':';
}

+ (void)setTypes:(char *)types forUserArgumentsOfTypeId:(NSUInteger)args
{
    for (NSUInteger i = offsetForReturnValueAndHiddenArguments(); i < offsetForReturnValueAndHiddenArguments() + args; i++) {
        types[i] = '@';
    }
}

+ (void)setNullTerminator:(char *)types afterUserArguments:(NSUInteger)args;
{
    types[args + offsetForReturnValueAndHiddenArguments()] = '\0';
}

int offsetForReturnValueAndHiddenArguments()
{
    return 1 + 2;
}


+ (size_t)sizeOfTypesForMethodWithUserArguments:(NSUInteger)args
{
    return [self sizeOfTypesForUserArguments:args] + [self sizeOfTypesForHiddenArguments] + [self sizeOfTypesForReturnValueAndNullTerminator];
}

+ (size_t)sizeOfTypesForUserArguments:(NSUInteger)args
{
    return sizeof(char) * args;
}

+ (size_t)sizeOfTypesForHiddenArguments
{
    return sizeof(char) * 2;
}

+ (size_t)sizeOfTypesForReturnValueAndNullTerminator
{
    return sizeof(char) * 2;
}

+ (NSMethodSignature *)methodSignatureForDynamicImplementationOf:(SEL)aSelector;
{
    NSUInteger args = [self numberOfUserArgumentsInSelector:aSelector];
    char *types = [self typesForAssemblyMethodWithUserArguments:args];
    return [NSMethodSignature signatureWithObjCTypes:types];
}

+ (NSUInteger)numberOfUserArgumentsInSelector:(SEL)selector;
{
    NSString *original = NSStringFromSelector(selector);
    NSString *withArgumentsRemoved = [original stringByReplacingOccurrencesOfString:@":" withString:@""];
    return ([original length] - [withArgumentsRemoved length]);
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
           NSString *key = [TyphoonAssemblySelectorWrapper keyForWrappedSEL:selWithAdvicePrefix];
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
    SEL sel = [TyphoonAssemblySelectorWrapper wrappedSELForKey:key];
    id cached = [self definitionByCallingAssemblyMethodForSelector:sel me:me];
    return cached;
}

+ (id)definitionByCallingAssemblyMethodForSelector:(SEL)sel me:(TyphoonAssembly *)me;
{
    NSMethodSignature *sig = [me methodSignatureForSelector:sel];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation setTarget:me];
    [invocation setSelector:sel];
    
    NSUInteger args = [self numberOfUserArgumentsInSelector:sel];
    
    NSMutableArray *placeholders = [NSMutableArray arrayWithCapacity:args]; // make sure arc realizes that the placeholder should be held onto until this method returns (instead of until a single turn of the for loop below). this is better than telling the invocation to retain arguments, as it avoids having to CFRelease?
    for (NSUInteger aUserArgumentIndex = 0; aUserArgumentIndex < args; aUserArgumentIndex++) {
        TyphoonRuntimeObjectPlaceholder *aPlaceholder = [[TyphoonRuntimeObjectPlaceholder alloc] initWithIndexInArguments:aUserArgumentIndex];
        [invocation setArgument:&aPlaceholder atIndex:aUserArgumentIndex + 2];
        [placeholders addObject:aPlaceholder];
    }
    
    [invocation invoke];
    
    __unsafe_unretained id returnedValue;
    [invocation getReturnValue:&returnedValue];
    return returnedValue;
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
    LogTrace(@"$$$$$$ %@ in dealloc!", [self class]);
}

/* ============================================================ Private Methods ========================================================= */
- (NSMutableDictionary*)cachedDefinitionsForMethodName
{
    return _cachedDefinitions;
}


@end