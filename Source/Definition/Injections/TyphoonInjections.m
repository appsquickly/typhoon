////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "TyphoonInjections.h"

#import "TyphoonInjectionByType.h"
#import "TyphoonInjectionByReference.h"
#import "TyphoonInjectionByObjectInstance.h"
#import "TyphoonInjectionByObjectFromString.h"
#import "TyphoonInjectionByCollection.h"
#import "TyphoonInjectionByRuntimeArgument.h"
#import "TyphoonInjectionByDictionary.h"

#import "TyphoonObjectWithCustomInjection.h"
#import "TyphoonInjectionByConfig.h"

#import <objc/runtime.h>

static const char *typhoonRuntimeArgumentBlockWrapperKey;

BOOL IsWrappedIntoTyphoonBlock(id objectOrBlock) ;

id TyphoonInjectionMatchedByType(void) {
    return [[TyphoonInjectionByType alloc] init];
}

id TyphoonInjectionWithObjectFromString(NSString *string) {
    return [[TyphoonInjectionByObjectFromString alloc] initWithString:string];
}

id TyphoonInjectionWithCollectionAndType(id collection, Class requiredClass) {
    return [[TyphoonInjectionByCollection alloc] initWithCollection:collection requiredClass:requiredClass];
}

id TyphoonInjectionWithDictionaryAndType(id dictionary, Class requiredClass) {
    return [[TyphoonInjectionByDictionary alloc] initWithDictionary:dictionary requiredClass:requiredClass];
}

id TyphoonInjectionWithRuntimeArgumentAtIndex(NSUInteger argumentIndex) {
    return [[TyphoonInjectionByRuntimeArgument alloc] initWithArgumentIndex:argumentIndex];
}

id TyphoonInjectionWithRuntimeArgumentAtIndexWrappedIntoBlock(NSUInteger argumentIndex) {
    id(^block)() = ^{return[[TyphoonInjectionByRuntimeArgument alloc] initWithArgumentIndex:argumentIndex];};
    objc_setAssociatedObject(block, &typhoonRuntimeArgumentBlockWrapperKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return block;
}

id TyphoonInjectionWithObject(id object) {
    return [[TyphoonInjectionByObjectInstance alloc] initWithObjectInstance:object];
}

id TyphoonInjectionWithReference(NSString *reference) {
    return [[TyphoonInjectionByReference alloc] initWithReference:reference args:nil];
}

id TyphoonInjectionWithConfigKey(NSString *configKey)
{
    return [[TyphoonInjectionByConfig alloc] initWithConfigKey:configKey];
}

id TyphoonMakeInjectionFromObjectIfNeeded(id objectOrInjection) {
    id injection = nil;

    if ([objectOrInjection conformsToProtocol:@protocol(TyphoonObjectWithCustomInjection)]) {
        injection = [objectOrInjection typhoonCustomObjectInjection];
    }
    else if (IsTyphoonInjection(objectOrInjection)) {
        injection = objectOrInjection;
    }
    else if (IsWrappedIntoTyphoonBlock(objectOrInjection)) {
        injection = ((id(^)())objectOrInjection)();
    }
    else {
        injection = TyphoonInjectionWithObject(objectOrInjection);
    }

    return injection;
}

BOOL IsTyphoonInjection(id objectOrInjection) {
    return [objectOrInjection conformsToProtocol:@protocol(TyphoonPropertyInjection)] ||
        [objectOrInjection conformsToProtocol:@protocol(TyphoonParameterInjection)];
}

BOOL IsWrappedIntoTyphoonBlock(id objectOrBlock) {
    return [objc_getAssociatedObject(objectOrBlock, &typhoonRuntimeArgumentBlockWrapperKey) isEqualToNumber:@YES];
}

