////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "ComponentFactoryAwareAssembly.h"
#import <TyphoonDefinition.h>
#import "ComponentFactoryAwareObject.h"

@implementation ComponentFactoryAwareAssembly

- (id)injectionAwareObject;
{
    return [TyphoonDefinition withClass:[ComponentFactoryAwareObject class]];
}

@end
