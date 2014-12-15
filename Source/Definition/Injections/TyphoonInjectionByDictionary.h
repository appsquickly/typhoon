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

@protocol TyphoonDictionary <NSObject>

- (id)initWithCapacity:(NSUInteger)capacity;

- (NSUInteger)count;

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id key, id obj, BOOL *stop))block;

- (void)setObject:(id)anObject forKey:(id)aKey;

@end

@interface TyphoonInjectionByDictionary : TyphoonAbstractInjection

- (instancetype)initWithDictionary:(id)dictionary requiredClass:(Class)dictionaryClass;

@end
