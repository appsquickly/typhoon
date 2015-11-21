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

@property (strong, nonatomic) id factory;

@end

@implementation StoryboardTests
{
    UIStoryboard *storyboard;
}

- (void)setUp
{
    [super setUp];

    self.factory = [TyphoonBlockComponentFactory factoryWithAssembly:[StoryboardViewControllerAssembly assembly]];

    storyboard = [self.factory storyboard];
}

- (void)tearDown
{
    self.factory = nil;
    [super tearDown];
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

- (void)test_singleton_controller
{
    UIViewController *factoryController = [self.factory singletonViewController];
    XCTAssertEqualObjects(factoryController.title, @"singleton");
    
    UIViewController *storyboardController = [storyboard instantiateViewControllerWithIdentifier:@"SingletonViewController"];
    XCTAssertEqualObjects(storyboardController.title, @"singleton");
    
    XCTAssertEqualObjects(factoryController, storyboardController);
}

- (void)test_lazy_singleton_controller
{
    UIViewController *storyboardController = [storyboard instantiateViewControllerWithIdentifier:@"LazySingletonViewController"];
    XCTAssertEqualObjects(storyboardController.title, @"lazysingleton");
    
    UIViewController *factoryController = [self.factory lazySingletonViewController];
    XCTAssertEqualObjects(factoryController.title, @"lazysingleton");
    
    XCTAssertEqualObjects(factoryController, storyboardController);
}

- (void)test_weak_singleton_controller
{
    UIViewController *storyboardController;
    UIViewController *factoryController;
    
    @autoreleasepool {
        storyboardController = [storyboard instantiateViewControllerWithIdentifier:@"WeakSingletonViewController"];
        XCTAssertEqualObjects(storyboardController.title, @"weaksingleton");
        
        storyboardController.title = @"step1";
        
        factoryController = [self.factory weakSingletonViewController];
        XCTAssertEqualObjects(factoryController.title, @"step1");
    }
    
    storyboardController = nil;
    factoryController = nil;
    
    UIViewController *otherController = [self.factory weakSingletonViewController];
    XCTAssertEqualObjects(otherController.title, @"weaksingleton");
}

- (void)test_prototype_controller
{
    UIViewController *firstInstance = [storyboard instantiateViewControllerWithIdentifier:@"PrototypeViewController"];
    UIViewController *secondInstance = [storyboard instantiateViewControllerWithIdentifier:@"PrototypeViewController"];
    XCTAssertNotEqualObjects(firstInstance, secondInstance);
}

@end
