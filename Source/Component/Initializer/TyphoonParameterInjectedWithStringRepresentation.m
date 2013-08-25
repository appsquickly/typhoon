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


#import <objc/runtime.h>
#import "TyphoonParameterInjectedWithStringRepresentation.h"
#import "TyphoonInitializer.h"
#import "TyphoonTypeDescriptor.h"
#import "TyphoonIntrospectionUtils.h"


@implementation TyphoonParameterInjectedWithStringRepresentation



@synthesize textValue = _textValue;

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)initWithIndex:(NSUInteger)index value:(NSString*)value requiredTypeOrNil:(Class)requiredTypeOrNil
{
    self = [super init];
    if (self)
    {
        _index = index;
        _textValue = value;
        _requiredType = requiredTypeOrNil;
    }
    return self;
}

/* ====================================================================================================================================== */
#pragma mark - Interface Methods

- (TyphoonTypeDescriptor*)resolveTypeWith:(id)classOrInstance
{
    if (_requiredType)
    {
        return [TyphoonTypeDescriptor descriptorWithClassOrProtocol:_requiredType];
    }
    else
    {
        BOOL isClass = class_isMetaClass(object_getClass(classOrInstance));
        Class clazz;
        if (isClass)
        {
            clazz = classOrInstance;
        }
        else
        {
            clazz = [classOrInstance class];
        }
        NSArray* typeCodes = [TyphoonIntrospectionUtils typeCodesForSelector:_initializer.selector ofClass:clazz isClassMethod:isClass];

        if ([[typeCodes objectAtIndex:_index] isEqualToString:@"@"])
        {
            [NSException raise:NSInvalidArgumentException
                    format:@"Unless the type is primitive (int, BOOL, etc), initializer injection requires the required class to be specified. Eg: <argument parameterName=\"string\" value=\"http://dev.foobar.com/service/\" required-class=\"NSString\" />"];
        }
        return [TyphoonTypeDescriptor descriptorWithTypeCode:[typeCodes objectAtIndex:_index]];
    }
}


/* ====================================================================================================================================== */
#pragma mark - Protocol Methods

- (TyphoonParameterInjectionType)type
{
    return TyphoonParameterInjectionTypeStringRepresentation;
}

- (void)setInitializer:(TyphoonInitializer*)initializer
{
    _initializer = initializer;
}


@end