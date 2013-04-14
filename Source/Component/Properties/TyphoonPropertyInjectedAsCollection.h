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


#import <Foundation/Foundation.h>
#import "TyphoonInjectedProperty.h"

@class TyphoonDefinition;

typedef enum
{
    TyphoonCollectionTypeNSArray,
    TyphoonCollectionTypeNSSet
} TyphoonCollectionType;

/**
* Represents a collection (NSArray, NSSet, c-style array) of items injected by reference, value or type.
*/
@interface TyphoonPropertyInjectedAsCollection : NSObject<TyphoonInjectedProperty>
{
    NSString* _name;
    NSMutableArray* _values;
    NSMutableArray* _references;
}

@property(nonatomic, strong, readonly) NSString* name;

- (id)initWithName:(NSString*)name;

- (void)addItemWithText:(NSString*)text;

- (void)addItemWithComponentName:(NSString*)componentName;

- (void)addItemWithDefinition:(TyphoonDefinition*)definition;

/**
* Returns the collection type for the named property on the parameter class. Raises an exception if the property is neither an NSSet nor
* an NSArray.
*/
- (TyphoonCollectionType)resolveCollectionTypeGiven:(Class)clazz;





@end