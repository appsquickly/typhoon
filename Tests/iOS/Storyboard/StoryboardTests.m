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


#import <XCTest/XCTest.h>
#import "Typhoon.h"
#import "TyphoonStoryboard.h"
#import "StoryboardViewControllerAssembly.h"
#import "StoryboardFirstViewController.h"
#import "StoryboardTabBarViewController.h"
#import "StoryboardTabBarFirstViewController.h"
#import "StoryboardTabBarSecondViewController.h"
#import "StoryboardWithReferenceAssembly.h"

@interface StoryboardTests : XCTestCase

@end

@implementation StoryboardTests
{
    UIStoryboard *storyboard;
    UIStoryboard *storyboardWithReference;
}

- (void)setUp
{
    [super setUp];

    NSBundle *bundle = [NSBundle bundleForClass:[TyphoonBundleResource class]];

    TyphoonComponentFactory *factory = [TyphoonBlockComponentFactory factoryWithAssembly:[StoryboardViewControllerAssembly assembly]];
    TyphoonComponentFactory *secondfactory = [TyphoonBlockComponentFactory factoryWithAssembly:[StoryboardWithReferenceAssembly assembly]];

    storyboard = [TyphoonStoryboard storyboardWithName:@"Storyboard" factory:factory bundle:bundle];
    storyboardWithReference = [TyphoonStoryboard storyboardWithName:@"StoryboardWithReference" factory:secondfactory bundle:bundle];
}

- (void)test_initial
{
    UIViewController *controller = [storyboard instantiateInitialViewController];
    XCTAssertEqualObjects(controller.title, @"Initial");
}

- (void)test_first
{
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"first"];
    XCTAssertEqualObjects(controller.title, @"First");
}

- (void)test_first_resolves_circular_dependencies {
    StoryboardFirstViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"first"];
    StoryboardControllerDependency *dependency = controller.dependency;
    StoryboardFirstViewController *circular = dependency.circularDependencyBackToViewController;

    XCTAssertTrue(controller == circular);
}

- (void)test_first_from_navigation
{
    UINavigationController *controller = [storyboard instantiateViewControllerWithIdentifier:@"navigation"];
    XCTAssertEqualObjects([[controller.viewControllers firstObject] title], @"First");
}

- (void)test_second
{
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"second"];
    XCTAssertEqualObjects(controller.title, @"Second");
}

- (void)test_second_from_navigation
{
    UINavigationController *controller = [storyboard instantiateViewControllerWithIdentifier:@"navigation2"];
    XCTAssertEqualObjects([[controller.viewControllers firstObject] title], @"Second");
}

- (void)test_unique
{
    UINavigationController *controller = [storyboard instantiateViewControllerWithIdentifier:@"unique"];
    XCTAssertEqualObjects(controller.title, @"Unique");
}

- (void)test_viewController_from_reference_storyboard_will_be_once_injected
{
    StoryboardTabBarViewController *tabBarViewController = [storyboardWithReference instantiateInitialViewController];
    StoryboardTabBarFirstViewController *tabBarFirstViewController = (StoryboardTabBarFirstViewController *)[tabBarViewController.childViewControllers firstObject];
    StoryboardTabBarSecondViewController *tabBarSecondViewController = (StoryboardTabBarSecondViewController *)[tabBarViewController.childViewControllers lastObject];
    XCTAssertEqual(tabBarFirstViewController.countOfModelInstanceInjections, 1);
    XCTAssertEqual(tabBarSecondViewController.countOfModelInstanceInjections, 1);
}

@end

