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

#import "TyphoonWeakComponentsPool.h"
#import "NSObject+DeallocNotification.h"

@implementation TyphoonWeakComponentsPool
{
    NSMutableDictionary *dictionaryWithNonRetainedObjects;
}

- (id)init
{
    self = [super init];
    if (self) {
        CFDictionaryValueCallBacks callbacks = {0, NULL, NULL, NULL, NULL};
        dictionaryWithNonRetainedObjects =
            (__bridge_transfer id) CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &callbacks);
    }
    return self;
}

- (void)setObject:(id)object forKey:(id <NSCopying>)aKey
{
    __weak __typeof (dictionaryWithNonRetainedObjects) weakDict = dictionaryWithNonRetainedObjects;

    [object setDeallocNotificationInBlock:^{
        [weakDict removeObjectForKey:aKey];
    }];

    [dictionaryWithNonRetainedObjects setObject:object forKey:aKey];
}

- (id)objectForKey:(id <NSCopying>)aKey
{
    return [dictionaryWithNonRetainedObjects objectForKey:aKey];
}

- (NSArray *)allValues
{
    return [dictionaryWithNonRetainedObjects allValues];
}

- (void)removeAllObjects
{
    [dictionaryWithNonRetainedObjects removeAllObjects];
}

@end
