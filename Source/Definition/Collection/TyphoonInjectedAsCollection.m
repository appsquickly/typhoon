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

#import "TyphoonInjectedAsCollection.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonDefinition.h"
#import "TyphoonTypeConvertedCollectionValue.h"
#import "TyphoonByReferenceCollectionValue.h"
#import "TyphoonComponentFactory.h"

@implementation TyphoonInjectedAsCollection
{
    NSMutableArray *_values;
}

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)init
{
    self = [super init];
    if (self) {
        _values = [[NSMutableArray alloc] init];
    }
    return self;
}


/* ====================================================================================================================================== */
#pragma mark - Interface Methods

- (void)addItemWithText:(NSString *)text requiredType:(Class)requiredType
{
    [_values addObject:[[TyphoonTypeConvertedCollectionValue alloc] initWithTextValue:text requiredType:requiredType]];
}

- (void)addItemWithComponentName:(NSString *)componentName
{
    [_values addObject:[[TyphoonByReferenceCollectionValue alloc] initWithComponentKey:componentName]];
}

- (void)addItemWithDefinition:(TyphoonDefinition *)definition
{
    [_values addObject:[[TyphoonByReferenceCollectionValue alloc] initWithComponentKey:definition.key]];
}

- (NSArray *)values
{
    return [_values copy];
}

- (void)addValue:(id <TyphoonCollectionValue>)value
{
    [_values addObject:value];
}


- (id)withFactory:(TyphoonComponentFactory *)factory newCollectionOfType:(TyphoonCollectionType)type
{
    id collection = [self newCollectionForType:type];

    for (id <TyphoonCollectionValue> value in self.values) {
        [collection addObject:[value resolveWithFactory:factory]];
    }

    BOOL isMutable = (type == TyphoonCollectionTypeNSMutableArray || type == TyphoonCollectionTypeNSMutableSet);
    return isMutable ? collection : [collection copy];
}

/* ====================================================================================================================================== */
#pragma mark - Utility Methods

- (id)copyWithZone:(NSZone *)zone
{
    TyphoonInjectedAsCollection *copy = [[TyphoonInjectedAsCollection alloc] init];
    for (id <TyphoonCollectionValue> value in _values) {
        [copy addValue:value];
    }
    return copy;
}

/* ====================================================================================================================================== */
#pragma mark - Private Methods

- (id)newCollectionForType:(TyphoonCollectionType)type
{
    id collection;
    if (type == TyphoonCollectionTypeNSArray || type == TyphoonCollectionTypeNSMutableArray) {
        collection = [[NSMutableArray alloc] init];
    }
    else if (type == TyphoonCollectionTypeNSCountedSet) {
        collection = [[NSCountedSet alloc] init];
    }
    else if (type == TyphoonCollectionTypeNSSet || type == TyphoonCollectionTypeNSMutableSet) {
        collection = [[NSMutableSet alloc] init];
    }

    return collection;
}


@end
