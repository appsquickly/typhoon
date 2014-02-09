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


#import <Foundation/Foundation.h>
#import "TyphoonAbstractInjectedProperty.h"
#import "TyphoonInjectedAsCollection.h"

@class TyphoonDefinition;

/**
* Represents a collection (NSArray, NSSet, c-style array) of items injected by reference, value or type.
*/
@interface TyphoonPropertyInjectedAsCollection : TyphoonAbstractInjectedProperty <TyphoonInjectedAsCollection>


- (id)initWithName:(NSString *)name;

/**
* Returns the collection type for the named property on the parameter class. Raises an exception if the property is neither an NSSet nor
* an NSArray.
*/
- (TyphoonCollectionType)resolveCollectionTypeWith:(id <TyphoonIntrospectiveNSObject>)instance;

#pragma mark - <TyphoonInjectedAsCollection> trait

- (void)addItemWithText:(NSString *)text requiredType:(Class)requiredType;

- (void)addItemWithComponentName:(NSString *)componentName;

- (void)addItemWithDefinition:(TyphoonDefinition *)definition;

- (NSArray *)values;


@end
