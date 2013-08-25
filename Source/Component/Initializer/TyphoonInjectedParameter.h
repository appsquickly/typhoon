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



#import <Foundation/Foundation.h>
@class TyphoonInitializer;

typedef enum
{
    TyphoonParameterInjectionTypeReference,
    TyphoonParameterInjectionTypeStringRepresentation,
    TyphoonParameterInjectionTypeObjectInstance
} TyphoonParameterInjectionType;

@protocol TyphoonInjectedParameter <NSObject>

- (NSUInteger)index;

- (TyphoonParameterInjectionType)type;

- (void)setInitializer:(TyphoonInitializer*)initializer;

@end