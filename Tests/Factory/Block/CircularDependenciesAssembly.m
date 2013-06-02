////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import "CircularDependenciesAssembly.h"
#import "TyphoonDefinition.h"
#import "ClassADependsOnB.h"
#import "ClassBDependsOnA.h"


@implementation CircularDependenciesAssembly


- (id)classA
{
    return [TyphoonDefinition withClass:[ClassADependsOnB class] properties:^(TyphoonDefinition* definition)
    {
        [definition injectProperty:@selector(dependencyOnB) withDefinition:[self classB]];
    }];
}

- (id)classB
{
    return [TyphoonDefinition withClass:[ClassBDependsOnA class] properties:^(TyphoonDefinition* definition)
    {
        [definition injectProperty:@selector(dependencyOnA) withDefinition:[self classA]];
    }];
}

@end