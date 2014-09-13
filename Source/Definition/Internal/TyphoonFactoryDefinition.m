//
// Created by Aleksey Garbarev on 13.09.14.
// Copyright (c) 2014 typhoonframework.org. All rights reserved.
//

#import "TyphoonFactoryDefinition.h"
#import "TyphoonIntrospectionUtils.h"


@implementation TyphoonFactoryDefinition

- (BOOL)matchesAutoInjectionWithType:(id)classOrProtocol includeSubclasses:(BOOL)includeSubclasses
{
    BOOL result = NO;

    Class componentClass = IsClass(self.classOrProtocolForAutoInjection) ? self.classOrProtocolForAutoInjection : nil;
    Protocol *componentProtocol = IsProtocol(self.classOrProtocolForAutoInjection) ? self.classOrProtocolForAutoInjection : nil;

    BOOL isClass = IsClass(classOrProtocol);
    BOOL isProtocol = IsProtocol(classOrProtocol);

    if (componentClass && isClass && self.autoInjectionVisibility & TyphoonAutoInjectVisibilityByClass) {
        BOOL isSameClass = componentClass == classOrProtocol;
        BOOL isSubclass = includeSubclasses && [componentClass isSubclassOfClass:classOrProtocol];
        result = isSameClass || isSubclass;
    }
    else if (isProtocol && self.autoInjectionVisibility & TyphoonAutoInjectVisibilityByProtocol) {
        if (componentClass) {
            result = [componentClass conformsToProtocol:classOrProtocol];
        } else if (componentProtocol) {
            result = componentProtocol == classOrProtocol;
        }
    }

    return result;
}

+ (id)withConfiguration:(void(^)(TyphoonFactoryDefinition *definition))injections
{
    return [self withClass:[NSObject class] configuration:^(TyphoonDefinition *definition) {
        injections((TyphoonFactoryDefinition *) definition);
    }];
}


@end