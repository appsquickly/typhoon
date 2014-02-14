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
#import <TyphoonParameterInjectedAsCollection.h>
#import <OCHamcrest.h>

@interface TyphoonParameterInjectedAsCollectionTests : SenTestCase

@end

@implementation TyphoonParameterInjectedAsCollectionTests

#pragma mark - Convenience methods

- (TyphoonParameterInjectedAsCollection *)parameterWithIndex:(NSUInteger)index type:(id)type {
    return [[TyphoonParameterInjectedAsCollection alloc] initWithParameterIndex:index requiredType:type];
}

- (TyphoonParameterInjectedAsCollection *)parameterWithType:(id)type {
    return [self parameterWithIndex:0 type:type];
}

#pragma mark - Arrays

- (void)test_should_resolve_array_from_required_type {
    TyphoonParameterInjectedAsCollection *parameterInjectedAsCollection = [self parameterWithType:[NSArray class]];

    assertThatInt([parameterInjectedAsCollection collectionType], equalToInt(TyphoonCollectionTypeNSArray));
}

- (void)test_should_resolve_mutable_array_from_required_type {
    TyphoonParameterInjectedAsCollection *parameterInjectedAsCollection = [self parameterWithType:[NSMutableArray class]];

    assertThatInt([parameterInjectedAsCollection collectionType], equalToInt(TyphoonCollectionTypeNSMutableArray));
}

#pragma mark - Sets

- (void)test_should_resolve_set_from_required_type {
    TyphoonParameterInjectedAsCollection *parameterInjectedAsCollection = [self parameterWithType:[NSSet class]];

    assertThatInt([parameterInjectedAsCollection collectionType], equalToInt(TyphoonCollectionTypeNSSet));
}

- (void)test_should_resolve_mutable_set_from_required_type {
    TyphoonParameterInjectedAsCollection *parameterInjectedAsCollection = [self parameterWithType:[NSMutableSet class]];

    assertThatInt([parameterInjectedAsCollection collectionType], equalToInt(TyphoonCollectionTypeNSMutableSet));
}

- (void)test_should_resolve_counted_set_from_required_type {
    TyphoonParameterInjectedAsCollection *parameterInjectedAsCollection = [self parameterWithType:[NSCountedSet class]];

    assertThatInt([parameterInjectedAsCollection collectionType], equalToInt(TyphoonCollectionTypeNSCountedSet));
}

#pragma mark - Exception handling

- (void)test_should_raise_exception_if_required_type_is_nil {
    TyphoonParameterInjectedAsCollection *parameterInjectedAsCollection = [self parameterWithType:nil];

    @try {
        [parameterInjectedAsCollection collectionType];
        STFail(@"Should have thrown exception");
    }
    @catch (NSException *exception) {
        assertThat([exception description], equalTo(@"Required type is missing on injected collection parameter!"));
    }
}

- (void)test_should_raise_exception_if_required_type_is_not_a_collection {
    TyphoonParameterInjectedAsCollection *parameterInjectedAsCollection = [self parameterWithType:[NSString class]];

    @try {
        [parameterInjectedAsCollection collectionType];
        STFail(@"Should have thrown exception");
    }
    @catch (NSException *exception) {
        assertThat([exception description], equalTo(@"Required collection type 'NSString' is neither an NSSet nor NSArray."));
    }
}


@end
