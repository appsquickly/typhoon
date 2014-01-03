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
    self = [super init];
    if (self)
    {
        _index = parameterIndex;
        _reference = reference;
    }
    return self;
}

- (instancetype)initWithParameterIndex:(NSUInteger)index reference:(NSString *)reference fromCollaboratingAssemblyProxy:(BOOL)fromCollaboratingAssemblyProxy {
    self = [super init];
    if (self)
    {
        _index = index;
        _reference = reference;
        _fromCollaboratingAssemblyProxy = fromCollaboratingAssemblyProxy;
    }

    return self;
}

+ (instancetype)referenceWithIndex:(NSUInteger)index reference:(NSString *)reference fromCollaboratingAssemblyProxy:(BOOL)fromCollaboratingAssemblyProxy {
    return [[self alloc] initWithParameterIndex:index reference:reference fromCollaboratingAssemblyProxy:fromCollaboratingAssemblyProxy];
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
