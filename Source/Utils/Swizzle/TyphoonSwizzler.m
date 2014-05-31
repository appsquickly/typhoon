////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2014, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "TyphoonSwizzler.h"
#import <objc/runtime.h>

@implementation TyphoonSwizzler

+ (instancetype)defaultSwizzler
{
    static TyphoonSwizzler *defaultSwizzler;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultSwizzler = [TyphoonSwizzler new];
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
    
    class_addMethod(pClass, origSel, class_getMethodImplementation(pClass, origSel), method_getTypeEncoding(altMethod));
    class_addMethod(pClass, altSel, class_getMethodImplementation(pClass, altSel), method_getTypeEncoding(origMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(pClass, origSel), class_getInstanceMethod(pClass, altSel));
    
    return YES;
}


@end