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
@class TyphoonDefinition;

typedef enum
{
    TyphoonComponentInitializerIsClassMethodGuess,
    TyphoonComponentInitializerIsClassMethodYes,
    TyphoonComponentInitializerIsClassMethodNo
} TyphoonComponentInitializerIsClassMethod;

/**
* Represents an initializer for a component.
*/
@interface TyphoonInitializer : NSObject
{
    NSMutableArray* _injectedParameters;
    NSArray* _parameterNames;
    __unsafe_unretained TyphoonDefinition* _definition;
    TyphoonComponentInitializerIsClassMethod _isClassMethodStrategy;
    SEL _selector;
}

@property(nonatomic) SEL selector;

- (id)initWithSelector:(SEL)initializer;

- (id)initWithSelector:(SEL)initializer isClassMethod:(TyphoonComponentInitializerIsClassMethod)isClassMethod;

- (void)injectParameterNamed:(NSString*)name withReference:(NSString*)reference;

- (void)injectParameterAtIndex:(NSUInteger)index withReference:(NSString*)reference;

- (void)injectParameterNamed:(NSString*)name withValueAsText:(NSString*)text requiredTypeOrNil:(id)classOrProtocol;

- (void)injectParameterAtIndex:(NSUInteger)index withValueAsText:(NSString*)text requiredTypeOrNil:(id)requiredClass;


/* ====================================================================================================================================== */
#pragma mark - Block assembly

- (void)injectWithDefinition:(TyphoonDefinition*)definition;

- (void)injectWithText:(NSString*)text;

- (void)injectWithText:(NSString*)text requiredTypeOrNil:(id)requiredTypeOrNil;

- (void)injectParameterNamed:(NSString*)name withDefinition:(TyphoonDefinition*)definition;

- (void)injectParameterAtIndex:(NSUInteger)index1 withDefinition:(TyphoonDefinition*)definition;

- (void)injectParameterAtIndex:(NSUInteger)index withValue:(id)value;

- (void)injectParameterNamed:(NSString*)name withValue:(id)value;

- (void)injectParameterWithValue:(id)value;
@end