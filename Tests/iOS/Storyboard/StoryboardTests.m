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

@interface StoryboardTests : XCTestCase

@end

@implementation StoryboardTests
{
    UIStoryboard *storyboard;
}

- (void)setUp
{
    [super setUp];

    NSBundle *bundle = [NSBundle bundleForClass:[TyphoonBundleResource class]];

    TyphoonComponentFactory *factory = [TyphoonBlockComponentFactory factoryWithAssembly:[StoryboardViewControllerAssembly assembly]];

    storyboard = [TyphoonStoryboard storyboardWithName:@"Storyboard" factory:factory bundle:bundle];
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
@end

