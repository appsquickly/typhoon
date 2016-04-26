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

#import "TyphoonViewControllerInjector.h"
#import "OCLogTemplate.h"

@interface TyphoonStoryboard ()

@property (nonatomic, strong) TyphoonViewControllerInjector *injector;

@end

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
    storyboard.injector = [[TyphoonViewControllerInjector alloc] init];
    return storyboard;
}

- (id)instantiateViewControllerWithIdentifier:(NSString *)identifier
{
    NSAssert(self.factory, @"TyphoonStoryboard's factory property can't be nil!");

    id viewController = [super instantiateViewControllerWithIdentifier:identifier];

    [self.injector injectPropertiesForViewController:viewController withFactory:self.factory];

    return viewController;
}

@end
