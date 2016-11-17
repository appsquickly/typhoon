////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2015, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "UIViewController+TyphoonStoryboardIntegration.h"

#import <objc/runtime.h>

@implementation UIViewController (TyphoonStoryboardIntegration)

static const char *kTyphoonKey;
static const char *kTyphoonViewDidLoadBlock;

- (void)setTyphoonKey:(NSString *)typhoonKey
{
    objc_setAssociatedObject(self, &kTyphoonKey, typhoonKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)typhoonKey
{
    return objc_getAssociatedObject(self, &kTyphoonKey);
}

- (void)setViewDidLoadNotificationBlock:(void(^)(void))viewDidLoadBlock
{
    objc_setAssociatedObject(self, &kTyphoonViewDidLoadBlock, viewDidLoadBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (void)swizzleViewDidLoadMethod
{
    SEL sel = @selector(viewDidLoad);
    Method method = class_getInstanceMethod([UIViewController class], sel);
    
    void(*originalImp)(id, SEL) = (void (*)(id, SEL)) method_getImplementation(method);
    
    IMP adjustedImp = imp_implementationWithBlock(^void(id instance) {
        
        void(^didLoadBlock)(void) = objc_getAssociatedObject(instance, &kTyphoonViewDidLoadBlock);
        if (didLoadBlock) {
            didLoadBlock();
            objc_setAssociatedObject(instance, &kTyphoonViewDidLoadBlock, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
        
        originalImp(instance, sel);
    });
    
    method_setImplementation(method, adjustedImp);
}

@end
