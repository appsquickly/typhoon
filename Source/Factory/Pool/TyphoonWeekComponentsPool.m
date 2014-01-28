//
//  TyphoonWeekComponentsPool.m
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 29.01.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonWeekComponentsPool.h"
#import "NSObject+DeallocNotification.h"

@implementation TyphoonWeekComponentsPool {
    NSMutableDictionary *dictionaryWithUnretainedObjects;
}

- (id)init
{
    self = [super init];
    if (self) {
        CFDictionaryValueCallBacks callbacks = {0, NULL, NULL, NULL, NULL};
        dictionaryWithUnretainedObjects = (__bridge_transfer id)CFDictionaryCreateMutable(NULL,
                                                                0,
                                                                &kCFTypeDictionaryKeyCallBacks,
                                                                &callbacks);
    }
    return self;
}

- (void) setObject:(id)object forKey:(id<NSCopying>)aKey
{
    __weak typeof (dictionaryWithUnretainedObjects) weakDict = dictionaryWithUnretainedObjects;
    
    [object setDeallocNotificationInBlock:^{
        [weakDict removeObjectForKey:aKey];
    }];
    
    [dictionaryWithUnretainedObjects setObject:object forKey:aKey];
}

- (id) objectForKey:(id<NSCopying>)aKey
{
    return [dictionaryWithUnretainedObjects objectForKey:aKey];
}

- (NSArray *) allValues
{
    return [dictionaryWithUnretainedObjects allValues];
}

- (void) removeAllObjects
{
    [dictionaryWithUnretainedObjects removeAllObjects];
}

@end
