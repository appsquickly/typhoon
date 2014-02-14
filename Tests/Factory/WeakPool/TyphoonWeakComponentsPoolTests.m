//
//  TyphoonWeakComponentsPoolTests.m
//  Tests
//
//  Created by Aleksey Garbarev on 29.01.14.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "TyphoonWeakComponentsPool.h"

@interface TyphoonWeakComponentsPoolTests : SenTestCase

@end

@implementation TyphoonWeakComponentsPoolTests


- (void)test_weak_reference {
    NSObject *objectA = [NSObject new];
    NSObject *objectB = [NSObject new];

    TyphoonWeakComponentsPool *pool = [TyphoonWeakComponentsPool new];

    [pool setObject:objectA forKey:@"objectA"];
    [pool setObject:objectB forKey:@"objectB"];

    /* AutoreleasePool because ARC returns objects from objectForKey call added to autoreleasepool */
    @autoreleasepool {
        assertThat([pool objectForKey:@"objectA"], equalTo(objectA));
        assertThat([pool objectForKey:@"objectB"], equalTo(objectB));
    }

    objectA = nil;

    assertThat([pool objectForKey:@"objectA"], equalTo(nil));

    objectB = nil;

    assertThat([pool objectForKey:@"objectB"], equalTo(nil));
}


@end
