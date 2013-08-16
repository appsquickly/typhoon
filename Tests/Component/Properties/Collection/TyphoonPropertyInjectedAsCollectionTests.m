////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <SenTestingKit/SenTestingKit.h>
#import "ClassWithCollectionProperties.h"
#import "TyphoonPropertyInjectedAsCollection.h"

@interface TyphoonPropertyInjectedAsCollectionTests : SenTestCase
{
    ClassWithCollectionProperties* _classWithCollectionProperties;
}

@end


@implementation TyphoonPropertyInjectedAsCollectionTests

- (void)setUp
{
    _classWithCollectionProperties = [[ClassWithCollectionProperties alloc] init];
}

/* ====================================================================================================================================== */
#pragma mark - Arrays
- (void)test_should_resolve_collection_type_given_a_class_with_array_property
{
    TyphoonPropertyInjectedAsCollection
            * propertyInjectedAsCollection = [[TyphoonPropertyInjectedAsCollection alloc] initWithName:@"arrayCollection"];

    TyphoonCollectionType collectionType =
            [propertyInjectedAsCollection resolveCollectionTypeWith:(id <TyphoonIntrospectiveNSObject>) _classWithCollectionProperties];
    assertThatInt(collectionType, equalToInt(TyphoonCollectionTypeNSArray));

}

- (void)test_should_resolve_collection_type_given_a_class_with_mutable_array_property
{
    TyphoonPropertyInjectedAsCollection
            * propertyInjectedAsCollection = [[TyphoonPropertyInjectedAsCollection alloc] initWithName:@"mutableArrayCollection"];

    TyphoonCollectionType collectionType =
            [propertyInjectedAsCollection resolveCollectionTypeWith:(id <TyphoonIntrospectiveNSObject>) _classWithCollectionProperties];
    assertThatInt(collectionType, equalToInt(TyphoonCollectionTypeNSMutableArray));

}

/* ====================================================================================================================================== */
#pragma mark - Sets

- (void)test_should_resolve_collection_type_given_a_class_with_set_property
{
    TyphoonPropertyInjectedAsCollection
            * propertyInjectedAsCollection = [[TyphoonPropertyInjectedAsCollection alloc] initWithName:@"setCollection"];

    TyphoonCollectionType collectionType =
            [propertyInjectedAsCollection resolveCollectionTypeWith:(id <TyphoonIntrospectiveNSObject>) _classWithCollectionProperties];
    assertThatInt(collectionType, equalToInt(TyphoonCollectionTypeNSSet));
}

- (void)test_should_resolve_collection_type_given_a_class_with_mutable_set_property
{
    TyphoonPropertyInjectedAsCollection
            * propertyInjectedAsCollection = [[TyphoonPropertyInjectedAsCollection alloc] initWithName:@"mutableSetCollection"];

    TyphoonCollectionType collectionType =
            [propertyInjectedAsCollection resolveCollectionTypeWith:(id <TyphoonIntrospectiveNSObject>) _classWithCollectionProperties];
    assertThatInt(collectionType, equalToInt(TyphoonCollectionTypeNSMutableSet));
}

/* ====================================================================================================================================== */
#pragma mark - Exception handling

- (void)test_should_raise_exception_if_named_property_is_not_a_collection
{
    @try
    {
        TyphoonPropertyInjectedAsCollection
                * propertyInjectedAsCollection = [[TyphoonPropertyInjectedAsCollection alloc] initWithName:@"notACollection"];
        TyphoonCollectionType collectionType =
                [propertyInjectedAsCollection resolveCollectionTypeWith:(id <TyphoonIntrospectiveNSObject>) _classWithCollectionProperties];
        NSLog(@"%i", collectionType); //suppress warning;
        STFail(@"Should have thrown exception");
    }
    @catch (NSException* e)
    {
        assertThat([e description], equalTo(@"Property named 'notACollection' on 'NSString' is neither an NSSet nor NSArray."));
    }
}

- (void)test_should_raise_exception_if_named_property_does_not_exist
{
    @try
    {
        TyphoonPropertyInjectedAsCollection
                * propertyInjectedAsCollection = [[TyphoonPropertyInjectedAsCollection alloc] initWithName:@"notACollectionzzz"];
        TyphoonCollectionType collectionType =
                [propertyInjectedAsCollection resolveCollectionTypeWith:(id <TyphoonIntrospectiveNSObject>) _classWithCollectionProperties];
        NSLog(@"%i", collectionType); //suppress warning;
        STFail(@"Should have thrown exception");
    }
    @catch (NSException* e)
    {
        assertThat([e description], equalTo(
                @"Property named 'notACollectionzzz' does not exist on class 'ClassWithCollectionProperties'."));
    }

}

@end