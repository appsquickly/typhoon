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


id TyphoonInjectionWithObjectFromString(NSString *string)
{
    return TyphoonInjectionWithObjectFromStringWithType(string, nil);
}

id TyphoonInjectionWithObjectFromStringWithType(NSString *string, Class reqiuredType)
{
    return [[TyphoonInjectionByObjectFromString alloc] initWithString:string objectClass:reqiuredType];
}

id TyphoonInjectionWithCollection(void (^collection)(id<TyphoonInjectedAsCollection> collectionBuilder))
{
    return TyphoonInjectionWithCollectionAndType(nil, collection);
}

id TyphoonInjectionWithCollectionAndType(Class collectionClass, void (^collection)(id<TyphoonInjectedAsCollection> collectionBuilder))
{
    TyphoonInjectionByCollection *propertyInjectedAsCollection = [[TyphoonInjectionByCollection alloc] initWithRequiredType:collectionClass];
    
    if (collection) {
        __unsafe_unretained TyphoonInjectionByCollection *weakPropertyInjectedAsCollection = propertyInjectedAsCollection;
        collection(weakPropertyInjectedAsCollection);
    }
    return propertyInjectedAsCollection;
}

id TyphoonInjectionWithRuntimeArgumentAtIndex(NSInteger argumentIndex)
{
    return [[TyphoonInjectionByRuntimeArgument alloc] initWithArgumentIndex:argumentIndex];
}

