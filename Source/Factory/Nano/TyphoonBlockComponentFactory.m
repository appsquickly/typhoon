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
#import "TyphoonComponentDefinition.h"
#import "TyphoonJRSwizzle.h"

@interface TyphoonAssembly (NanoFactoryFriend)

+ (BOOL)selectorReserved:(SEL)selector;

@end

@implementation TyphoonBlockComponentFactory

- (id)initWithAssembly:(TyphoonAssembly*)assembly;
{
    if (![assembly isKindOfClass:[TyphoonAssembly class]])
    {
        [NSException raise:NSInvalidArgumentException format:@"Class '%@' is not a sub-class of %@", NSStringFromClass(assembly),
                                                             NSStringFromClass([TyphoonAssembly class])];
    }
    self = [super init];
    if (self)
    {
        [self applyBeforeAdviceToAssemblyMethods:assembly];

        int methodCount;
        Method* methodList = class_copyMethodList([assembly class], &methodCount);
        for (int i = 0; i < methodCount; i++)
        {
            Method method = methodList[i];

            int argumentCount = method_getNumberOfArguments(method);
            if (argumentCount == 2)
            {
                SEL methodSelector = method_getName(method);
                if (![[assembly class] selectorReserved:methodSelector])
                {
                    id anObject = objc_msgSend(assembly, methodSelector);
                    if ([anObject isKindOfClass:[TyphoonComponentDefinition class]])
                    {
                        [self register:anObject];
                    }
                }
            }
        }
    }
    return self;
}

- (void)applyBeforeAdviceToAssemblyMethods:(TyphoonAssembly*)assembly
{
    int methodCount;
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
                SEL swizzled =
                        NSSelectorFromString([NSStringFromSelector(methodSelector) stringByAppendingString:TYPHOON_BEFORE_ADVICE_SUFFIX]);
                NSLog(@"Exchanging: %@ with: %@", NSStringFromSelector(methodSelector), NSStringFromSelector(swizzled));

                NSError* error;
                [[assembly class] typhoon_swizzleMethod:methodSelector withMethod:swizzled error:&error];
                if (error)
                {
                    [NSException raise:NSInternalInconsistencyException format:[error description]];
                }
            }
        }
    }
}

@end