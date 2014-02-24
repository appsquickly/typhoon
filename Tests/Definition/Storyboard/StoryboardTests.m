//
//  StoryboardTests.m
//  Tests
//
//  Created by Aleksey Garbarev on 25.02.14.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "Typhoon.h"
#import "TyphoonStoryboard.h"
#import "StoryboardViewControllerAssembly.h"
@interface StoryboardTests : SenTestCase

@end

@implementation StoryboardTests {
    UIStoryboard *storyboard;
}

- (void)setUp
{
    [super setUp];

    NSBundle *bundle = [NSBundle bundleForClass:[TyphoonBundleResource class]];
    
    TyphoonComponentFactory *factory = [TyphoonBlockComponentFactory factoryWithAssembly:[StoryboardViewControllerAssembly assembly]];
    
    storyboard = [TyphoonStoryboard storyboardWithName:@"Storyboard" factory:factory bundle:bundle];
}

- (void)test_first
{
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"first"];
    STAssertEqualObjects(controller.title, @"First", nil);
}

- (void)test_first_from_navigation
{
    UINavigationController *controller = [storyboard instantiateViewControllerWithIdentifier:@"navigation"];
    STAssertEqualObjects([[controller.viewControllers firstObject] title], @"First", nil);
}

- (void)test_second
{
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"second"];
    STAssertEqualObjects(controller.title, @"Second", nil);
}

- (void)test_second_from_navigation
{
    UINavigationController *controller = [storyboard instantiateViewControllerWithIdentifier:@"navigation2"];
    STAssertEqualObjects([[controller.viewControllers firstObject] title], @"Second", nil);
}

- (void)test_unique
{
    UINavigationController *controller = [storyboard instantiateViewControllerWithIdentifier:@"unique"];
    STAssertEqualObjects(controller.title, @"Unique", nil);
}
@end
