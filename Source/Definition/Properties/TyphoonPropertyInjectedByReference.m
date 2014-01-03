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
    return [self initWithName:name reference:reference fromCollaboratingAssemblyProxy:NO];
}

- (instancetype)initWithName:(NSString *)name reference:(NSString *)reference fromCollaboratingAssemblyProxy:(BOOL)fromCollaboratingAssemblyProxy {
    self = [super initWithReference:reference fromCollaboratingAssemblyProxy:fromCollaboratingAssemblyProxy];
    if (self)
    {
        _name = name;
    }

    return self;
}

/* ====================================================================================================================================== */
#pragma mark - Protocol Methods

- (TyphoonPropertyInjectionType)injectionType
{
    return TyphoonPropertyInjectionTypeByReference;
}


@end
