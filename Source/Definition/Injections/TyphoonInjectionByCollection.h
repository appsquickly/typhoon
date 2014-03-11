//
//  TyphoonInjectionByCollection.h
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 12.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonAbstractInjection.h"
#import "TyphoonInjectedAsCollection.h"

@interface TyphoonInjectionByCollection : TyphoonAbstractInjection <TyphoonInjectedAsCollection>

@property (nonatomic, strong, readonly) Class requiredType;

- (instancetype)init;
- (instancetype)initWithRequiredType:(Class)requiredType;

/**
 * Returns the collection type for the named property on the parameter class. Raises an exception if the property is neither an NSSet nor
 * an NSArray.
 */
- (TyphoonCollectionType)collectionTypeForPropertyInjectionOnInstance:(id)instance;
- (TyphoonCollectionType)collectionTypeForParameterInjection;

#pragma mark - <TyphoonInjectedAsCollection> trait

- (void)addItemWithText:(NSString *)text requiredType:(Class)requiredType;

- (void)addItemWithComponentName:(NSString *)componentName;

- (void)addItemWithDefinition:(TyphoonDefinition *)definition;

- (NSArray *)values;

@end
