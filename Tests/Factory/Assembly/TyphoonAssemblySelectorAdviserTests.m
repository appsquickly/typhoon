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
#import "TyphoonAssemblySelectorAdviser.h"

@interface TyphoonAssemblySelectorAdviserTests : XCTestCase

@end


@implementation TyphoonAssemblySelectorAdviserTests
{
    NSString *key;
    SEL sel;
    SEL advisedSEL;

    SEL SELWithArguments;
    SEL advisedSELWithArguments;
}

- (void)setUp
{
    sel = @selector(uppercaseString);
    key = NSStringFromSelector(sel);
    advisedSEL = [TyphoonAssemblySelectorAdviser advisedSELForSEL:sel];

    SELWithArguments = @selector(initWithString:attributes:);
}

#pragma mark - Tests
- (void)test_selector_with_no_arguments_valid_after_transformation
{
    [self advisedSELShouldHaveNoArguments];
}

- (void)test_recognizes_advised
{
    XCTAssertFalse([TyphoonAssemblySelectorAdviser selectorIsAdvised:sel]);
    XCTAssertTrue([TyphoonAssemblySelectorAdviser selectorIsAdvised:advisedSEL]);
}

- (void)test_key_is_selector_as_string
{
    XCTAssertEqualObjects([TyphoonAssemblySelectorAdviser keyForAdvisedSEL:advisedSEL], key);
}

- (void)test_advised_SEL_for_key
{
    XCTAssertEqual([TyphoonAssemblySelectorAdviser advisedSELForKey:key], advisedSEL);
}

- (void)test_selector_with_arguments_preserves_arguments
{
    advisedSELWithArguments = [TyphoonAssemblySelectorAdviser advisedSELForSEL:SELWithArguments];
    [self advisedSELWithArgumentsShouldHaveTwoArgumentsAndEndWithAnArgument];
}

#pragma mark - Helper Methods

- (void)advisedSELShouldHaveNoArguments;
{
    XCTAssertEqual([self numberOfArgumentsInSelector:advisedSEL], (NSUInteger) 0, @"The advised SEL should not have any arguments.");
}

- (void)advisedSELWithArgumentsShouldHaveTwoArgumentsAndEndWithAnArgument;
{
    XCTAssertEqual([self numberOfArgumentsInSelector:advisedSELWithArguments], 2);
    XCTAssertEqual([self numberOfArgumentsInSelector:advisedSELWithArguments], (NSUInteger) 2, @"The wrapped SEL with two arguments should have two arguments.");
    XCTAssertTrue([self selectorEndsWithASemicolon:advisedSELWithArguments]);
}

- (NSUInteger)numberOfArgumentsInSelector:(SEL)selector;
{
    NSString *original = NSStringFromSelector(selector);
    NSString *withArgumentsRemoved = [original stringByReplacingOccurrencesOfString:@":" withString:@""];
    return [original length] - [withArgumentsRemoved length];
}

- (BOOL)selectorEndsWithASemicolon:(SEL)selector;
{
    NSString *s = NSStringFromSelector(selector);
    NSUInteger lastIndex = [s length] - 1;
    return [[s substringFromIndex:lastIndex] isEqualToString:@":"];
}

@end
