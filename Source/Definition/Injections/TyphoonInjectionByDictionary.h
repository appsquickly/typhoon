//
//  TyphoonInjectionDictionary.h
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 14.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

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
