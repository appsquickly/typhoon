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
#import "TyphoonRuntimeArguments.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonBlockDefinitionController.h"
#import "NSInvocation+TCFUnwrapValues.h"
#import "TyphoonLinkerCategoryBugFix.h"

TYPHOON_LINK_CATEGORY(TyphoonBlockDefinition_InstanceBuilder)

@implementation TyphoonBlockDefinition (InstanceBuilder)

#pragma mark - Instance Builder

- (id)initializeInstanceWithArgs:(TyphoonRuntimeArguments *)args factory:(TyphoonComponentFactory *)factory
{
    [TyphoonBlockDefinitionController currentController].route = TyphoonBlockDefinitionRouteInitializer;

    return [self invokeTargetSelectorWithArgs:args];
}

- (void)doInjectionEventsOn:(id)instance withArgs:(TyphoonRuntimeArguments *)args factory:(TyphoonComponentFactory *)factory
{
    [TyphoonBlockDefinitionController currentController].route = TyphoonBlockDefinitionRouteInjections;
    
    [self invokeTargetSelectorWithArgs:args];
}

#pragma mark - Invocation

- (id)invokeTargetSelectorWithArgs:(TyphoonRuntimeArguments *)args {
    if (!self.target || !self.selector) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"Target & selector should be set on TyphoonBlockDefinition in order to build an instance."];
    }
    
    NSMethodSignature *signature = [self.target methodSignatureForSelector:self.selector];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self.target];
    [invocation setSelector:self.selector];
    [args enumerateArgumentsUsingBlock:^(id argument, NSUInteger index, BOOL *stop) {
        [invocation typhoon_setArgumentObject:argument atIndex:(NSInteger)index];
    }];
    [invocation retainArguments];
    
    // Don't use [NSInvocation typhoon_resultOfInvokingOnInstance] here for performance reasons.
    // We're invoking a definition selector on assembly so there's no need to check for memory management stuff.
    [invocation invoke];
    
    id __unsafe_unretained unsafeResult;
    [invocation getReturnValue:&unsafeResult];
    id result = unsafeResult;

    return result;
}

@end
