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
@protocol TyphoonIntrospectiveNSObject;



@protocol TyphoonInjectedAsCollection

- (void)addItemWithText:(NSString*)text requiredType:(Class)requiredType;

- (void)addItemWithComponentName:(NSString*)componentName;

- (void)addItemWithDefinition:(TyphoonDefinition*)definition;

@end

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
@interface TyphoonInjectedAsCollection : NSObject<TyphoonInjectedAsCollection>

- (void)addItemWithText:(NSString*)text requiredType:(Class)requiredType;

- (void)addItemWithComponentName:(NSString*)componentName;

- (void)addItemWithDefinition:(TyphoonDefinition*)definition;

- (NSArray*)values;

- (id)withFactory:(TyphoonComponentFactory*)factory newCollectionOfType:(TyphoonCollectionType)type;


@end
