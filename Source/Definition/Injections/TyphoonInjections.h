//
//  TyphoonInjections.h
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 12.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//


id TyphoonInjectionWithObjectFromString(NSString *string);

id TyphoonInjectionWithObjectFromStringWithType(NSString *string, Class objectClass);

id TyphoonInjectionWithCollectionAndType(id collection, Class requiredClass);

id TyphoonInjectionWithRuntimeArgumentAtIndex(NSInteger argumentIndex);

id TyphoonInjectionWithObject(id object);

id TyphoonInjectionWithReference(NSString *reference);