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


@implementation TyphoonParameterInjectedByReference

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (instancetype)initWithParameterIndex:(NSUInteger)index reference:(NSString*)reference
{
    self = [super init];
    if (self)
    {
        _index = index;
        _reference = reference;
    }
    return self;
}

/* ====================================================================================================================================== */
#pragma mark - Overridden Methods

- (TyphoonParameterInjectionType)type
{
    return TyphoonParameterInjectionTypeReference;
}



@end
