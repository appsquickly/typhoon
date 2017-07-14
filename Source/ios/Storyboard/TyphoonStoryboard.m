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

#import "TyphoonStoryboard.h"
#import "OCLogTemplate.h"

#import "TyphoonComponentFactory+TyphoonDefinitionRegisterer.h"
#import "TyphoonComponentFactory+Storyboard.h"
#import "TyphoonViewControllerFactory.h"
#import "OCLogTemplate.h"
#import "UIViewController+TyphoonStoryboardIntegration.h"


@implementation TyphoonStoryboard

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
    storyboard.storyboardName = name;
        return storyboard;
}

- (UIViewController *)instantiatePrototypeViewControllerWithIdentifier:(NSString *)identifier {
    return [super instantiateViewControllerWithIdentifier:identifier];
}

- (id)instantiateViewControllerWithIdentifier:(NSString *)identifier
{
    NSAssert(self.factory, @"TyphoonStoryboard's factory property can't be nil!");
    
    UIViewController *cachedInstance = [TyphoonViewControllerFactory cachedViewControllerWithIdentifier:identifier storyboardName:self.storyboardName factory:self.factory];
    if (cachedInstance) {
        return cachedInstance;
    }
    
    UIViewController *result = [TyphoonViewControllerFactory viewControllerWithIdentifier:identifier storyboard:self];

    return result;
}

@end
