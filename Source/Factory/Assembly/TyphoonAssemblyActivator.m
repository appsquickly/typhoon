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
#import "TyphoonBlockComponentFactory.h"

@interface TyphoonAssembly (Activation)

- (void)activateWithFactory:(TyphoonComponentFactory *)factory collaborators:(NSSet *)collaborators;

@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
@implementation TyphoonAssemblyActivator {
    NSArray *_assemblies;
};
#pragma clang diagnostic pop

//-------------------------------------------------------------------------------------------
#pragma mark - Class Methods
//-------------------------------------------------------------------------------------------

+ (instancetype)withAssemblies:(NSArray *)assemblies {
    return [[self alloc] initWithAssemblies:assemblies];
}

+ (instancetype)withAssembly:(TyphoonAssembly *)assembly {
    return [self withAssemblies:@[assembly]];
}

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

- (instancetype)initWithAssemblies:(NSArray *)assemblies {
    self = [super init];
    if (self) {
        _assemblies = assemblies;
    }
    return self;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (void)activate {
    TyphoonBlockComponentFactory *factory = [[TyphoonBlockComponentFactory alloc] initWithAssemblies:_assemblies];
    for (TyphoonAssembly *assembly in _assemblies) {
        [assembly activateWithFactory:factory collaborators:[NSSet setWithArray:_assemblies]];
    }
}


@end
