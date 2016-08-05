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

#import "TyphoonLinkerCategoryBugFix.h"

TYPHOON_LINK_CATEGORY(TyphoonDefinition_InstanceBuilder)

#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonDefinition+Infrastructure.h"
#import "TyphoonMethod+InstanceBuilder.h"

#import "TyphoonInjectionByType.h"
#import "TyphoonInjectionByRuntimeArgument.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonRuntimeArguments.h"
#import "TyphoonIntrospectionUtils.h"
#import "NSObject+TyphoonIntrospectionUtils.h"
#import "NSObject+PropertyInjection.h"
#import "NSInvocation+TCFInstanceBuilder.h"

@implementation TyphoonDefinition (InstanceBuilder)

#pragma mark - Instance Builder

- (id)initializeInstanceWithArgs:(TyphoonRuntimeArguments *)args factory:(TyphoonComponentFactory *)factory
{
    __block id instance = [self targetForInitializerWithFactory:factory args:args];
    if (self.initializer && instance) {
        BOOL isClass = IsClass(instance);

        TyphoonInjectionContext *context = [[TyphoonInjectionContext alloc] initWithFactory:factory args:args
            raiseExceptionIfCircular:YES];
        context.classUnderConstruction = isClass ? (Class)instance : [instance class];

        [self.initializer createInvocationWithContext:context completion:^(NSInvocation *invocation) {
            if (isClass && ![self.initializer isClassMethodOnClass:context.classUnderConstruction]) {
                instance = [invocation typhoon_resultOfInvokingOnAllocationForClass:context.classUnderConstruction];
            } else {
                instance = [invocation typhoon_resultOfInvokingOnInstance:instance];
            }
        }];

    }
    return instance;
}

- (void)doInjectionEventsOn:(id)instance withArgs:(TyphoonRuntimeArguments *)args factory:(TyphoonComponentFactory *)factory
{
    if (self.beforeInjections) {
        [self doMethodInjection:self.beforeInjections onInstance:instance args:args factory:factory];
    }
    
    for (id<TyphoonPropertyInjection> property in self.injectedProperties) {
        [self doPropertyInjectionOn:instance property:property args:args factory:factory];
    }
    
    for (TyphoonMethod *method in self.injectedMethods) {
        [self doMethodInjection:method onInstance:instance args:args factory:factory];
    }

    if (self.afterInjections) {
        [self doMethodInjection:self.afterInjections onInstance:instance args:args factory:factory];
    }
}

- (void)doAfterAllInjectionsOn:(id)instance
{
    if (self.afterAllInjections && [instance respondsToSelector:self.afterAllInjections]) {
        void(*afterInjectionsMethod)(id, SEL) = (void ( *)(id, SEL)) [instance methodForSelector:self.afterAllInjections];
        afterInjectionsMethod(instance, self.afterAllInjections);
    }
}

- (id)targetForInitializerWithFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)args
{
    return self.type;
}

#pragma mark - Method Injection

- (void)doMethodInjection:(TyphoonMethod *)method onInstance:(id)instance
                     args:(TyphoonRuntimeArguments *)args factory:(TyphoonComponentFactory *)factory
{
    if (instance == nil) {
        return;
    }
    
    TyphoonInjectionContext *context = [[TyphoonInjectionContext alloc] initWithFactory:factory args:args
        raiseExceptionIfCircular:NO];
    context.classUnderConstruction = [instance class];

    [method createInvocationWithContext:context completion:^(NSInvocation *invocation) {
        [invocation invokeWithTarget:instance];
    }];
}

#pragma mark - Property Injection

- (void)doPropertyInjectionOn:(id)instance property:(id<TyphoonPropertyInjection>)property
                         args:(TyphoonRuntimeArguments *)args factory:(TyphoonComponentFactory *)factory
{
    TyphoonInjectionContext *context = [[TyphoonInjectionContext alloc] initWithFactory:factory args:args
        raiseExceptionIfCircular:NO];
    context.destinationType = [instance typhoonTypeForPropertyNamed:property.propertyName];
    context.classUnderConstruction = [instance class];

    [property valueToInjectWithContext:context completion:^(id value) {
        [instance typhoon_injectValue:value forPropertyName:property.propertyName];
    }];
}

@end
