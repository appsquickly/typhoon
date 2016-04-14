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

#import "TyphoonViewControllerFactory.h"

#import "TyphoonStoryboardDefinitionContext.h"
#import "TyphoonComponentFactory+Storyboard.h"
#import "TyphoonComponentFactory+TyphoonDefinitionRegisterer.h"
#import "UIViewController+TyphoonStoryboardIntegration.h"
#import "UIView+TyphoonDefinitionKey.h"
#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonInjectionContext.h"
#import "TyphoonAbstractInjection.h"

@implementation TyphoonViewControllerFactory

+ (UIViewController *)viewControllerWithStoryboardContext:(TyphoonStoryboardDefinitionContext *)context
                                         injectionContext:(TyphoonInjectionContext *)injectionContext
                                                  factory:(TyphoonComponentFactory *)factory
{
    id<TyphoonComponentsPool> storyboardPool = [factory storyboardPool];
    __block NSString *storyboardName = nil;
    [context.storyboardName valueToInjectWithContext:injectionContext completion:^(id value) {
        storyboardName = value;
    }];

    UIStoryboard *storyboard = storyboardPool[storyboardName];
    if (!storyboard) {
        storyboard = [TyphoonStoryboard storyboardWithName:storyboardName
                                                   factory:factory
                                                    bundle:[NSBundle bundleForClass:[self class]]];
        @synchronized(self) {
            storyboardPool[storyboardName] = storyboard;
        }
    }
    
    __block NSString *viewControllerId = nil;
    [context.viewControllerId valueToInjectWithContext:injectionContext completion:^(id value) {
        viewControllerId = value;
    }];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:viewControllerId];

    return viewController;
}

+ (UIViewController *)viewControllerWithPrototype:(UIViewController *)prototype
                                          factory:(TyphoonComponentFactory *)factory
{
    UIViewController *result = [self configureOrObtainFromPoolViewControllerForInstance:prototype
                                                                            withFactory:factory];
    return result;
}

+ (id)configureOrObtainFromPoolViewControllerForInstance:(UIViewController *)instance
                                             withFactory:(TyphoonComponentFactory *)factory
{
    UIViewController *cachedInstance;
    
    cachedInstance = [factory scopeCachedViewControllerForInstance:instance typhoonKey:instance.typhoonKey];
    
    if (cachedInstance) {
        return cachedInstance;
    }
    
    [self injectPropertiesForViewController:instance withFactory:factory];
    return instance;
}

+ (void)injectPropertiesForViewController:(UIViewController *)viewController
                              withFactory:(TyphoonComponentFactory *)factory
{
    if (viewController.typhoonKey.length > 0) {
        [factory inject:viewController withSelector:NSSelectorFromString(viewController.typhoonKey)];
    }
    else {
        [factory inject:viewController];
    }
    
    for (UIViewController *controller in viewController.childViewControllers) {
        [self injectPropertiesForViewController:controller withFactory:factory];
    }
    
    __weak __typeof (viewController) weakViewController = viewController;
    [viewController setViewDidLoadNotificationBlock:^{
        [self injectPropertiesInView:weakViewController.view withFactory:factory];
    }];
}

+ (void)injectPropertiesInView:(UIView *)view
                   withFactory:(TyphoonComponentFactory *)factory
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
