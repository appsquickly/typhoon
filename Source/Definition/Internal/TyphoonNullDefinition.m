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

#import "TyphoonNullDefinition.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonDefinition+Infrastructure.h"
#import "TyphoonDefinition+InstanceBuilder.h"

@implementation TyphoonNullDefinition

- (id)targetForInitializerWithFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)args
{
    return nil;
}

- (BOOL)isCandidateForInjectedClass:(Class)clazz includeSubclasses:(BOOL)includeSubclasses
{
    return NO;
}

- (BOOL)isCandidateForInjectedProtocol:(Protocol *)aProtocol
{
    return NO;
}
@end