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
