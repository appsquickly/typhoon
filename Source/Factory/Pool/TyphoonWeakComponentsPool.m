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
    NSMutableDictionary* dictionaryWithUnretainedObjects;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        CFDictionaryValueCallBacks callbacks = {0, NULL, NULL, NULL, NULL};
        dictionaryWithUnretainedObjects = (__bridge_transfer id)CFDictionaryCreateMutable(NULL,
                0,
                &kCFTypeDictionaryKeyCallBacks,
                &callbacks);
    }
    return self;
}

- (void)setObject:(id)object forKey:(id <NSCopying>)aKey
{
    __weak typeof (dictionaryWithUnretainedObjects) weakDict = dictionaryWithUnretainedObjects;

    [object setDeallocNotificationInBlock:^
    {
        [weakDict removeObjectForKey:aKey];
    }];

    [dictionaryWithUnretainedObjects setObject:object forKey:aKey];
}

- (id)objectForKey:(id <NSCopying>)aKey
{
    return [dictionaryWithUnretainedObjects objectForKey:aKey];
}

- (NSArray*)allValues
{
    return [dictionaryWithUnretainedObjects allValues];
}

- (void)removeAllObjects
{
    [dictionaryWithUnretainedObjects removeAllObjects];
}

@end
