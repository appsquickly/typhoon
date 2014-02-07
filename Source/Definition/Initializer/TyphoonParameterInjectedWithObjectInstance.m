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

#import "TyphoonParameterInjectedWithObjectInstance.h"
#import "TyphoonInitializer.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonInitializer+InstanceBuilder.h"
#import "TyphoonDefinition.h"

@implementation TyphoonParameterInjectedWithObjectInstance

- (id)initWithParameterIndex:(NSUInteger)index value:(id)value
{
    self = [super init];
    if (self)
    {
        _index = index;
        _value = value;
    }
    return self;
}

- (TyphoonParameterInjectionType)type
{
    return TyphoonParameterInjectionTypeObjectInstance;
}

- (void)setInitializer:(TyphoonInitializer*)initializer
{
    _initializer = initializer;
}

/* ====================================================================================================================================== */
#pragma mark - Interface Methods

- (BOOL)isPrimitiveParameter
{
    BOOL isClass = [_initializer isClassMethod];
    Class class = [_initializer.definition type];

    NSArray* typeCodes = [TyphoonIntrospectionUtils typeCodesForSelector:_initializer.selector ofClass:class isClassMethod:isClass];

    return ![[typeCodes objectAtIndex:_index] isEqualToString:@"@"];
}

@end
