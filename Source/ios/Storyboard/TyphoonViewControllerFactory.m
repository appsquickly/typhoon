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

static NSDictionary *viewControllerClassMap;
static NSDictionary *viewControllerTyphoonKeyMap;

@implementation TyphoonViewControllerFactory

+ (NSDictionary *)viewControllerClassMap {
    if (!viewControllerClassMap) {
        viewControllerClassMap = @{};
    }
    return viewControllerClassMap;
}

+ (NSDictionary *)viewControllerTyphoonKeyMap {
    if (!viewControllerTyphoonKeyMap) {
        viewControllerTyphoonKeyMap = @{};
    }
    return viewControllerTyphoonKeyMap;
}

+ (void)cacheControllerClass:(Class)controllerClass forKey:(NSString *)key {
    NSMutableDictionary *map = [[self viewControllerClassMap] mutableCopy];
    map[key] = controllerClass;
    viewControllerClassMap = [map copy];
}

+ (void)cacheTyphoonKey:(NSString *)typhoonKey forKey:(NSString *)key {
    NSMutableDictionary *map = [[self viewControllerTyphoonKeyMap] mutableCopy];
    map[key] = typhoonKey;
    viewControllerTyphoonKeyMap = [map copy];
}

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
    
    NSString *key = [self viewControllerMapKeyWithIdentifier:viewControllerId storyboardName:storyboardName];
    [self cacheControllerClass:[viewController class] forKey:key];
    if (viewController.typhoonKey) {
        [self cacheTyphoonKey:viewController.typhoonKey forKey:key];
    }
    
    return viewController;
}

+ (UIViewController *)viewControllerWithIdentifier:(NSString *)identifier
                                        storyboard:(TyphoonStoryboard *)storyboard
{
    UIViewController *prototype = [storyboard instantiatePrototypeViewControllerWithIdentifier:identifier];
    UIViewController *result = [self configureOrObtainFromPoolViewControllerForInstance:prototype
                                                                            withFactory:storyboard.factory];
     NSString *key = [self viewControllerMapKeyWithIdentifier:identifier storyboardName:storyboard.storyboardName];
    [self cacheControllerClass:[result class] forKey:key];
    if (result.typhoonKey) {
        [self cacheTyphoonKey:result.typhoonKey forKey:key];
    }

    return result;
}

+ (UIViewController *)cachedViewControllerWithIdentifier:(NSString *)identifier
                                          storyboardName:(NSString *)storyboardName
                                                 factory:(TyphoonComponentFactory *)factory {
    NSDictionary *classMap = [self viewControllerClassMap];
    NSDictionary *typhoonKeyMap = [self viewControllerTyphoonKeyMap];
    NSString *key = [self viewControllerMapKeyWithIdentifier:identifier storyboardName:storyboardName];
    Class viewControllerClass = classMap[key];
    NSString *typhoonKey = typhoonKeyMap[key];
    return [factory scopeCachedViewControllerForClass:viewControllerClass typhoonKey:typhoonKey];
}

+ (id)configureOrObtainFromPoolViewControllerForInstance:(UIViewController *)instance
                                             withFactory:(TyphoonComponentFactory *)factory
{
    UIViewController *cachedInstance = [factory scopeCachedViewControllerForInstance:instance typhoonKey:instance.typhoonKey];
    
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

+ (NSString *)viewControllerMapKeyWithIdentifier:(NSString *)identifier storyboardName:(NSString *)storyboardName {
    return [NSString stringWithFormat:@"%@-%@", storyboardName, identifier];
}

@end
