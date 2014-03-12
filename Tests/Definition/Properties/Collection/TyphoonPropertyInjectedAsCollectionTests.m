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

#import <SenTestingKit/SenTestingKit.h>
#import "ClassWithCollectionProperties.h"
#import "TyphoonInjectionByCollection.h"

@interface TyphoonPropertyInjectedAsCollectionTests : SenTestCase
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
    STAssertFalse([TyphoonInjectionByCollection isCollectionClass:[NSObject class]], nil);
    STAssertFalse([TyphoonInjectionByCollection isCollectionClass:[NSDictionary class]], nil);
}

/* ====================================================================================================================================== */
#pragma mark - Arrays
- (void)test_collection_class_checking_array
{
    STAssertTrue([TyphoonInjectionByCollection isCollectionClass:[NSArray class]], nil);
    STAssertTrue([TyphoonInjectionByCollection isCollectionClass:[NSMutableArray class]], nil);
}

- (void)test_collection_mutable_class_from_array
{
    Class mutableClass = [TyphoonInjectionByCollection collectionMutableClassFromClass:[NSArray class]];
    assertThat(mutableClass, equalTo([NSMutableArray class]));
    
    mutableClass = [TyphoonInjectionByCollection collectionMutableClassFromClass:[NSMutableArray class]];
    assertThat(mutableClass, equalTo([NSMutableArray class]));
}

/* ====================================================================================================================================== */
#pragma mark - Sets

- (void)test_collection_class_checking_set
{
    STAssertTrue([TyphoonInjectionByCollection isCollectionClass:[NSSet class]], nil);
    STAssertTrue([TyphoonInjectionByCollection isCollectionClass:[NSMutableSet class]], nil);
    STAssertTrue([TyphoonInjectionByCollection isCollectionClass:[NSOrderedSet class]], nil);
    STAssertTrue([TyphoonInjectionByCollection isCollectionClass:[NSMutableOrderedSet class]], nil);
}

- (void)test_collection_mutable_class_from_set
{
    Class mutableClass = [TyphoonInjectionByCollection collectionMutableClassFromClass:[NSSet class]];
    assertThat(mutableClass, equalTo([NSMutableSet class]));
    
    mutableClass = [TyphoonInjectionByCollection collectionMutableClassFromClass:[NSMutableSet class]];
    assertThat(mutableClass, equalTo([NSMutableSet class]));
    
    mutableClass = [TyphoonInjectionByCollection collectionMutableClassFromClass:[NSOrderedSet class]];
    assertThat(mutableClass, equalTo([NSMutableOrderedSet class]));
    
    mutableClass = [TyphoonInjectionByCollection collectionMutableClassFromClass:[NSMutableOrderedSet class]];
    assertThat(mutableClass, equalTo([NSMutableOrderedSet class]));
}


@end