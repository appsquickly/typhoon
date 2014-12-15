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
#import "TyphoonWeakComponentsPool.h"

@interface TyphoonWeakComponentsPoolTests : XCTestCase

@end

@implementation TyphoonWeakComponentsPoolTests


- (void)test_weak_reference
{
    NSObject *objectA = [NSObject new];
    NSObject *objectB = [NSObject new];

    TyphoonWeakComponentsPool *pool = [TyphoonWeakComponentsPool new];

    [pool setObject:objectA forKey:@"objectA"];
    [pool setObject:objectB forKey:@"objectB"];

    /* AutoreleasePool because ARC returns objects from objectForKey call added to autoreleasepool */
    @autoreleasepool {
        XCTAssertEqual([pool objectForKey:@"objectA"], objectA);
        XCTAssertEqual([pool objectForKey:@"objectB"], objectB);
    }

    objectA = nil;

    XCTAssertNil([pool objectForKey:@"objectA"]);

    objectB = nil;

    XCTAssertNil([pool objectForKey:@"objectB"]);
}


@end
