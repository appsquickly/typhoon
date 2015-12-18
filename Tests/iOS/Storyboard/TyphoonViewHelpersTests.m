//
//  TyphoonLoadedViewTests.m
//  Typhoon
//
//  Created by Herman Saprykin on 26/08/15.
//  Copyright © 2015 typhoonframework.org. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMockitoIOS/OCMockitoIOS.h>

#import "TyphoonViewHelpers.h"
#import "TyphoonAssembly.h"
#import "TyphoonBlockComponentFactory.h"

@interface TyphoonViewHelpersFactory : TyphoonAssembly

- (NSString *)notView;
- (UIView *)view;

@end

@implementation TyphoonViewHelpersFactory

- (NSString *)notView {
    return [TyphoonDefinition withClass:[NSString class]];
}

- (UIView *)view {
    return [TyphoonDefinition withClass:[UIView class]];
}

@end

BOOL equalProperties(NSLayoutConstraint *c1, NSLayoutConstraint *c2){
    return
    c1.relation == c2.relation &&
    c1.firstAttribute == c2.firstAttribute &&
    c1.secondAttribute == c2.secondAttribute &&
    c1.constant == c2.constant;
}

@interface TyphoonViewHelpersTests : XCTestCase

@end

@implementation TyphoonViewHelpersTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_factory_exception {
    // given
    [TyphoonComponentFactory setFactoryForResolvingUI:nil];
    NSString *expectedDescription = @"Can't find Typhoon factory to resolve definition from xib. Check [TyphoonComponentFactory setFactoryForResolvingUI:] method.";
    NSString *receivedDescription;
    
    // when
    @try {
        [TyphoonViewHelpers viewFromDefinition:@"" originalView:nil];
    }
    @catch (NSException *exception) {
        receivedDescription = exception.description;
    }
    
    // then
    XCTAssertEqualObjects(expectedDescription, receivedDescription);
}

- (void)test_view_class_exception {
    // given
    TyphoonComponentFactory *factory = [TyphoonBlockComponentFactory factoryWithAssemblies:@[[TyphoonViewHelpersFactory new]]];
    [TyphoonComponentFactory setFactoryForResolvingUI:factory];
    
    NSString *definitionKey = @"notView";
    NSString *expectedDescription = [NSString stringWithFormat:@"Error: definition for key '%@' is not kind of UIView but %@",definitionKey, @""];
    
    NSString *receivedDescription;
    
    // when
    @try {
        [TyphoonViewHelpers viewFromDefinition:definitionKey originalView:nil];
    }
    @catch (NSException *exception) {
        receivedDescription = exception.description;
    }
    
    // then
    XCTAssertEqualObjects(expectedDescription, receivedDescription);
}

- (void)test_view_class {
    // given
    TyphoonComponentFactory *factory = [TyphoonBlockComponentFactory factoryWithAssemblies:@[[TyphoonViewHelpersFactory new]]];
    [TyphoonComponentFactory setFactoryForResolvingUI:factory];
    UIView *originalView = [UIView new];
    [originalView addSubview:[UIView new]];
    
    NSString *definitionKey = @"view";
    id receivedObject;
    
    // when
    receivedObject = [TyphoonViewHelpers viewFromDefinition:definitionKey originalView:originalView];
    
    // then
    XCTAssertEqualObjects([receivedObject class], [UIView class]);
}


- (void)test_transfer_properties {
    // given
    UIView *containerView = [UIView new];
    containerView.translatesAutoresizingMaskIntoConstraints = NO;

    
    UIView *src = [UIView new];
    src.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *sizeConstraint =
    [NSLayoutConstraint constraintWithItem:src
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:src
                                 attribute:NSLayoutAttributeWidth
                                multiplier:1.0f
                                  constant:0];
    [src addConstraint:sizeConstraint];
    
    NSLayoutConstraint *containerConstraint =
    [NSLayoutConstraint constraintWithItem:src
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:containerView
                                 attribute:NSLayoutAttributeHeight
                                multiplier:1.0f
                                  constant:0];
    [src addConstraint:containerConstraint];

    
    
    UIView *dst = [UIView new];
    
    // when
    [TyphoonViewHelpers transferPropertiesFromView:src toView:dst];
    
    // then
    XCTAssertEqual(dst.translatesAutoresizingMaskIntoConstraints, src.translatesAutoresizingMaskIntoConstraints);
    XCTAssertTrue(CGRectEqualToRect(dst.frame, src.frame));
    XCTAssertEqual(dst.autoresizesSubviews, src.autoresizesSubviews);
    XCTAssertEqual(dst.autoresizingMask, src.autoresizingMask);
    
    for (NSLayoutConstraint *dstConstraint in dst.constraints) {
        BOOL didFindEqualPointer = NO;
        
        for (NSLayoutConstraint *srcConstraint in src.constraints) {
            if (equalProperties(dstConstraint, srcConstraint)){
                
                BOOL replaceFirstItem = [srcConstraint firstItem] == src;
                BOOL replaceSecondItem = [srcConstraint secondItem] == src;
                id firstItem = replaceFirstItem ? dst : srcConstraint.firstItem;
                id secondItem = replaceSecondItem ? dst : srcConstraint.secondItem;
                
                if ([dstConstraint.firstItem isEqual:firstItem] &&
                    [dstConstraint.secondItem isEqual:secondItem] &&
                    dstConstraint == srcConstraint) {
                    didFindEqualPointer = YES;
                    break;
                }
            }
        }
        
        XCTAssertTrue(didFindEqualPointer, @"%@", dstConstraint.description);
    }
    
    XCTAssertEqual(dst.constraints.count, src.constraints.count);
}

@end
