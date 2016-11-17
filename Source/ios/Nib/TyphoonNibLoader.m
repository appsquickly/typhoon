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

#import "TyphoonNibLoader.h"

#import "TyphoonViewControllerInjector.h"
#import "OCLogTemplate.h"

@interface TyphoonNibLoader ()

@property (nonatomic, strong) TyphoonViewControllerInjector *injector;

@end

@implementation TyphoonNibLoader

+ (TyphoonNibLoader *)nibLoaderWithBundle:(NSBundle *)bundleOrNil
{
    LogInfo(@"*** Warning *** The TyphoonNibLoader doesn't have a TyphoonComponentFactory inside. Is this "
            "intentional? You won't be able to inject anything in its ViewControllers");
    return [self nibLoaderWithFactory:nil bundle:bundleOrNil];
}

+ (TyphoonNibLoader *)nibLoaderWithFactory:(id<TyphoonComponentFactory>)factory bundle:(NSBundle *)bundleOrNil
{
    TyphoonNibLoader *nibLoader = [[TyphoonNibLoader alloc] init];
    nibLoader.factory = factory;
    nibLoader.bundle = bundleOrNil;
    nibLoader.injector = [[TyphoonViewControllerInjector alloc] init];
    return nibLoader;
}

- (id)instantiateViewControllerWithIdentifier:(NSString *)nibName
{
    NSAssert(self.factory, @"TyphoonNibLoader's factory property can't be nil!");
    
    Class viewControllerClass = NSClassFromString(nibName);
    if (!viewControllerClass) {
        viewControllerClass = [UIViewController class];
        LogInfo(@"*** Warning *** NSClassFromString(%@) is nil. UIViewController class will be used instead. "
                "This can lead to 'this class is not key value coding-compliant for the key' exception.", nibName);
    }
    
    id viewController = [[viewControllerClass alloc] initWithNibName:nibName bundle:self.bundle];
    
    [self.injector injectPropertiesForViewController:viewController withFactory:self.factory];
    
    return viewController;
}

@end
