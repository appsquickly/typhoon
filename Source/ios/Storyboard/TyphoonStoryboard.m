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

#import "TyphoonStoryboard.h"
#import "TyphoonComponentFactory+TyphoonDefinitionRegisterer.h"
#import "OCLogTemplate.h"

#import <objc/runtime.h>

//-------------------------------------------------------------------------------------------
#pragma mark - UIViewController + TyphoonDefinitionKey

@interface UIViewController (TyphoonStoryboardIntegration)

@property(nonatomic, strong) NSString *typhoonKey;

- (void)setViewDidLoadNotificationBlock:(void(^)(void))viewDidLoadBlock;

+ (void)swizzleViewDidLoadMethod;

@end

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
#pragma mark - TyphoonStoryboard

@implementation TyphoonStoryboard

+ (void)load
{
    [UIViewController swizzleViewDidLoadMethod];
}

+ (TyphoonStoryboard *)storyboardWithName:(NSString *)name bundle:(NSBundle *)storyboardBundleOrNil
{
    LogInfo(@"*** Warning *** The TyphoonStoryboard with name %@ doesn't have a TyphoonComponentFactory inside. Is this "
            "intentional? You won't be able to inject anything in its ViewControllers", name);
    return [self storyboardWithName:name factory:nil bundle:storyboardBundleOrNil];
}

+ (TyphoonStoryboard *)storyboardWithName:(NSString *)name factory:(id<TyphoonComponentFactory>)factory bundle:(NSBundle *)bundleOrNil
{
    TyphoonStoryboard *storyboard = (id) [super storyboardWithName:name bundle:bundleOrNil];
    storyboard.factory = factory;
    return storyboard;
}

- (id)instantiateViewControllerWithIdentifier:(NSString *)identifier
{
    NSAssert(self.factory, @"TyphoonStoryboard's factory property can't be nil!");

    id viewController = [super instantiateViewControllerWithIdentifier:identifier];

    [self injectPropertiesForViewController:viewController];

    return viewController;
}

- (void)injectPropertiesForViewController:(UIViewController *)viewController
{
    if (viewController.typhoonKey.length > 0) {
        [self.factory inject:viewController withSelector:NSSelectorFromString(viewController.typhoonKey)];
    }
    else {
        [self.factory inject:viewController];
    }

    for (UIViewController *controller in viewController.childViewControllers) {
        if ([controller.storyboard isEqual:self]) {
            [self injectPropertiesForViewController:controller];
        }
    }

    __weak __typeof (viewController) weakViewController = viewController;
    [viewController setViewDidLoadNotificationBlock:^{
        [self injectPropertiesInView:weakViewController.view];
    }];
}

- (void)injectPropertiesInView:(UIView *)view
{
    if (view.typhoonKey.length > 0) {
        [self.factory inject:view withSelector:NSSelectorFromString(view.typhoonKey)];
    }
    
    if ([view.subviews count] == 0) {
        return;
    }
    
    for (UIView *subview in view.subviews) {
        [self injectPropertiesInView:subview];
    }
}

@end
