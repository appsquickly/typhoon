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


#import "TyphoonAssemblySelectorAdviser.h"
#import "TyphoonAssemblyAdviser.h"
#import "TyphoonAssembly.h"
#import <objc/runtime.h>
#import "TyphoonAssembly+TyphoonAssemblyFriend.h"
#import "OCLogTemplate.h"
#import "TyphoonSelector.h"
#import "TyphoonSwizzler.h"
#import "TyphoonIntrospectionUtils.h"

static NSMutableSet *advisedAssemblyClasses;

@interface TyphoonAssemblyAdviser ()

@end


@implementation TyphoonAssemblyAdviser

+ (void)initialize
{
    @synchronized (self) {
        advisedAssemblyClasses = [NSMutableSet new];
    }
}

- (id)initWithAssembly:(TyphoonAssembly *)assembly
{
    self = [super init];
    if (self) {
        _assembly = assembly;
        _swizzler = [TyphoonSwizzler defaultSwizzler];
    }
    return self;
}

#pragma mark - Advising

- (void)adviseAssembly
{
    @synchronized (self) {
        [self swizzleAssemblyMethods];
    }
}

- (void)swizzleAssemblyMethods
{
    [self enumerateDefinitionSelectorsUsingBlock:^(NSSet *definitionSelectors, Class assemblyClass) {
        if ([self classIsNotAlreadyAdvised:assemblyClass]) {
            [self swizzleDefinitionSelectors:definitionSelectors onAssemblyClass:assemblyClass];
        }
    }];
}

- (void)swizzleDefinitionSelectors:(NSSet *)definitionSelectors onAssemblyClass:(Class)assemblyClass
{
    [definitionSelectors enumerateObjectsUsingBlock:^(TyphoonSelector *selectorObj, BOOL *stop) {
        [self swapImplementationOfDefinitionSelectorWithAdvisedImplementation:selectorObj onAssemblyClass:assemblyClass];
    }];
    [[self class] markAsAdvisedAssemblyClass:assemblyClass];
}

- (void)swapImplementationOfDefinitionSelectorWithAdvisedImplementation:(TyphoonSelector *)wrappedSEL onAssemblyClass:(Class)assemblyClass
{
    SEL methodSelector = [wrappedSEL selector];
    SEL advisedSelector = [TyphoonAssemblySelectorAdviser advisedSELForSEL:methodSelector];

    NSError *error;
    BOOL success = [_swizzler swizzleMethod:methodSelector withMethod:advisedSelector onClass:assemblyClass error:&error];
    if (!success) {
        [TyphoonAssemblyAdviser onFailureToSwizzleDefinitionSelector:methodSelector withAdvisedSelector:advisedSelector onAssemblyClass:assemblyClass error:error];
    }
}


+ (void)onFailureToSwizzleDefinitionSelector:(SEL)methodSelector withAdvisedSelector:(SEL)swizzled onAssemblyClass:(Class)assemblyClass error:(NSError *)err
{
    LogError(@"Failed to swizzle method '%@' on class '%@' with method '%@'.", NSStringFromSelector(methodSelector), NSStringFromClass(assemblyClass), NSStringFromSelector(swizzled));
    LogError(@"'%@'", err);
    [NSException raise:NSInternalInconsistencyException format:@"Failed to swizzle method, everything is broken!"];
}

#pragma mark - Definition Selector Enumerator

/** @return Set of TyphoonSelector, pointing definitions methods */
- (NSSet *)definitionSelectors
{
    NSMutableSet *definitionSelectors = [[NSMutableSet alloc] init];

    [self enumerateDefinitionSelectorsUsingBlock:^(NSSet *selectors, Class assemblyClass) {
        [definitionSelectors unionSet:selectors];
    }];

    return definitionSelectors;
}

- (void)enumerateDefinitionSelectorsUsingBlock:(void(^)(NSSet *definitionSelectors, Class assemblyClass))block
{
    Class currentClass = [self.assembly class];
    while ([self classNotRootAssemblyClass:currentClass]) {
        NSSet *allSelectors = [self definitionSelectorsInAssemblyClass:currentClass];
        block(allSelectors, currentClass);
        currentClass = class_getSuperclass(currentClass);
    }
}

- (BOOL)classNotRootAssemblyClass:(Class)class
{
    return class != [TyphoonAssembly class];
}

- (NSSet *)definitionSelectorsInAssemblyClass:(Class)pClass
{
    NSMutableSet *definitionSelectors = [[NSMutableSet alloc] init];

    NSSet *selectorNames = [TyphoonIntrospectionUtils methodsForClass:pClass upToParentClass:[pClass superclass]];
    for (NSString *selectorName in selectorNames) {
        SEL sel = NSSelectorFromString(selectorName);
        if ([self isSelector:sel notAdvisedOnClass:pClass] && [self isSelector:sel notReservedOnClass:pClass]) {
            [definitionSelectors addObject:[TyphoonSelector selectorWithSEL:sel]];
        }
    }
    [definitionSelectors minusSet:[self propertySelectorsForClass:pClass]];

    return definitionSelectors;
}

- (BOOL)isSelector:(SEL)method notReservedOnClass:(Class)aClass
{
    return ![aClass selectorIsReserved:method];
}

- (BOOL)isSelector:(SEL)sel notAdvisedOnClass:(Class)aClass
{
    return ![TyphoonAssemblySelectorAdviser selectorIsAdvised:sel];
}

- (NSSet *)propertySelectorsForClass:(Class)clazz
{
    NSMutableSet *propertySelectors = [NSMutableSet new];
    NSSet *properties = [TyphoonIntrospectionUtils propertiesForClass:clazz upToParentClass:[clazz superclass]];
    for (NSString *propertyName in properties) {
        SEL propertySetter = [TyphoonIntrospectionUtils setterForPropertyWithName:propertyName inClass:clazz];
        if (propertySetter) {
            [propertySelectors addObject:[TyphoonSelector selectorWithSEL:propertySetter]];
        }
        SEL propertyGetter = [TyphoonIntrospectionUtils getterForPropertyWithName:propertyName inClass:clazz];
        if (propertyGetter) {
            [propertySelectors addObject:[TyphoonSelector selectorWithSEL:propertyGetter]];
        }
    }
    return propertySelectors;
}

#pragma mark - Advising Registry

- (BOOL)classIsNotAlreadyAdvised:(Class)class
{
    return ![[self class] assemblyClassIsAdvised:class];
}

+ (void)markAsAdvisedAssemblyClass:(Class)assemblyClass
{
    [advisedAssemblyClasses addObject:assemblyClass];
}

+ (void)markAsNotAdvisedAssemblyClass:(Class)assemblyClass
{
    [advisedAssemblyClasses removeObject:assemblyClass];
}

+ (BOOL)assemblyClassIsAdvised:(Class)assemblyClass
{
    return [advisedAssemblyClasses containsObject:assemblyClass];
}

@end
