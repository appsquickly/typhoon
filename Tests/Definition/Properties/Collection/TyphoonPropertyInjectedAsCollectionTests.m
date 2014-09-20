////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <XCTest/XCTest.h>
#import "ClassWithCollectionProperties.h"
#import "TyphoonInjectionByCollection.h"

@interface TyphoonPropertyInjectedAsCollectionTests : XCTestCase
{
    ClassWithCollectionProperties *_classWithCollectionProperties;
}

@end


@implementation TyphoonPropertyInjectedAsCollectionTests

- (void)setUp
{
    _classWithCollectionProperties = [[ClassWithCollectionProperties alloc] init];
}

- (void)test_collection_class_checking_not_collection
{
    XCTAssertFalse([TyphoonInjectionByCollection isCollectionClass:[NSObject class]]);
    XCTAssertFalse([TyphoonInjectionByCollection isCollectionClass:[NSDictionary class]]);
}

//-------------------------------------------------------------------------------------------
#pragma mark - Arrays
- (void)test_collection_class_checking_array
{
    XCTAssertTrue([TyphoonInjectionByCollection isCollectionClass:[NSArray class]]);
    XCTAssertTrue([TyphoonInjectionByCollection isCollectionClass:[NSMutableArray class]]);
}

- (void)test_collection_mutable_class_from_array
{
    Class mutableClass = [TyphoonInjectionByCollection collectionMutableClassFromClass:[NSArray class]];
    XCTAssertEqual(mutableClass, [NSMutableArray class]);

    mutableClass = [TyphoonInjectionByCollection collectionMutableClassFromClass:[NSMutableArray class]];
    XCTAssertEqual(mutableClass, [NSMutableArray class]);
}

//-------------------------------------------------------------------------------------------
#pragma mark - Sets

- (void)test_collection_class_checking_set
{
    XCTAssertTrue([TyphoonInjectionByCollection isCollectionClass:[NSSet class]]);
    XCTAssertTrue([TyphoonInjectionByCollection isCollectionClass:[NSMutableSet class]]);
    XCTAssertTrue([TyphoonInjectionByCollection isCollectionClass:[NSOrderedSet class]]);
    XCTAssertTrue([TyphoonInjectionByCollection isCollectionClass:[NSMutableOrderedSet class]]);
}

- (void)test_collection_mutable_class_from_set
{
    Class mutableClass = [TyphoonInjectionByCollection collectionMutableClassFromClass:[NSSet class]];
    XCTAssertEqual(mutableClass, [NSMutableSet class]);

    mutableClass = [TyphoonInjectionByCollection collectionMutableClassFromClass:[NSMutableSet class]];
    XCTAssertEqual(mutableClass, [NSMutableSet class]);

    mutableClass = [TyphoonInjectionByCollection collectionMutableClassFromClass:[NSOrderedSet class]];
    XCTAssertEqual(mutableClass, [NSMutableOrderedSet class]);

    mutableClass = [TyphoonInjectionByCollection collectionMutableClassFromClass:[NSMutableOrderedSet class]];
    XCTAssertEqual(mutableClass, [NSMutableOrderedSet class]);
}


@end