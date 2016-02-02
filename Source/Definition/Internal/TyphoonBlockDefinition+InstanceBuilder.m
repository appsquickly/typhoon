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
#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonDefinition+Internal.h"
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
    if (self.initializerGenerated) {
        return [super initializeInstanceWithArgs:args factory:factory];
    } else {
        __block id instance;

        [[TyphoonBlockDefinitionController currentController] setRoute:TyphoonBlockDefinitionRouteInitializer instance:nil withinBlock:^{
            TyphoonInjectionContext *context = [[TyphoonInjectionContext alloc] initWithFactory:factory args:args
                                                                       raiseExceptionIfCircular:YES];
            
            instance = [self invokeAssemblySelectorWithContext:context];
        }];
        
        return instance;
    }
}

- (void)doInjectionEventsOn:(id)instance withArgs:(TyphoonRuntimeArguments *)args factory:(TyphoonComponentFactory *)factory
{
    [[TyphoonBlockDefinitionController currentController] setRoute:TyphoonBlockDefinitionRouteInjections instance:instance withinBlock:^{
        TyphoonInjectionContext *context = [[TyphoonInjectionContext alloc] initWithFactory:factory args:args
                                                                   raiseExceptionIfCircular:NO];
        
        [self invokeAssemblySelectorWithContext:context];
    }];
    
    [super doInjectionEventsOn:instance withArgs:args factory:factory];
}

#pragma mark - Invocation

- (id)invokeAssemblySelectorWithContext:(TyphoonInjectionContext *)context
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
