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


#import "TyphoonDefinitionBase+InstanceBuilder.h"
#import "TyphoonLinkerCategoryBugFix.h"

TYPHOON_LINK_CATEGORY(TyphoonDefinitionBase_InstanceBuilder)

@implementation TyphoonDefinitionBase (InstanceBuilder)

- (id)initializeInstanceWithArgs:(TyphoonRuntimeArguments *)args factory:(TyphoonComponentFactory *)factory
{
    [NSException raise:NSInternalInconsistencyException format:@"%@ is abstract", NSStringFromSelector(_cmd)];
    return nil;
}

- (void)doInjectionEventsOn:(id)instance withArgs:(TyphoonRuntimeArguments *)args factory:(TyphoonComponentFactory *)factory
{
    [NSException raise:NSInternalInconsistencyException format:@"%@ is abstract", NSStringFromSelector(_cmd)];
}

@end
