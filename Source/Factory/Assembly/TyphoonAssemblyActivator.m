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


#import "TyphoonAssemblyActivator.h"
#import "TyphoonAssembly.h"
#import "TyphoonInstrumentedAssemblyComponentFactory.h"

@interface TyphoonAssembly (Activation)

- (void)activateWithFactory:(TyphoonComponentFactory *)factory;

@end


@implementation TyphoonAssemblyActivator
{
    NSArray *_assemblies;
};

//-------------------------------------------------------------------------------------------
#pragma mark - Class Methods
//-------------------------------------------------------------------------------------------

+ (instancetype)activatorWithAssemblies:(NSArray *)assemblies
{
    return [[self alloc] initWithAssemblies:assemblies];
}

+ (instancetype)activatorWithAssembly:(TyphoonAssembly *)assembly
{
    return [self activatorWithAssemblies:@[assembly]];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

- (instancetype)initWithAssemblies:(NSArray *)assemblies
{
    self = [super init];
    if (self) {
        _assemblies = assemblies;
    }
    return self;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (void)activate
{
    TyphoonInstrumentedAssemblyComponentFactory *factory = [[TyphoonInstrumentedAssemblyComponentFactory alloc] initWithAssemblies:_assemblies];
    for (TyphoonAssembly *assembly in _assemblies) {
        [assembly activateWithFactory:factory];
    }
}


@end