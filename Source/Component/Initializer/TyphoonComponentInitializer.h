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
@class TyphoonComponentDefinition;

typedef enum
{
    TyphoonComponentInitializerIsClassMethodGuess,
    TyphoonComponentInitializerIsClassMethodYes,
    TyphoonComponentInitializerIsClassMethodNo
} TyphoonComponentInitializerIsClassMethod;

@interface TyphoonComponentInitializer : NSObject
{
    NSMutableArray* _injectedParameters;
    NSArray* _parameterNames;
    __unsafe_unretained TyphoonComponentDefinition* _definition;
    TyphoonComponentInitializerIsClassMethod _isClassMethodStrategy;
}

@property(nonatomic) SEL selector;
@property(nonatomic) BOOL isClassMethod;

- (id)initWithSelector:(SEL)initializer;

- (id)initWithSelector:(SEL)initializer isClassMethod:(TyphoonComponentInitializerIsClassMethod)isClassMethod;

- (void)injectParameterNamed:(NSString*)name withDefinition:(TyphoonComponentDefinition*)definition;

- (void)injectParameterNamed:(NSString*)name withReference:(NSString*)reference;

- (void)injectParameterAtIndex:(NSUInteger)index withDefinition:(TyphoonComponentDefinition*)definition;

- (void)injectParameterAtIndex:(NSUInteger)index withReference:(NSString*)reference;

- (void)injectParameterNamed:(NSString*)name withValueAsText:(NSString*)text requiredTypeOrNil:(id)classOrProtocol;

- (void)injectParameterAt:(NSUInteger)index withValueAsText:(NSString*)text requiredTypeOrNil:(id)classOrProtocol;

- (NSArray*)injectedParameters;

- (NSInvocation*)asInvocationFor:(id)classOrInstance;

- (void)setComponentDefinition:(TyphoonComponentDefinition*)definition;

@end