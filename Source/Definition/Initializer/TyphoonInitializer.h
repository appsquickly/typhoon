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
@class TyphoonParameterInjectedAsCollection;

typedef enum
{
    TyphoonComponentInitializerIsClassMethodGuess,
    TyphoonComponentInitializerIsClassMethodYes,
    TyphoonComponentInitializerIsClassMethodNo
} TyphoonComponentInitializerIsClassMethod;

/**
* @ingroup Definition
*
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

- (id)initWithSelector:(SEL)initializer isClassMethodStrategy:(TyphoonComponentInitializerIsClassMethod)isClassMethod;

- (void)injectParameterNamed:(NSString*)name withReference:(NSString*)reference;

- (void)injectParameterAtIndex:(NSUInteger)index withReference:(NSString*)reference;

- (void)injectParameterNamed:(NSString*)name withValueAsText:(NSString*)text requiredTypeOrNil:(id)classOrProtocol;

- (void)injectParameterAtIndex:(NSUInteger)index withValueAsText:(NSString*)text requiredTypeOrNil:(id)requiredClass;

- (void)injectParameterAtIndex:(NSUInteger)index withObject:(id)value;

- (void)injectParameterNamed:(NSString*)name withObject:(id)value;


/* ====================================================================================================================================== */
#pragma mark - Block assembly

- (void)injectWithDefinition:(TyphoonDefinition*)definition;

- (void)injectWithValueAsText:(NSString*)text;

- (void)injectWithValueAsText:(NSString*)text requiredTypeOrNil:(id)requiredTypeOrNil;

- (void)injectWithObject:(id)value;

- (void)injectWithCollection:(void (^)(TyphoonParameterInjectedAsCollection*))collectionValues requiredType:(id)requiredType;

- (void)injectParameterNamed:(NSString*)name withDefinition:(TyphoonDefinition*)definition;

- (void)injectParameterAtIndex:(NSUInteger)index1 withDefinition:(TyphoonDefinition*)definition;

- (void)injectParameterAtIndex:(NSUInteger)index
        asCollection:(void (^)(TyphoonParameterInjectedAsCollection*))collectionValues
        requiredType:(id)requiredType;

- (void)injectParameterNamed:(NSString*)name
        asCollection:(void (^)(TyphoonParameterInjectedAsCollection*))collectionValues
        requiredType:(id)requiredType;


@end
