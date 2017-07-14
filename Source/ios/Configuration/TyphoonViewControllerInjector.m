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
#import "UIViewController+TyphoonStoryboardIntegration.h"
#import "UIView+TyphoonDefinitionKey.h"

#import "TyphoonComponentFactory+TyphoonDefinitionRegisterer.h"


#import <objc/runtime.h>

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
        [self injectPropertiesForViewController:controller withFactory:factory storyboard:storyboard];
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
