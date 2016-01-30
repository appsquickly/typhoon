////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2015, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "TyphoonDefinitionBase+Infrastructure.h"
#import "TyphoonDefinitionBase+Internal.h"
#import "TyphoonLinkerCategoryBugFix.h"

TYPHOON_LINK_CATEGORY(TyphoonDefinitionBase_Infrastructure)

@implementation TyphoonDefinitionBase (Infrastructure)

@dynamic key;

+ (instancetype)withClass:(Class)clazz key:(NSString *)key
{
    return [[self alloc] initWithClass:clazz key:key];
}

- (BOOL)isCandidateForInjectedClass:(Class)clazz includeSubclasses:(BOOL)includeSubclasses
{
    BOOL result = NO;
    if (self.autoInjectionVisibility & TyphoonAutoInjectVisibilityByClass) {
        BOOL isSameClass = self.type == clazz;
        BOOL isSubclass = includeSubclasses && [self.type isSubclassOfClass:clazz];
        result = isSameClass || isSubclass;
    }
    return result;
}

- (BOOL)isCandidateForInjectedProtocol:(Protocol *)aProtocol
{
    BOOL result = NO;
    if (self.autoInjectionVisibility & TyphoonAutoInjectVisibilityByProtocol) {
        result = [self.type conformsToProtocol:aProtocol];
    }
    return result;
}

@end
