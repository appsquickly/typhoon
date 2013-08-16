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
#import "TyphoonInjectedProperty.h"

@class TyphoonDefinition;

typedef enum
{
    TyphoonCollectionTypeNSArray,
    TyphoonCollectionTypeNSMutableArray,
    TyphoonCollectionTypeNSSet,
    TyphoonCollectionTypeNSMutableSet,
    TyphoonCollectionTypeNSCountedSet
} TyphoonCollectionType;

/**
* Represents a collection (NSArray, NSSet, c-style array) of items injected by reference, value or type.
*/
@interface TyphoonPropertyInjectedAsCollection : NSObject<TyphoonInjectedProperty>
{
    NSString* _name;
    NSMutableArray* _values;
}

@property(nonatomic, strong, readonly) NSString* name;

- (id)initWithName:(NSString*)name;

- (void)addItemWithText:(NSString*)text requiredType:(Class)requiredType;

- (void)addItemWithComponentName:(NSString*)componentName;

- (void)addItemWithDefinition:(TyphoonDefinition*)definition;

- (NSArray*)values;

/**
* Returns the collection type for the named property on the parameter class. Raises an exception if the property is neither an NSSet nor
* an NSArray.
*/
- (TyphoonCollectionType)resolveCollectionTypeWith:(id<TyphoonIntrospectiveNSObject>)instance;



@end