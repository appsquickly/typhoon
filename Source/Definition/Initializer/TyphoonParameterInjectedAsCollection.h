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
#import "TyphoonInjectedAsCollection.h"
#import "TyphoonAbstractInjectedParameter.h"

/**
*/
@interface TyphoonParameterInjectedAsCollection : TyphoonAbstractInjectedParameter <TyphoonInjectedAsCollection>

@property(nonatomic, readonly) TyphoonCollectionType collectionType;

- (id)initWithParameterIndex:(NSUInteger)index requiredType:(Class)requiredType;


#pragma mark - <TyphoonInjectedAsCollection> trait

- (void)addItemWithText:(NSString *)text requiredType:(Class)requiredType;

- (void)addItemWithComponentName:(NSString *)componentName;

- (void)addItemWithDefinition:(TyphoonDefinition *)definition;

@end
