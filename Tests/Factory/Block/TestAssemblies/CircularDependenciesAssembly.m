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



#import "CircularDependenciesAssembly.h"
#import "TyphoonDefinition.h"
#import "TyphoonInitializer.h"

#import "PrototypeInitInjected.h"
#import "PrototypePropertyInjected.h"

#import "CROSingletonB.h"

@implementation CircularDependenciesAssembly


- (id)classA
{
    return [TyphoonDefinition withClass:[ClassADependsOnB class] properties:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(dependencyOnB) with:[self classB]];
    }];
}

- (id)classB
{
    return [TyphoonDefinition withClass:[ClassBDependsOnA class] properties:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(dependencyOnA) with:[self classA]];
    }];
}

- (id)classC;
{
    return [TyphoonDefinition withClass:[ClassCDependsOnDAndE class] properties:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(dependencyOnD) with:[self classD]];
        [definition injectProperty:@selector(dependencyOnE) with:[self classE]];
    }];
}

- (id)classD;
{
    return [TyphoonDefinition withClass:[ClassDDependsOnC class] properties:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(dependencyOnC) with:[self classC]];
    }];
}

- (id)classE;
{
    return [TyphoonDefinition withClass:[ClassEDependsOnC class] properties:^(TyphoonDefinition *definition) {
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
    return [TyphoonDefinition withClass:[PrototypeInitInjected class] initialization:^(TyphoonInitializer *initializer) {
        initializer.selector = @selector(initWithDependency:);
        [initializer injectParameterWith:[self prototypePropertyInjected]];
    } properties:^(TyphoonDefinition *definition) {
        [definition setScope:TyphoonScopePrototype];
    }];
}

- (id)prototypePropertyInjected
{
    return [TyphoonDefinition withClass:[PrototypePropertyInjected class] properties:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(prototypeInitInjected) with:[self prototypeInitInjected]];
        [definition setScope:TyphoonScopePrototype];
    }];
}

// Currently Resolving Overwrite

- (id)croSingletonA
{
    return [TyphoonDefinition withClass:[CROSingletonA class] properties:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(prototypeB) with:[self croPrototypeB]];
        [definition injectProperty:@selector(prototypeA) with:[self croPrototypeA]];
        [definition setScope:TyphoonScopeSingleton];
    }];
}

- (id)croSingletonB
{
    return [TyphoonDefinition withClass:[CROSingletonB class] initialization:^(TyphoonInitializer *initializer) {
        initializer.selector = @selector(initWithPrototypeB:);
        [initializer injectParameterWith:[self croPrototypeB]];
    }];
}

- (id)croPrototypeA
{
    return [TyphoonDefinition withClass:[CROPrototypeA class] initialization:^(TyphoonInitializer *initializer) {
        initializer.selector = @selector(initWithCROPrototypeB:);
        [initializer injectParameterWith:[self croPrototypeB]];
    }];
}

- (id)croPrototypeB
{
    return [TyphoonDefinition withClass:[CROPrototypeB class] initialization:^(TyphoonInitializer *initializer) {
        initializer.selector = @selector(initWithCROSingletonA:);
        [initializer injectParameterWith:[self croSingletonA]];
    }];
}

// Incorrect circular dependency

- (id)incorrectPrototypeB
{
    return [TyphoonDefinition withClass:[CROPrototypeB class] initialization:^(TyphoonInitializer *initializer) {
        initializer.selector = @selector(initWithCROPrototypeA:);
        [initializer injectParameterWith:[self incorrectPrototypeA]];
    } properties:^(TyphoonDefinition *definition) {
        definition.key = @"incorrectPrototypeB";
        definition.scope = TyphoonScopePrototype;
    }];
}

- (id)incorrectPrototypeA
{
    return [TyphoonDefinition withClass:[CROPrototypeA class] initialization:^(TyphoonInitializer *initializer) {
        initializer.selector = @selector(initWithCROPrototypeB:);
        [initializer injectParameterWith:[self incorrectPrototypeB]];
    } properties:^(TyphoonDefinition *definition) {
        definition.key = @"incorrectPrototypeA";
        definition.scope = TyphoonScopePrototype;
    }];
}

@end