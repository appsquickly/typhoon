////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2016, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "TyphoonBlockDefinition+InstanceBuilder.h"
#import "TyphoonBlockDefinition+Internal.h"
#import "TyphoonDefinition+Internal.h"
#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonDefinition+Infrastructure.h"
#import "TyphoonRuntimeArguments.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonBlockDefinitionController.h"
#import "TyphoonInjection.h"
#import "NSInvocation+TCFUnwrapValues.h"
#import "TyphoonLinkerCategoryBugFix.h"

TYPHOON_LINK_CATEGORY(TyphoonBlockDefinition_InstanceBuilder)

@implementation TyphoonBlockDefinition (InstanceBuilder)

#pragma mark - Instance Builder

- (id)initializeInstanceWithArgs:(TyphoonRuntimeArguments *)args factory:(TyphoonComponentFactory *)factory
{
    if (self.hasInitializerBlock) {
        TyphoonInjectionContext *context = [[TyphoonInjectionContext alloc] initWithFactory:factory args:args
                                                                   raiseExceptionIfCircular:YES];
        context.classUnderConstruction = self.type;
        
        __block id instance;
        
        [[TyphoonBlockDefinitionController currentController] useInitializerRouteWithDefinition:self injectionContext:context withinBlock:^{
            instance = [self invokeAssemblySelector];
        }];
        
        return instance;
    }
    else {
        return [super initializeInstanceWithArgs:args factory:factory];
    }
}

- (void)doInjectionEventsOn:(id)instance withArgs:(TyphoonRuntimeArguments *)args factory:(TyphoonComponentFactory *)factory
{
    if (self.hasInjectionsBlock) {
        TyphoonInjectionContext *context = [[TyphoonInjectionContext alloc] initWithFactory:factory args:args
                                                                   raiseExceptionIfCircular:NO];
        context.classUnderConstruction = self.type;
    
        [[TyphoonBlockDefinitionController currentController] useInjectionsRouteWithDefinition:self instance:instance injectionContext:context withinBlock:^{
            [self invokeAssemblySelector];
        }];
    }
    
    [super doInjectionEventsOn:instance withArgs:args factory:factory];
}

#pragma mark - Invocation

- (id)invokeAssemblySelector
{
    id target = self.assembly;
    SEL selector = self.assemblySelector;
    
    if (!target || !selector) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"Assembly & assemblySelector should be set on TyphoonBlockDefinition in order to build an instance."];
    }
    
    NSMethodSignature *signature = [target methodSignatureForSelector:selector];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:target];
    [invocation setSelector:selector];
    [invocation retainArguments];
    
    TyphoonInjectionContext *context = [TyphoonBlockDefinitionController currentController].injectionContext;
    
    [context.args enumerateArgumentsUsingBlock:^(id<TyphoonInjection> argument, NSUInteger index, BOOL *stop) {
        [argument valueToInjectWithContext:context completion:^(id value) {
            [invocation typhoon_setArgumentObject:value atIndex:(NSInteger)index + 2];
        }];
    }];
    
    // Don't use [NSInvocation typhoon_resultOfInvokingOnInstance] here for performance reasons.
    // We're invoking a definition selector on assembly so there's no need to check for memory management stuff.
    [invocation invoke];
    
    void *unsafeResult;
    [invocation getReturnValue:&unsafeResult];
    id result = (__bridge id)unsafeResult;

    return result;
}

@end
