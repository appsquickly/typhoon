//
//  StoryboardTests.m
//  Tests
//
//  Created by Aleksey Garbarev on 25.02.14.
//
//

#import <XCTest/XCTest.h>
#import "Typhoon.h"
#import "TyphoonStoryboard.h"
#import "StoryboardViewControllerAssembly.h"

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
