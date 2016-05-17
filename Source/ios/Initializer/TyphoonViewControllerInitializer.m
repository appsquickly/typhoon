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

#import "TyphoonViewControllerInitializer.h"

#import "TyphoonViewControllerInjector.h"
#import "OCLogTemplate.h"

@interface TyphoonViewControllerInitializer ()

@property (nonatomic, strong) TyphoonViewControllerInjector *injector;

@end

@implementation TyphoonViewControllerInitializer

+ (TyphoonViewControllerInitializer *)viewControllerInitializer
{
    LogInfo(@"*** Warning *** The TyphoonViewControllerInitializer doesn't have a TyphoonComponentFactory inside. "
            "Is this intentional? You won't be able to inject anything in its ViewControllers");
    return [self viewControllerInitializerWithFactory:nil];
}

+ (TyphoonViewControllerInitializer *)viewControllerInitializerWithFactory:(id<TyphoonComponentFactory>)factory
{
    TyphoonViewControllerInitializer *viewControllerInitializer = [[TyphoonViewControllerInitializer alloc] init];
    viewControllerInitializer.factory = factory;
    viewControllerInitializer.injector = [[TyphoonViewControllerInjector alloc] init];
    return viewControllerInitializer;
}

- (id)instantiateViewControllerWithIdentifier:(NSString *)className
{
    NSAssert(self.factory, @"TyphoonViewControllerInitializer's factory property can't be nil!");
    
    Class viewControllerClass = NSClassFromString(className);
    if (!viewControllerClass) {
        viewControllerClass = [UIViewController class];
        LogInfo(@"*** Warning *** NSClassFromString(%@) is nil. UIViewController class will be used instead. "
                "This can lead to 'this class is not key value coding-compliant for the key' exception.", className);
    }
    
    id viewController = [[viewControllerClass alloc] init];
    
    [self.injector injectPropertiesForViewController:viewController withFactory:self.factory];
    
    return viewController;
}

@end
