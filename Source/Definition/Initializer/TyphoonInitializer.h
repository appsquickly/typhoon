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
@protocol TyphoonLogger;

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

/**
* The selector used to initialize the component.
*/
@property(nonatomic) SEL selector;

@property(nonatomic, strong) id <TyphoonLogger> logger;

- (id)initWithSelector:(SEL)initializer;

- (id)initWithSelector:(SEL)initializer isClassMethodStrategy:(TyphoonComponentInitializerIsClassMethod)isClassMethod;

/* ====================================================================================================================================== */
#pragma mark - inject
/**
* Injects with the given definition.
*/
- (void)injectWithDefinition:(TyphoonDefinition*)definition;

/**
* Injects with the value represented by the given text. The text will be used to create an instance of a class matching the
* required type.
*
* @see TyphoonTypeConverterRegistry for details on declaring your own type converters.
*/
- (void)injectWithValueAsText:(NSString*)text;

/**
* Injects with the value represented by the given text. The text will be used to create an instance of the given requiredType.
*/
- (void)injectWithValueAsText:(NSString*)text requiredTypeOrNil:(id)requiredTypeOrNil;

/**
* Injects with an object instance.
*/
- (void)injectWithObject:(id)value;

/**
* Injects with a collection of the given type.
*/
- (void)injectWithCollection:(void (^)(TyphoonParameterInjectedAsCollection*))collectionValues requiredType:(id)requiredType;

/**
* Injects with an int.
*/
- (void)injectWithInt:(int)intValue;

/**
 * Injects with an unsigned int.
 */
- (void)injectWithUnsignedInt:(unsigned int)unsignedIntValue;

/**
 * Injects with a short.
 */
- (void)injectWithShort:(short)shortValue;

/**
* Injects with an unsigned short.
*/
- (void)injectWithUnsignedShort:(unsigned short)unsignedShortValue;

/**
* Injects with a long.
*/
- (void)injectWithLong:(long)longValue;

/**
 * Injects with an unsigned long.
 */
- (void)injectWithUnsignedLong:(unsigned long)unsignedLongValue;

/**
* Injects with a long long.
*/
- (void)injectWithLongLong:(long long)longLongValue;

/**
 * Injects with an unsigned long long.
 */
- (void)injectWithUnsignedLongLong:(unsigned long long)unsignedLongLongValue;

/**
* Injects with an unsigned char.
*/
- (void)injectWithUnsignedChar:(unsigned char)unsignedCharValue;

/**
* Injects with a float.
*/
- (void)injectWithFloat:(float)floatValue;

/**
* Injects with a double.
*/
- (void)injectWithDouble:(double)doubleValue;

/**
* Injects with a boolean.
*/
- (void)injectWithBool:(BOOL)boolValue;

/**
 * Injects with an integer.
 */
- (void)injectWithInteger:(NSInteger)integerValue;

/**
 * Injects with an unsigned integer.
 */
- (void)injectWithUnsignedInteger:(NSUInteger)unsignedIntegerValue;

/**
* Injects with a class.
*/
- (void)injectWithClass:(Class)classValue;

/**
* Injects with a selector.
*/
- (void)injectWithSelector:(SEL)selectorValue;

#pragma mark - injectParameterNamed:
- (void)injectParameterNamed:(NSString*)name withReference:(NSString*)reference;

- (void)injectParameterNamed:(NSString*)name withValueAsText:(NSString*)text requiredTypeOrNil:(id)classOrProtocol;

- (void)injectParameterNamed:(NSString*)name withObject:(id)value;

/**
* Injects the parameter matched by the given name with the given definition.
*/
- (void)injectParameterNamed:(NSString*)name withDefinition:(TyphoonDefinition*)definition;

/**
* Injects the parameter matched by the given name as a collection of the given requiredType.
*/
- (void)injectParameterNamed:(NSString*)name
        asCollection:(void (^)(TyphoonParameterInjectedAsCollection*))collectionValues
        requiredType:(id)requiredType;


#pragma mark - injectParameterAtIndex
/**
* Injects the parameter at the given index with the given definition.
*/
- (void)injectParameterAtIndex:(NSUInteger)index withDefinition:(TyphoonDefinition*)definition;

/**
* Injects the parameter at the given index as a collection of the given requiredType.
*/
- (void)injectParameterAtIndex:(NSUInteger)index
        asCollection:(void (^)(TyphoonParameterInjectedAsCollection*))collectionValues
        requiredType:(id)requiredType;

- (void)injectParameterAtIndex:(NSUInteger)index withReference:(NSString *)reference;
- (void)injectParameterAtIndex:(NSUInteger)index withReference:(NSString *)reference isProxied:(BOOL)fromCollaboratingAssemblyProxy;

- (void)injectParameterAtIndex:(NSUInteger)index withValueAsText:(NSString*)text requiredTypeOrNil:(id)requiredClass;

- (void)injectParameterAtIndex:(NSUInteger)index withObject:(id)value;

@end
