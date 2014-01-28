//
//  TyphoonComponentsPool.h
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 29.01.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Methods from NSMutableDictionary which used in componentsPool. Created to maintain custom TyphoonWeekComponentsPool */

@protocol TyphoonComponentsPool <NSObject>

- (void) setObject:(id)object forKey:(id<NSCopying>)aKey;
- (id) objectForKey:(id<NSCopying>)aKey;

- (NSArray *) allValues;

- (void) removeAllObjects;

@end
