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

static NSMutableArray* swizzleRegistry;

@interface TyphoonAssembly (BlockFactoryFriend)

+ (BOOL)selectorReserved:(SEL)selector;

- (NSMutableDictionary*)cachedSelectors;

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
    NSLog(@"Building assembly: %@", NSStringFromClass([assembly class]));
    if (![assembly isKindOfClass:[TyphoonAssembly class]])
    {
        [NSException raise:NSInvalidArgumentException format:@"Class '%@' is not a sub-class of %@", NSStringFromClass([assembly class]),
                                                             NSStringFromClass([TyphoonAssembly class])];
    }
    self = [super init];
    if (self)
    {
        [self applyBeforeAdviceToAssemblyMethods:assembly];
        NSArray* definitions = [self populateCache:assembly];
        for (TyphoonDefinition* definition in definitions)
        {
            [self register:definition];
        }
    }
    return self;
}

/* ============================================================ Private Methods ========================================================= */
- (NSArray*)populateCache:(TyphoonAssembly*)assembly
{
    @synchronized (self)
    {
        NSSet *definitionSelectors = [self obtainDefinitionSelectors:assembly];
        
        [definitionSelectors enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            objc_msgSend(assembly, (SEL)[obj pointerValue]);
        }];
        
        NSMutableDictionary* dictionary = [assembly cachedSelectors];
        return [dictionary allValues];
    }
}

- (NSSet *)obtainDefinitionSelectors:(TyphoonAssembly*)assembly
{
    NSMutableSet *definitionSelectors = [[NSMutableSet alloc] init];
    
    Class currentClass = [assembly class];
    while (strcmp(class_getName(currentClass), "TyphoonAssembly") != 0) {
        [definitionSelectors unionSet:[self obtainDefinitionSelectorsInAssemblyClass:currentClass]];
        currentClass = class_getSuperclass(currentClass);
    }
    
    return definitionSelectors;
}

- (NSSet *)obtainDefinitionSelectorsInAssemblyClass:(Class)class
{
    NSMutableSet *definitionSelectors = [[NSMutableSet alloc] init];
    
    unsigned int methodCount;
    Method* methodList = class_copyMethodList(class, &methodCount);
    for (int i = 0; i < methodCount; i++)
    {
        Method method = methodList[i];
        //            NSLog(@"Selector: %@", NSStringFromSelector(method_getName(method)));
        
        int argumentCount = method_getNumberOfArguments(method);
        if (argumentCount == 2)
        {
            SEL methodSelector = method_getName(method);
            if (![class selectorReserved:methodSelector])
            {
                [definitionSelectors addObject:[NSValue valueWithPointer:methodSelector]];
            }
        }
    }
    free(methodList);
    
    return definitionSelectors;
}

- (void)applyBeforeAdviceToAssemblyMethods:(TyphoonAssembly*)assembly
{
    @synchronized (self)
    {
        if (![swizzleRegistry containsObject:[assembly class]])
        {
            [swizzleRegistry addObject:[assembly class]];
            
            NSSet *definitionSelectors = [self obtainDefinitionSelectors:assembly];
            [definitionSelectors enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
                SEL methodSelector = (SEL)[obj pointerValue];
                SEL swizzled = NSSelectorFromString(
                                                    [NSStringFromSelector(methodSelector) stringByAppendingString:TYPHOON_BEFORE_ADVICE_SUFFIX]);
                [[assembly class] typhoon_swizzleMethod:methodSelector withMethod:swizzled error:nil];
            }];
        }
    }
}

@end