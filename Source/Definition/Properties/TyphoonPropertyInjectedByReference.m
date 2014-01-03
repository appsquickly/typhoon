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




#import "TyphoonPropertyInjectedByReference.h"


@implementation TyphoonPropertyInjectedByReference
{

}

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)initWithName:(NSString*)name reference:(NSString*)reference
{
    self = [super init];
    if (self)
    {
        _name = name;
        _reference = reference;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name reference:(NSString *)reference fromCollaboratingAssemblyProxy:(BOOL)fromCollaboratingAssemblyProxy {
    self = [super init];
    if (self)
    {
        _name = name;
        _reference = reference;
        _fromCollaboratingAssemblyProxy = fromCollaboratingAssemblyProxy;
    }

    return self;
}

+ (instancetype)referenceWithName:(NSString *)name reference:(NSString *)reference fromCollaboratingAssemblyProxy:(BOOL)fromCollaboratingAssemblyProxy {
    return [[self alloc] initWithName:name reference:reference fromCollaboratingAssemblyProxy:fromCollaboratingAssemblyProxy];
}


/* ====================================================================================================================================== */
#pragma mark - Protocol Methods

- (TyphoonPropertyInjectionType)injectionType
{
    return TyphoonPropertyInjectionTypeByReference;
}


@end
