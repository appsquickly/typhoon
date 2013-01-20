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
@class TyphoonComponentInitializer;

typedef enum
{
    TyphoonParameterInjectedByReferenceType,
    TyphoonParameterInjectedByValueType
} TyphoonParameterInjectionType;

@protocol TyphoonInjectedParameter <NSObject>

- (NSUInteger)index;

- (TyphoonParameterInjectionType)type;

- (void)setInitializer:(TyphoonComponentInitializer*)initializer;

@end