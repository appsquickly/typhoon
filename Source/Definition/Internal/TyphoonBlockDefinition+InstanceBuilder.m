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
#import "TyphoonLinkerCategoryBugFix.h"

TYPHOON_LINK_CATEGORY(TyphoonBlockDefinition_InstanceBuilder)

@implementation TyphoonBlockDefinition (InstanceBuilder)

#pragma mark - Instance Builder

- (id)initializeInstanceWithArgs:(TyphoonRuntimeArguments *)args factory:(TyphoonComponentFactory *)factory
{
    // TODO
    return nil;
}

- (void)doInjectionEventsOn:(id)instance withArgs:(TyphoonRuntimeArguments *)args factory:(TyphoonComponentFactory *)factory
{
    // TODO
}

@end
