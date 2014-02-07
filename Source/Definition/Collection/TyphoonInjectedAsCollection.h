////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2014 ibipit
//  All Rights Reserved.
//
//  NOTICE: This software is the proprietary information of ibipit
//  Use is subject to license terms.
//
////////////////////////////////////////////////////////////////////////////////


#import <Foundation/Foundation.h>

@class TyphoonDefinition;

typedef enum
{
    TyphoonCollectionTypeNSArray,
    TyphoonCollectionTypeNSMutableArray,
    TyphoonCollectionTypeNSSet,
    TyphoonCollectionTypeNSMutableSet,
    TyphoonCollectionTypeNSCountedSet
} TyphoonCollectionType;

@protocol TyphoonInjectedAsCollection <NSObject>

- (void)addItemWithText:(NSString*)text requiredType:(Class)requiredType;

- (void)addItemWithComponentName:(NSString*)componentName;

- (void)addItemWithDefinition:(TyphoonDefinition*)definition;

- (NSArray*)values;

- (id)withFactory:(TyphoonComponentFactory*)factory newInstanceOfType:(TyphoonCollectionType)type;

@end