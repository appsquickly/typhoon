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
#import "TyphoonNibLoader.h"
#import "TyphoonNibLoaderAssembly.h"
#import "TyphoonNibLoaderSpecifiedViewController.h"

@interface TyphoonNibLoaderTests : XCTestCase

@property (nonatomic, strong) TyphoonNibLoader *nibLoader;

@end

@implementation TyphoonNibLoaderTests

- (void)setUp
{
    [super setUp];
    
    TyphoonComponentFactory *factory = [TyphoonBlockComponentFactory factoryWithAssembly:[TyphoonNibLoaderAssembly assembly]];
    NSBundle *bundle = [NSBundle bundleForClass:[TyphoonBundleResource class]];
    self.nibLoader = [TyphoonNibLoader nibLoaderWithFactory:factory bundle:bundle];
}

- (void)test_specified_exists
{
    id controller = [self.nibLoader instantiateViewControllerWithIdentifier:kTyphoonNibLoaderSpecifiedViewControllerIdentifier];
    XCTAssertNotNil(controller);
}

- (void)test_unspecified_exists
{
    id controller = [self.nibLoader instantiateViewControllerWithIdentifier:kTyphoonNibLoaderUnspecifiedViewControllerIdentifier];
    XCTAssertNotNil(controller);
}

- (void)test_specified_class
{
    id controller = [self.nibLoader instantiateViewControllerWithIdentifier:kTyphoonNibLoaderSpecifiedViewControllerIdentifier];
    XCTAssertEqualObjects([controller class], [TyphoonNibLoaderSpecifiedViewController class]);
}

- (void)test_unspecified_class
{
    id controller = [self.nibLoader instantiateViewControllerWithIdentifier:kTyphoonNibLoaderUnspecifiedViewControllerIdentifier];
    XCTAssertEqualObjects([controller class], [UIViewController class]);
}

- (void)test_specified_nib_loaded
{
    UIViewController *controller = [self.nibLoader instantiateViewControllerWithIdentifier:kTyphoonNibLoaderSpecifiedViewControllerIdentifier];
    XCTAssertTrue([controller.view.subviews count] == 1);
    XCTAssertTrue([[controller.view.subviews firstObject] isKindOfClass:[UILabel class]]);
    XCTAssertEqualObjects([[controller.view.subviews firstObject] text], kTyphoonNibLoaderSpecifiedViewControllerIdentifier);
}

- (void)test_unspecified_nib_loaded
{
    UIViewController *controller = [self.nibLoader instantiateViewControllerWithIdentifier:kTyphoonNibLoaderUnspecifiedViewControllerIdentifier];
    XCTAssertTrue([controller.view.subviews count] == 1);
    XCTAssertTrue([[controller.view.subviews firstObject] isKindOfClass:[UILabel class]]);
    XCTAssertEqualObjects([[controller.view.subviews firstObject] text], kTyphoonNibLoaderUnspecifiedViewControllerIdentifier);
}

- (void)test_specified_injections
{
    TyphoonNibLoaderSpecifiedViewController *controller = [self.nibLoader instantiateViewControllerWithIdentifier:kTyphoonNibLoaderSpecifiedViewControllerIdentifier];
    XCTAssertEqualObjects(controller.title, @"Specified");
    XCTAssertEqualObjects(controller.specifiedTitle, @"Specified");
}

- (void)test_unspecified_injections
{
    UIViewController *controller = [self.nibLoader instantiateViewControllerWithIdentifier:kTyphoonNibLoaderUnspecifiedViewControllerIdentifier];
    XCTAssertEqualObjects(controller.title, @"Unspecified");
}

- (void)test_nib_loader_exception_no_factory
{
    [self.nibLoader setFactory:nil];
    
    NSString *expectedException = @"TyphoonNibLoader's factory property can't be nil!";
    NSString *receivedException;
    
    @try {
        [self.nibLoader instantiateViewControllerWithIdentifier:kTyphoonNibLoaderSpecifiedViewControllerIdentifier];
    }
    @catch (NSException *exception) {
        receivedException = exception.description;
    }
    
    XCTAssertEqualObjects(expectedException, receivedException);
}

@end
