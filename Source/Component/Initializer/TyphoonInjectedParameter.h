////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 - 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import <Foundation/Foundation.h>
@class TyphoonInitializer;

typedef enum
{
    TyphoonParameterInjectedByReferenceType = 0,
    TyphoonParameterInjectedByValueType = 1,
    TyphoonParameterInjectedByRawValueType = 2,
    TyphoonParameterInjectedAtRuntimeType = 3
} TyphoonParameterInjectionType;

@protocol TyphoonInjectedParameter <NSObject>

- (NSUInteger)index;

- (TyphoonParameterInjectionType)type;

- (void)setInitializer:(TyphoonInitializer*)initializer;

@end