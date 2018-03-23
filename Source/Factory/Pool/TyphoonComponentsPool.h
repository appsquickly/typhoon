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


#import <Foundation/Foundation.h>

/** Methods from NSMutableDictionary which used in componentsPool. Created to maintain custom TyphoonWeakComponentsPool */

@protocol TyphoonComponentsPool <NSObject>

- (void)setObject:(id)object forKey:(id <NSCopying>)aKey;

- (id)objectForKey:(id <NSCopying>)aKey;

- (id)objectForKeyedSubscript:(id <NSCopying>)aKey;

- (void)setObject:(id)object forKeyedSubscript:(id <NSCopying>)aKey;

- (NSArray *)allValues;

- (void)removeAllObjects;

@end
