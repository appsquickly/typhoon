////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "TyphoonFactoryDefinition.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonDefinition+Infrastructure.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonRuntimeArguments.h"


@implementation TyphoonFactoryDefinition
{
    NSString *_factoryKey;
};

- (id)targetForInitializerWithFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)args
{
    return [factory componentForKey:_factoryKey];
}


- (id)initWithFactory:(id)factory selector:(SEL)selector parameters:(void (^)(TyphoonMethod *method))params;
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

//-------------------------------------------------------------------------------------------
#pragma mark - Overridden Methods
//-------------------------------------------------------------------------------------------

- (BOOL)isCandidateForInjectedClass:(Class)clazz includeSubclasses:(BOOL)includeSubclasses
{
    BOOL result = NO;
    if (self.autoInjectionVisibility & TyphoonAutoInjectVisibilityByClass) {
        BOOL isSameClass = self.classOrProtocolForAutoInjection == clazz;
        BOOL isSubclass = includeSubclasses && [self.classOrProtocolForAutoInjection isSubclassOfClass:clazz];
        result = isSameClass || isSubclass;
    }
    return result;
}

- (BOOL)isCandidateForInjectedProtocol:(Protocol *)aProtocol
{
    Class componentClass = IsClass(self.classOrProtocolForAutoInjection) ? self.classOrProtocolForAutoInjection : nil;
    Protocol *componentProtocol = IsProtocol(self.classOrProtocolForAutoInjection) ? self.classOrProtocolForAutoInjection : nil;

    BOOL result = NO;

    if (self.autoInjectionVisibility & TyphoonAutoInjectVisibilityByProtocol) {
        if (componentClass) {
            result = [componentClass conformsToProtocol:aProtocol];
        } else if (componentProtocol) {
            result = componentProtocol == aProtocol;
        }
    }
    return result;
}


@end