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

#import <objc/runtime.h>

//-------------------------------------------------------------------------------------------
#pragma mark - UIViewController + TyphoonDefinitionKey

@interface UIViewController (TyphoonDefinitionKey)

@property(nonatomic, strong) NSString *typhoonKey;

@end

@implementation UIViewController (TyphoonDefinitionKey)

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

+ (TyphoonStoryboard *)storyboardWithName:(NSString *)name bundle:(NSBundle *)storyboardBundleOrNil
{
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
        [self injectPropertiesForViewController:controller];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self injectPropertiesInView:viewController.view];
    });
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
