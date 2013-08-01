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
#import "TyphoonBlockComponentFactory.h"
#import "TyphoonAssembly.h"
#import "TyphoonDefinition.h"
#import "TyphoonJRSwizzle.h"
#import "TyphoonAssemblySelectorWrapper.h"
#import "OCLogTemplate.h"

static NSMutableArray* swizzleRegistry;

@interface TyphoonAssembly (BlockFactoryFriend)

+ (BOOL)selectorReserved:(SEL)selector;

- (NSMutableDictionary*)cachedDefinitionsForMethodName;

@end

@implementation TyphoonBlockComponentFactory

/* =========================================================== Class Methods ============================================================ */
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if ([super resolveInstanceMethod:sel] == NO)
    {
        IMP imp = imp_implementationWithBlock((__bridge id) objc_unretainedPointer(^(id me)
        {
            return [me componentForKey:NSStringFromSelector(sel)];
        }));
        class_addMethod(self, sel, imp, "@");
        return YES;
    }
    return NO;
}

+ (void)initialize
{
    [super initialize];
    @synchronized (self)
    {
        swizzleRegistry = [[NSMutableArray alloc] init];
    }
}


+ (id)factoryWithAssembly:(TyphoonAssembly*)assembly
{
    return [[[self class] alloc] initWithAssembly:assembly];
}

/* ============================================================ Initializers ============================================================ */
- (id)initWithAssembly:(TyphoonAssembly*)assembly;
{
    LogTrace(@"Building assembly: %@", NSStringFromClass([assembly class]));
    if (![assembly isKindOfClass:[TyphoonAssembly class]])
    {
        [NSException raise:NSInvalidArgumentException format:@"Class '%@' is not a sub-class of %@", NSStringFromClass([assembly class]),
                                                             NSStringFromClass([TyphoonAssembly class])];
    }
    self = [super init];
    if (self)
    {
        [self applyBeforeAdviceToAssemblyMethods:assembly];
        NSArray* definitions = [self definitionsByPopulatingCache:assembly];
        for (TyphoonDefinition* definition in definitions)
        {
            [self register:definition];
        }
    }
    return self;
}

- (void)applyBeforeAdviceToAssemblyMethods:(TyphoonAssembly*)assembly
{
    @synchronized (self)
    {
        if ([self assemblyMethodsHaveNotYetBeenSwizzled:assembly])
        {
            [self swizzleAssemblyMethods:assembly];
        }
    }
}

- (BOOL)assemblyMethodsHaveNotYetBeenSwizzled:(TyphoonAssembly *)assembly;
{
    return ![swizzleRegistry containsObject:[assembly class]];
}

- (void)swizzleAssemblyMethods:(TyphoonAssembly *)assembly;
{
    [self markAssemblyMethodsAsSwizzled:assembly];
    
    NSSet *definitionSelectors = [self obtainDefinitionSelectors:assembly];
    [definitionSelectors enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        [self replaceImplementationOfDefinitionOnAssembly:assembly withDynamicBeforeAdviceImplementation:obj];
    }];
}

- (void)markAssemblyMethodsAsSwizzled:(TyphoonAssembly *)assembly;
{
    [swizzleRegistry addObject:[assembly class]];
}

- (NSSet *)obtainDefinitionSelectors:(TyphoonAssembly*)assembly
{
    NSMutableSet *definitionSelectors = [[NSMutableSet alloc] init];
    [self addDefinitionSelectorsForSubclassesOfAssembly:assembly toSet:definitionSelectors];
    return definitionSelectors;
}

- (void)addDefinitionSelectorsForSubclassesOfAssembly:(TyphoonAssembly *)assembly toSet:(NSMutableSet *)definitionSelectors
{
    Class currentClass = [assembly class];
    while ([self classNotRootAssemblyClass:currentClass]) {
        [definitionSelectors unionSet:[self obtainDefinitionSelectorsInAssemblyClass:currentClass]];
        currentClass = class_getSuperclass(currentClass);
    }
}

- (BOOL)classNotRootAssemblyClass:(Class)currentClass;
{
    return ![NSStringFromClass(currentClass) isEqualToString:NSStringFromClass([TyphoonAssembly class])];
}

- (NSSet *)obtainDefinitionSelectorsInAssemblyClass:(Class)class
{
    NSMutableSet *definitionSelectors = [[NSMutableSet alloc] init];
    [self addDefinitionSelectorsInClass:class toSet:definitionSelectors];
    return definitionSelectors;
}

- (void)addDefinitionSelectorsInClass:(Class)aClass toSet:(NSMutableSet *)definitionSelectors
{
    [self enumerateMethodsInClass:aClass usingBlock:^(Method method) {
        if ([self method:method onClassIsDefinitionSelector:aClass]) {
            [self addDefinitionSelectorForMethod:method toSet:definitionSelectors];
        }
    }];
}

typedef void(^MethodEnumerationBlock)(Method method);
- (void)enumerateMethodsInClass:(Class)class usingBlock:(MethodEnumerationBlock)block;
{
    unsigned int methodCount;
    Method* methodList = class_copyMethodList(class, &methodCount);
    for (int i = 0; i < methodCount; i++)
    {
        Method method = methodList[i];
        block(method);
    }
    free(methodList);
}

- (BOOL)method:(Method)method onClassIsDefinitionSelector:(Class)aClass;
{
    return ([self method:method onClassIsNotReserved:aClass]);
}

- (BOOL)method:(Method)method onClassIsNotReserved:(Class)aClass;
{
    SEL methodSelector = method_getName(method);
    return ![aClass selectorReserved:methodSelector];
}

- (void)addDefinitionSelectorForMethod:(Method)method toSet:(NSMutableSet *)definitionSelectors
{
    SEL methodSelector = method_getName(method);
    [definitionSelectors addObject:[NSValue valueWithPointer:methodSelector]];
}

- (void)replaceImplementationOfDefinitionOnAssembly:(TyphoonAssembly *)assembly withDynamicBeforeAdviceImplementation:(id)obj;
{
    SEL methodSelector = (SEL)[obj pointerValue];
    SEL swizzled = [TyphoonAssemblySelectorWrapper wrappedSELForSEL:methodSelector];
    [[assembly class] typhoon_swizzleMethod:methodSelector withMethod:swizzled error:nil];
}

- (NSArray*)definitionsByPopulatingCache:(TyphoonAssembly*)assembly
{
    @synchronized (self)
    {
        NSSet *definitionSelectors = [self obtainDefinitionSelectors:assembly];
        
        [definitionSelectors enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            objc_msgSend(assembly, (SEL)[obj pointerValue]);
        }];
        
        NSMutableDictionary* dictionary = [assembly cachedDefinitionsForMethodName];
        return [dictionary allValues];
    }
}

@end