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



#import "TyphoonParameterInjectedByReference.h"
#import "TyphoonInitializer.h"


@implementation TyphoonParameterInjectedByReference

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)initWithParameterIndex:(NSUInteger)parameterIndex reference:(NSString*)reference
{
    return [self initWithParameterIndex:parameterIndex reference:reference fromCollaboratingAssemblyProxy:NO];
}

- (instancetype)initWithParameterIndex:(NSUInteger)index reference:(NSString *)reference fromCollaboratingAssemblyProxy:(BOOL)fromCollaboratingAssemblyProxy {
    self = [super initWithReference:reference fromCollaboratingAssemblyProxy:fromCollaboratingAssemblyProxy];
    if (self)
    {
        _index = index;
    }

    return self;
}

/* ====================================================================================================================================== */
#pragma mark - Protocol Methods

- (TyphoonParameterInjectionType)type
{
    return TyphoonParameterInjectionTypeReference;
}

- (void)setInitializer:(TyphoonInitializer*)initializer
{
    //Do nothing.
}

@end
