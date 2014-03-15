//
//  NSDictionary+CustomInjection.m
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 14.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "NSDictionary+CustomInjection.h"
#import "TyphoonInjectionByDictionary.h"
#import "TyphoonInjections.h"
#import "TyphoonLinkerCategoryBugFix.h"

TYPHOON_LINK_CATEGORY(NSDictionaryCustomInjections)

@implementation NSDictionary (TyphoonObjectWithCustomInjection)

- (id <TyphoonPropertyInjection, TyphoonParameterInjection>)typhoonCustomObjectInjection
{
    BOOL containsTyphoonObject = NO;

    id object = nil;
    NSEnumerator *objectEnumerator = [self objectEnumerator];
    while ((object = [objectEnumerator nextObject])) {
        if (IsTyphoonInjection(object) || [object conformsToProtocol:@protocol(TyphoonObjectWithCustomInjection)]) {
            containsTyphoonObject = YES;
            break;
        }
    }

    if (containsTyphoonObject) {
        return TyphoonInjectionWithDictionaryAndType(self, [self class]);
    }
    else {
        return TyphoonInjectionWithObject(self);
    }
}

@end
