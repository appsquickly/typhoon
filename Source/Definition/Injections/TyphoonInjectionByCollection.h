////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

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
