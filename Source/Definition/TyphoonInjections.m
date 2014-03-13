//
//  TyphoonInjection.m
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 12.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonInjections.h"

#import "TyphoonInjectionByType.h"
#import "TyphoonInjectionByReference.h"
#import "TyphoonInjectionByFactoryReference.h"
#import "TyphoonInjectionByObjectInstance.h"
#import "TyphoonInjectionByObjectFromString.h"
#import "TyphoonInjectionByCollection.h"
#import "TyphoonInjectionByComponentFactory.h"
#import "TyphoonInjectionByRuntimeArgument.h"
#import "TyphoonInjectionByObjectInstance.h"
#import "TyphoonInjectionByReference.h"
#import "TyphoonInjectionByType.h"
#import "TyphoonInjectionByDictionary.h"

#import "TyphoonObjectWithCustomInjection.h"
#import "TyphoonPropertyInjection.h"
#import "TyphoonParameterInjection.h"

id TyphoonInjectionMatchedByType(void)
{
    return [[TyphoonInjectionByType alloc] init];
}

id TyphoonInjectionWithObjectFromString(NSString *string)
{
    return TyphoonInjectionWithObjectFromStringWithType(string, nil);
}

id TyphoonInjectionWithObjectFromStringWithType(NSString *string, Class reqiuredType)
{
    return [[TyphoonInjectionByObjectFromString alloc] initWithString:string objectClass:reqiuredType];
}

id TyphoonInjectionWithCollectionAndType(id collection, Class requiredClass)
{
    return [[TyphoonInjectionByCollection alloc] initWithCollection:collection requiredClass:requiredClass];
}

id TyphoonInjectionWithDictionaryAndType(id dictionary, Class requiredClass)
{
    return [[TyphoonInjectionByDictionary alloc] initWithDictionary:dictionary requiredClass:requiredClass];
}

id TyphoonInjectionWithRuntimeArgumentAtIndex(NSInteger argumentIndex)
{
    return [[TyphoonInjectionByRuntimeArgument alloc] initWithArgumentIndex:argumentIndex];
}

id TyphoonInjectionWithObject(id object)
{
    return [[TyphoonInjectionByObjectInstance alloc] initWithObjectInstance:object];
}

id TyphoonInjectionWithReference(NSString *reference)
{
    return [[TyphoonInjectionByReference alloc] initWithReference:reference args:nil];
}

id TyphoonMakeInjectionFromObjectIfNeeded(id objectOrInjection)
{
    id injection = nil;
    
    if ([objectOrInjection conformsToProtocol:@protocol(TyphoonObjectWithCustomInjection)]) {
        injection = [objectOrInjection typhoonCustomObjectInjection];
    } else if (IsTyphoonInjection(objectOrInjection)) {
        injection = objectOrInjection;
    } else {
        injection = TyphoonInjectionWithObject(objectOrInjection);
    }
    
    return injection;
}

BOOL IsTyphoonInjection(id objectOrInjection)
{
    return [objectOrInjection conformsToProtocol:@protocol(TyphoonPropertyInjection)] || [objectOrInjection conformsToProtocol:@protocol(TyphoonParameterInjection)];
}



