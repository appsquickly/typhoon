////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2014, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "TyphoonSwizzlerDefaultImpl.h"
#import <objc/runtime.h>

@implementation TyphoonSwizzlerDefaultImpl

+ (instancetype)instance
{
    static TyphoonSwizzlerDefaultImpl *defaultSwizzler;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultSwizzler = [TyphoonSwizzlerDefaultImpl new];
    });
    return defaultSwizzler;
}

- (BOOL)swizzleMethod:(SEL)origSel withMethod:(SEL)altSel onClass:(Class)pClass error:(NSError **)error
{
    Method origMethod = class_getInstanceMethod(pClass, origSel);
    Method altMethod = class_getInstanceMethod(pClass, altSel);
    
    if (!origMethod && !altMethod) {
        if (error) {
            NSString *description = [NSString stringWithFormat:@"Can't swizzle methods since selector %@ and %@ not implemented in %@", NSStringFromSelector(origSel), NSStringFromSelector(altSel), NSStringFromClass(pClass)];
            *error = [NSError errorWithDomain:@"TyphoonMethodSwizzle" code:0 userInfo:@{NSLocalizedDescriptionKey : description }];
        }
        return NO;
    }

    const char *typeEncoding = NULL;
    if (origMethod) {
        typeEncoding = method_getTypeEncoding(origMethod);
    } else {
        typeEncoding = method_getTypeEncoding(altMethod);
    }
    
    class_addMethod(pClass, origSel, class_getMethodImplementation(pClass, origSel), typeEncoding);
    class_addMethod(pClass, altSel, class_getMethodImplementation(pClass, altSel), typeEncoding);
    
    method_exchangeImplementations(class_getInstanceMethod(pClass, origSel), class_getInstanceMethod(pClass, altSel));
    
    return YES;
}


@end
