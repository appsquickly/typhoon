////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <UIKit/UIKit.h>

#import "TyphoonViewControllerInjector.h"

#import "TyphoonComponentFactory+TyphoonDefinitionRegisterer.h"

#import <objc/runtime.h>

//-------------------------------------------------------------------------------------------
#pragma mark - UIViewController + TyphoonDefinitionKey

@interface UIViewController (TyphoonInterfaceBuilderIntegration)

@property(nonatomic, strong) NSString *typhoonKey;

- (void)setViewDidLoadNotificationBlock:(void(^)(void))viewDidLoadBlock;

+ (void)swizzleViewDidLoadMethod;

@end

@implementation UIViewController (TyphoonInterfaceBuilderIntegration)

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

//-------------------------------------------------------------------------------------------
#pragma mark - UIView + TyphoonDefinitionKey

@interface UIView (TyphoonDefinitionKey)

@property(nonatomic, strong) NSString *typhoonKey;

@end

@implementation UIView (TyphoonDefinitionKey)

static const char *kTyphoonKey;

- (void)setTyphoonKey:(NSString *)typhoonKey
{
    objc_setAssociatedObject(self, &kTyphoonKey, typhoonKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)typhoonKey
{
    return objc_getAssociatedObject(self, &kTyphoonKey);
}

@end

//-------------------------------------------------------------------------------------------
#pragma mark - TyphoonViewControllerInjector

@implementation TyphoonViewControllerInjector

+ (void)load
{
    [UIViewController swizzleViewDidLoadMethod];
}

- (void)injectPropertiesForViewController:(UIViewController *)viewController withFactory:(id)factory
{
    [self injectPropertiesForViewController:viewController withFactory:factory storyboard:nil];
}

- (void)injectPropertiesForViewController:(UIViewController *)viewController withFactory:(id<TyphoonComponentFactory>)factory storyboard:(UIStoryboard *)storyboard
{
    if (viewController.typhoonKey.length > 0) {
        [factory inject:viewController withSelector:NSSelectorFromString(viewController.typhoonKey)];
    }
    else {
        [factory inject:viewController];
    }
    
    for (UIViewController *controller in viewController.childViewControllers) {
        if (storyboard && controller.storyboard && ![controller.storyboard isEqual:storyboard]) {
            continue;
        }
        [self injectPropertiesForViewController:controller withFactory:factory];
    }
    
    __weak __typeof (viewController) weakViewController = viewController;
    [viewController setViewDidLoadNotificationBlock:^{
        [self injectPropertiesInView:weakViewController.view withFactory:factory];
    }];
}

- (void)injectPropertiesInView:(UIView *)view withFactory:(id)factory
{
    if (view.typhoonKey.length > 0) {
        [factory inject:view withSelector:NSSelectorFromString(view.typhoonKey)];
    }
    
    if ([view.subviews count] == 0) {
        return;
    }
    
    for (UIView *subview in view.subviews) {
        [self injectPropertiesInView:subview withFactory:factory];
    }
}

@end
