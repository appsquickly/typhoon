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
#import <objc/runtime.h>

@implementation TyphoonParameterInjectedWithObjectInstance {
    __weak TyphoonInitializer* _initializer;
}

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

- (BOOL) isPrimitiveParameterFor:(id)classOrInstance
{
    BOOL isClass = class_isMetaClass(object_getClass(classOrInstance));
    
    Class class = isClass ? classOrInstance : [classOrInstance class];
    
    NSArray* typeCodes = [TyphoonIntrospectionUtils typeCodesForSelector:_initializer.selector ofClass:class isClassMethod:isClass];
    
    return ![[typeCodes objectAtIndex:_index] isEqualToString:@"@"];
}

@end
