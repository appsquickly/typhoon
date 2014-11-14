//
// Created by Aleksey Garbarev on 13.09.14.
// Copyright (c) 2014 typhoonframework.org. All rights reserved.
//

#import "TyphoonFactoryDefinition.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonDefinition+Infrastructure.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonRuntimeArguments.h"


@implementation TyphoonFactoryDefinition {
    NSString *_factoryKey;
};

- (id)targetForInitializerWithFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)args
{
    return [factory componentForKey:_factoryKey];
}

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

- (id)initWithFactory:(id)factory selector:(SEL)selector parameters:(void(^)(TyphoonMethod *method))params;
{
    self = [super initWithClass:[NSObject class] key:nil];
    if (self) {
        _factoryKey = [factory key];
        self.scope = TyphoonScopePrototype;
        [super useInitializer:selector parameters:params];
    }
    return self;
}

- (void)useInitializer:(SEL)selector parameters:(void (^)(TyphoonMethod *initializer))parametersBlock
{
    NSAssert(NO, @"You cannot change initializer of TyphoonFactoryDefinition");
}

- (void)useInitializer:(SEL)selector
{
    NSAssert(NO, @"You cannot change initializer of TyphoonFactoryDefinition");
}
@end