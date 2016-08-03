//
//  TyphoonLoadedViewTransferOutletTests.m
//  Typhoon
//
//  Created by Smal Vadim on 01/08/16.
//  Copyright © 2016 typhoonframework.org. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TyphoonLoadedView.h"
#import "RootView.h"
#import "LoadedView.h"
#import "RootViewAssembly.h"
#import "TyphoonComponentFactory.h"

@interface TyphoonLoadedViewTransferOutletTests : XCTestCase

@property (nonatomic, strong) RootViewAssembly *assembly;

@end

@implementation TyphoonLoadedViewTransferOutletTests

- (void)setUp
{
    [super setUp];
    self.assembly = [RootViewAssembly new];
    [self.assembly activate];
    [TyphoonComponentFactory setFactoryForResolvingUI:(id)self.assembly];
}

- (void)tearDown
{
    self.assembly = nil;
    [super tearDown];
}

- (void)test_transfer_constraints
{
    // given
   
    // when
    RootView *rootView = [self loadView];
    // then
    XCTAssertEqualObjects(rootView.loadedView, rootView.subviews[0]);
    [self checkViewSuccessInjected:rootView.loadedView];
    [self checkConstraintsInView:rootView
                      loadedView:rootView.loadedView];
    [self checkConstraintsInView:rootView.anotherView
                      loadedView:rootView.loadedView];
}

- (void)test_change_transfered_constraints
{
    // given
    RootView *rootView = [self loadView];
    rootView.widthConstraint.constant = 10;
    rootView.heightConstraint.constant = 10;
    // when
    [rootView setNeedsUpdateConstraints];
    [rootView updateConstraintsIfNeeded];
    [rootView setNeedsLayout];
    [rootView layoutIfNeeded];
    // then
    XCTAssertEqual(rootView.loadedView.frame.size.width, rootView.widthConstraint.constant);
    XCTAssertEqual(rootView.loadedView.frame.size.height, rootView.widthConstraint.constant);
    XCTAssertEqual(rootView.anotherView.frame.size.width, rootView.widthConstraint.constant);
    XCTAssertEqual(rootView.anotherView.frame.size.height, rootView.widthConstraint.constant);
}

- (RootView *)loadView
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    return [[bundle loadNibNamed:NSStringFromClass([RootView class])
                           owner:self
                         options:NULL] firstObject];
}

- (void)checkViewSuccessInjected:(LoadedView *)loadedView
{
    XCTAssertEqualObjects(loadedView.backgroundColor, [UIColor greenColor]);
    XCTAssertEqualObjects([loadedView class], [LoadedView class]);
    XCTAssertNotNil(loadedView.injectedValue);
}

- (void)checkConstraintsInView:(RootView *)view
                    loadedView:(UIView *)loadedView
{
    XCTAssertEqualObjects(view.widthConstraint, loadedView.constraints[0]);
    XCTAssertEqualObjects(view.heightConstraint, loadedView.constraints[1]);
    XCTAssertEqualObjects(view.leadingConstraint.firstItem, loadedView);
    XCTAssertEqualObjects(view.topConstraint.firstItem, loadedView);
    XCTAssertTrue([view.outlets containsObject:loadedView.constraints[0]]);
    XCTAssertTrue([view.outlets containsObject:loadedView.constraints[1]]);
}

@end
