//
//  Collections+CustomInjection.m
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 13.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "Collections+CustomInjection.h"
#import "TyphoonInjectionByCollection.h"
#import "TyphoonInjections.h"
#import "TyphoonLinkerCategoryBugFix.h"

TYPHOON_LINK_CATEGORY(CollectionsCustomInjections)

static __inline__ BOOL IsContainsTyphoonObjectInCollection(id <NSFastEnumeration> collection) {
    BOOL foundTyphoonObject = NO;

    for (id object in collection) {
        if ([object conformsToProtocol:@protocol(TyphoonObjectWithCustomInjection)] || IsTyphoonInjection(object)) {
            foundTyphoonObject = YES;
            break;
        }
    }

    return foundTyphoonObject;
}

static __inline__ id InjectionForCollection(id <NSFastEnumeration, NSObject> collection) {
    if (IsContainsTyphoonObjectInCollection(collection)) {
        return TyphoonInjectionWithCollectionAndType(collection, [collection class]);
    }
    else {
        return TyphoonInjectionWithObject(collection);
    }
}

@implementation NSArray (TyphoonObjectWithCustomInjection)

- (id <TyphoonPropertyInjection, TyphoonParameterInjection>)typhoonCustomObjectInjection
{
    return InjectionForCollection(self);
}

@end

@implementation NSSet (TyphoonObjectWithCustomInjection)

- (id <TyphoonPropertyInjection, TyphoonParameterInjection>)typhoonCustomObjectInjection
{
    return InjectionForCollection(self);
}
@end

@implementation NSOrderedSet (TyphoonObjectWithCustomInjection)

- (id <TyphoonPropertyInjection, TyphoonParameterInjection>)typhoonCustomObjectInjection
{
    return InjectionForCollection(self);
}

@end
