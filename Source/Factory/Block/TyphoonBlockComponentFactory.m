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
        unsigned int methodCount;
        Method* methodList = class_copyMethodList([assembly class], &methodCount);
        for (int i = 0; i < methodCount; i++)
        {
            Method method = methodList[i];
//            NSLog(@"Selector: %@", NSStringFromSelector(method_getName(method)));

            int argumentCount = method_getNumberOfArguments(method);
            if (argumentCount == 2)
            {
                SEL methodSelector = method_getName(method);
                if (![[assembly class] selectorReserved:methodSelector])
                {
                    objc_msgSend(assembly, methodSelector);
                }
            }
        }
        NSMutableDictionary* dictionary = [assembly cachedSelectors];
        free(methodList);
        return [dictionary allValues];
    }
}

- (void)applyBeforeAdviceToAssemblyMethods:(TyphoonAssembly*)assembly
{
    @synchronized (self)
    {
        if (![swizzleRegistry containsObject:[assembly class]])
        {
            [swizzleRegistry addObject:[assembly class]];
            unsigned int methodCount;
            Method* methodList = class_copyMethodList([assembly class], &methodCount);
            for (int i = 0; i < methodCount; i++)
            {
                Method method = methodList[i];
                int argumentCount = method_getNumberOfArguments(method);
                if (argumentCount == 2)
                {
                    SEL methodSelector = method_getName(method);
                    if ([TyphoonAssembly selectorReserved:methodSelector] == NO)
                    {
                        SEL swizzled = NSSelectorFromString(
                                [NSStringFromSelector(methodSelector) stringByAppendingString:TYPHOON_BEFORE_ADVICE_SUFFIX]);
                        [[assembly class] typhoon_swizzleMethod:methodSelector withMethod:swizzled error:nil];
                    }
                }
            }
            free(methodList);
        }
    }
}

@end