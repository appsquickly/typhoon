////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2014, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "TyphoonCollaboratingAssemblyProxy.h"
#import <objc/runtime.h>
#import "TyphoonDefinition+Infrastructure.h"
#import "TyphoonAssemblySelectorAdviser.h"
#import "TyphoonReferenceDefinition.h"
#import "TyphoonObjectWithCustomInjection.h"
#import "TyphoonInjectionByComponentFactory.h"
#import "TyphoonRuntimeArguments.h"
#import "TyphoonIntrospectionUtils.h"

@interface TyphoonCollaboratingAssemblyProxy () <TyphoonObjectWithCustomInjection>

@end

@implementation TyphoonCollaboratingAssemblyProxy

+ (id)proxy
{
    static dispatch_once_t onceToken;
    static TyphoonCollaboratingAssemblyProxy *instance;

    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    TyphoonRuntimeArguments *args = [TyphoonRuntimeArguments argumentsFromInvocation:anInvocation];

    //Since we're resolving a reference to another component, all we need to provide here is the definition's key and runtime args.
    TyphoonDefinition *definition = [TyphoonReferenceDefinition definitionReferringToComponent:[TyphoonAssemblySelectorAdviser keyForSEL:anInvocation.selector]];
    definition.currentRuntimeArguments = args;

    [anInvocation retainArguments];
    [anInvocation setReturnValue:&definition];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    return [TyphoonIntrospectionUtils methodSignatureWithArgumentsAndReturnValueAsObjectsFromSelector:selector];
}

/* ====================================================================================================================================== */
#pragma mark - <TyphoonObjectWithCustomInjection>

- (id <TyphoonPropertyInjection, TyphoonParameterInjection>)typhoonCustomObjectInjection
{
    return [[TyphoonInjectionByComponentFactory alloc] init];
}

@end