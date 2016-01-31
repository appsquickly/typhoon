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
    __block id instance;
    
    [[TyphoonBlockDefinitionController currentController] setRoute:TyphoonBlockDefinitionRouteInitializer instance:nil withinBlock:^{
        instance = [self invokeTargetSelectorWithArgs:args];
    }];
    
    return instance;
}

- (void)doInjectionEventsOn:(id)instance withArgs:(TyphoonRuntimeArguments *)args factory:(TyphoonComponentFactory *)factory
{
    [[TyphoonBlockDefinitionController currentController] setRoute:TyphoonBlockDefinitionRouteInjections instance:instance withinBlock:^{
        [self invokeTargetSelectorWithArgs:args];
    }];
    
    [super doInjectionEventsOn:instance withArgs:args factory:factory];
}

#pragma mark - Invocation

- (id)invokeTargetSelectorWithArgs:(TyphoonRuntimeArguments *)args {
    if (!self.blockTarget || !self.blockSelector) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"Target & selector should be set on TyphoonBlockDefinition in order to build an instance."];
    }
    
    NSMethodSignature *signature = [self.blockTarget methodSignatureForSelector:self.blockSelector];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self.blockTarget];
    [invocation setSelector:self.blockSelector];
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
