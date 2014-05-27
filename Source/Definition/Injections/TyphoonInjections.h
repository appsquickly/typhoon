//
//  TyphoonInjections.h
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 12.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

id TyphoonInjectionMatchedByType(void);

id TyphoonInjectionWithObjectFromString(NSString *string);

id TyphoonInjectionWithCollectionAndType(id collection, Class requiredClass);

id TyphoonInjectionWithDictionaryAndType(id dictionary, Class requiredClass);

id TyphoonInjectionWithRuntimeArgumentAtIndex(NSInteger argumentIndex);

id TyphoonInjectionWithObject(id object);

id TyphoonInjectionWithReference(NSString *reference);

id TyphoonInjectionWithConfigKey(NSString *configKey);

id TyphoonMakeInjectionFromObjectIfNeeded(id objectOrInjection);

BOOL IsTyphoonInjection(id objectOrInjection);
