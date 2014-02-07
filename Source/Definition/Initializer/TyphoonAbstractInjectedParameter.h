////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2014 ibipit
//  All Rights Reserved.
//
//  NOTICE: This software is the proprietary information of ibipit
//  Use is subject to license terms.
//
////////////////////////////////////////////////////////////////////////////////


#import <Foundation/Foundation.h>

@class TyphoonInitializer;
@class TyphoonComponentFactory;

typedef enum
{
    TyphoonParameterInjectionTypeReference,
    TyphoonParameterInjectionTypeStringRepresentation,
    TyphoonParameterInjectionTypeObjectInstance,
    TyphoonParameterInjectionTypeAsCollection
} TyphoonParameterInjectionType;

@interface TyphoonAbstractInjectedParameter : NSObject
{
    NSUInteger _index;
    __unsafe_unretained TyphoonInitializer* _initializer;
}

@property(nonatomic, readonly) NSUInteger index;
@property (nonatomic, unsafe_unretained) TyphoonInitializer* initializer;


- (TyphoonParameterInjectionType)type;


- (void)withFactory:(TyphoonComponentFactory*)factory setArgumentOnInvocation:(NSInvocation*)invocation;

@end