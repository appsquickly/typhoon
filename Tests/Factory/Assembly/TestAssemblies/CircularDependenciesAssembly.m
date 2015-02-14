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



#import "CircularDependenciesAssembly.h"
#import "TyphoonDefinition.h"
#import "TyphoonMethod.h"
#import "TyphoonDefinition+Infrastructure.h"

#import "PrototypeInitInjected.h"
#import "PrototypePropertyInjected.h"

#import "CROSingletonB.h"

@implementation CircularDependenciesAssembly


- (id)classA
{
    return [TyphoonDefinition withClass:[ClassADependsOnB class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(setDependencyOnB:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self classB]];
        }];
    }];
}

- (id)classB
{
    return [TyphoonDefinition withClass:[ClassBDependsOnA class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(setDependencyOnA:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self classA]];
        }];
    }];
}

- (id)classC;
{
    return [TyphoonDefinition withClass:[ClassCDependsOnDAndE class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(dependencyOnD) with:[self classD]];
        [definition injectProperty:@selector(dependencyOnE) with:[self classE]];
    }];
}

- (id)classD;
{
    return [TyphoonDefinition withClass:[ClassDDependsOnC class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(dependencyOnC) with:[self classC]];
    }];
}

- (id)classE;
{
    return [TyphoonDefinition withClass:[ClassEDependsOnC class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(dependencyOnC) with:[self classC]];
    }];
}

//- (id)unsatisfiableClassFWithCircularDependencyInInitializer;
//{
//    return [TyphoonDefinition withClass:[UnsatisfiableClassFDependsOnGInInitializer class] initialization:^(TyphoonInitializer *initializer) {
//        initializer.selector = @selector(initWithG:);
//
//        [initializer injectWithDefinition:[self unsatisfiableClassGWithCircularDependencyInInitializer]];
//    }];
//}
//
//- (id)unsatisfiableClassGWithCircularDependencyInInitializer;
//{
//    return [TyphoonDefinition withClass:[UnsatisfiableClassGDependsOnFInInitializer class] initialization:^(TyphoonInitializer *initializer) {
//        initializer.selector = @selector(initWithF:);
//
//        [initializer injectWithDefinition:[self unsatisfiableClassFWithCircularDependencyInInitializer]];
//    }];
//}


- (id)prototypeInitInjected
{
    return [TyphoonDefinition withClass:[PrototypeInitInjected class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithDependency:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[self prototypePropertyInjected]];
        }];
        [definition setScope:TyphoonScopePrototype];
    }];
}

- (id)prototypePropertyInjected
{
    return [TyphoonDefinition withClass:[PrototypePropertyInjected class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(prototypeInitInjected) with:[self prototypeInitInjected]];
        [definition setScope:TyphoonScopePrototype];
    }];
}

// Currently Resolving Overwrite

- (id)croSingletonA
{
    return [TyphoonDefinition withClass:[CROSingletonA class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(prototypeB) with:[self croPrototypeB]];
        [definition injectProperty:@selector(prototypeA) with:[self croPrototypeA]];
        [definition setScope:TyphoonScopeSingleton];
    }];
}

- (id)croSingletonB
{
    return [TyphoonDefinition withClass:[CROSingletonB class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithPrototypeB:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[self croPrototypeB]];
        }];
    }];
}

- (id)croPrototypeA
{
    return [TyphoonDefinition withClass:[CROPrototypeA class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithCROPrototypeB:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[self croPrototypeB]];
        }];
    }];
}

- (id)croPrototypeB
{
    return [TyphoonDefinition withClass:[CROPrototypeB class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithCROSingletonA:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[self croSingletonA]];
        }];
    }];
}

// Incorrect circular dependency

- (id)incorrectPrototypeB
{
    return [TyphoonDefinition withClass:[CROPrototypeB class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithCROPrototypeA:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[self incorrectPrototypeA]];
        }];
        definition.key = @"incorrectPrototypeB";
        definition.scope = TyphoonScopePrototype;
    }];
}

- (id)incorrectPrototypeA
{
    return [TyphoonDefinition withClass:[CROPrototypeA class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithCROPrototypeB:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[self incorrectPrototypeB]];
        }];
        definition.key = @"incorrectPrototypeA";
        definition.scope = TyphoonScopePrototype;
    }];
}

@end