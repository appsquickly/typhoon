//
//  TyphoonInjections.h
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 12.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonInjectedAsCollection.h"

id TyphoonInjectionWithObjectFromString(NSString *string);

id TyphoonInjectionWithObjectFromStringWithType(NSString *string, Class objectClass);

id TyphoonInjectionWithCollection(void (^collection)(id<TyphoonInjectedAsCollection> collectionBuilder));

id TyphoonInjectionWithCollectionAndType(Class collectionClass, void (^collection)(id<TyphoonInjectedAsCollection> collectionBuilder));

id TyphoonInjectionWithRuntimeArgumentAtIndex(NSInteger argumentIndex);
