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
