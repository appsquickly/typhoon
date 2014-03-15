//
//  TyphoonInjectionByCollection.h
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 12.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonAbstractInjection.h"

/** Protocol which should be confirmed by collection (NSArray, NSSet, NSOrderedSet are conforms) */
@protocol TyphoonCollection <NSObject, NSFastEnumeration>

- (id)initWithCapacity:(NSUInteger)capacity;

- (NSUInteger)count;

- (void)addObject:(id)object;

@end

@interface TyphoonInjectionByCollection : TyphoonAbstractInjection

- (instancetype)initWithCollection:(id)collection requiredClass:(Class)collectionClass;

+ (Class)collectionMutableClassFromClass:(Class)collectionClass;

+ (BOOL)isCollectionClass:(Class)collectionClass;

- (NSUInteger)count;

@end
