//
// Created by Robert Gilliam on 11/26/13.
// Copyright (c) 2013 Jasper Blues. All rights reserved.
//


#import <Typhoon/TyphoonAssemblySelectorAdviser.h>
#import "TyphoonAssemblyAdviser.h"
#import "TyphoonAssembly.h"
#import "TyphoonJRSwizzle.h"
#import <objc/runtime.h>
#import <OCHamcrest/HCIsInstanceOf.h>

static NSMutableArray* swizzleRegistry;


@implementation TyphoonAssemblyAdviser
{

}

+ (void)initialize
{
    [super initialize];
    @synchronized (self)
    {
        swizzleRegistry = [[NSMutableArray alloc] init];
    }
}

+ (void)adviseMethods:(TyphoonAssembly*)assembly
{
    @synchronized (self)
    {
        if ([TyphoonAssemblyAdviser assemblyMethodsHaveNotYetBeenSwizzled:assembly])
        {
            [self swizzleAssemblyMethods:assembly];
        }
    }
}

+ (void)swizzleAssemblyMethods:(TyphoonAssembly*)assembly
{
    [TyphoonAssemblyAdviser markAssemblyMethodsAsSwizzled:assembly];

    NSSet* definitionSelectors = [self definitionSelectors:assembly];
    [definitionSelectors enumerateObjectsUsingBlock:^(NSValue *selectorObj, BOOL* stop)
    {
        [TyphoonAssemblyAdviser replaceImplementationOfDefinitionSelector:selectorObj withDynamicBeforeAdviceImplementationOnAssembly:assembly];
    }];
}

+ (NSSet*)definitionSelectors:(TyphoonAssembly*)assembly
{
    NSMutableSet* definitionSelectors = [[NSMutableSet alloc] init];
    [self addDefinitionSelectorsForSubclassesOfAssembly:assembly toSet:definitionSelectors];
    return definitionSelectors;
}

+ (void)addDefinitionSelectorsForSubclassesOfAssembly:(TyphoonAssembly*)assembly toSet:(NSMutableSet*)definitionSelectors
{
    Class currentClass = [assembly class];
    while ([self classNotRootAssemblyClass:currentClass])
    {
        [definitionSelectors unionSet:[self obtainDefinitionSelectorsInAssemblyClass:currentClass]];
        currentClass = class_getSuperclass(currentClass);
    }
}

+ (NSSet*)obtainDefinitionSelectorsInAssemblyClass:(Class)pClass
{
    NSMutableSet* definitionSelectors = [[NSMutableSet alloc] init];
    [self addDefinitionSelectorsInClass:pClass toSet:definitionSelectors];
    return definitionSelectors;
}

+ (void)addDefinitionSelectorsInClass:(Class)aClass toSet:(NSMutableSet*)definitionSelectors
{
    [self enumerateMethodsInClass:aClass usingBlock:^(Method method)
    {
        if ([self method:method onClassIsNotReserved:aClass])
        {
            [self addDefinitionSelectorForMethod:method toSet:definitionSelectors];
        }
    }];
}

typedef void(^MethodEnumerationBlock)(Method method);

+ (void)enumerateMethodsInClass:(Class)class usingBlock:(MethodEnumerationBlock)block;
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

+ (BOOL)method:(Method)method onClassIsNotReserved:(Class)aClass
{
    // aClass must be a subclass of TyphoonAssembly

    SEL methodSelector = method_getName(method);
    return ![aClass selectorReservedOrPropertySetter:methodSelector];
}

+ (BOOL)classNotRootAssemblyClass:(Class)currentClass;
{
    NSString* currentClassName = NSStringFromClass(currentClass);
    NSString* rootAssemblyClassName = NSStringFromClass([TyphoonAssembly class]);

    return ![currentClassName isEqualToString:rootAssemblyClassName];
}

+ (void)addDefinitionSelectorForMethod:(Method)method toSet:(NSMutableSet*)definitionSelectors
{
    SEL methodSelector = method_getName(method);
    [definitionSelectors addObject:[NSValue valueWithPointer:methodSelector]];
}


+ (BOOL)assemblyMethodsSwizzled:(TyphoonAssembly*)assembly
{
    return [swizzleRegistry containsObject:[assembly class]];
}

+ (BOOL)assemblyMethodsHaveNotYetBeenSwizzled:(TyphoonAssembly*)assembly;
{
    return ![self assemblyMethodsSwizzled:assembly];
}

+ (void)markAssemblyMethodsAsSwizzled:(TyphoonAssembly*)assembly;
{
    [swizzleRegistry addObject:[assembly class]];
}

+ (void)replaceImplementationOfDefinitionSelector:(NSValue*)obj withDynamicBeforeAdviceImplementationOnAssembly:(TyphoonAssembly*)assembly
{
    SEL methodSelector = (SEL) [obj pointerValue];
    SEL swizzled = [TyphoonAssemblySelectorAdviser advisedSELForSEL:methodSelector];
    [[assembly class] typhoon_swizzleMethod:methodSelector withMethod:swizzled error:nil];
}

@end