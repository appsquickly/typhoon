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
#import "TyphoonSwizzlerDefaultImpl.h"

@interface TyphoonSwizzlerTests : XCTestCase

@property (strong, readonly, nonatomic) id<TyphoonMethodSwizzler> swizzler;

@end

@implementation TyphoonSwizzlerTests

- (void)setUp
{
    _swizzler = [TyphoonSwizzlerDefaultImpl instance];
}


- (void)test_swizzles_methods
{
    [_swizzler swizzleMethod:@selector(methodA) withMethod:@selector(methodB) onClass:[self class] error:nil];
    XCTAssertEqualObjects(@"MethodB", [self methodA]);
}

- (void)test_raises_error_when_methods_not_exist_on_class
{
    NSError *error = nil;

    [_swizzler swizzleMethod:@selector(foo) withMethod:@selector(bar) onClass:[self class] error:&error];

    XCTAssertNotNil(error);
    XCTAssertEqualObjects(error.localizedDescription,
        @"Can't swizzle methods since selector foo and bar not implemented in TyphoonSwizzlerTests");
}

- (void)test_swizzles_when_origin_method_not_exist
{
    NSError *error = nil;
    
    [_swizzler swizzleMethod:@selector(foo) withMethod:@selector(methodC) onClass:[self class] error:&error];
    
    XCTAssertNil(error);
    XCTAssertThrows([self methodC]);
}

- (NSString *)methodA
{
    return @"MethodA";
}

- (NSString *)methodB
{
    return @"MethodB";
}

- (NSString *)methodC
{
    return @"MethodC";
}

@end
