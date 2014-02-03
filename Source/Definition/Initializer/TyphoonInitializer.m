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



#import "TyphoonCollaboratingAssemblyProxy.h"
#import "TyphoonInitializer.h"
#import "TyphoonParameterInjectedByReference.h"
#import "NSObject+TyphoonIntrospectionUtils.h"
#import "TyphoonParameterInjectedWithStringRepresentation.h"
#import "TyphoonParameterInjectedWithObjectInstance.h"
#import "TyphoonDefinition.h"
#import "TyphoonParameterInjectedAsCollection.h"

@implementation TyphoonInitializer


/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)initWithSelector:(SEL)initializer
{
    return [self initWithSelector:initializer isClassMethodStrategy:TyphoonComponentInitializerIsClassMethodGuess];
}

- (id)initWithSelector:(SEL)initializer isClassMethodStrategy:(TyphoonComponentInitializerIsClassMethod)isClassMethod;
{
    self = [super init];
    if (self)
    {
        _injectedParameters = [[NSMutableArray alloc] init];
        _isClassMethodStrategy = isClassMethod;
        self.selector = initializer;
    }
    return self;
}

- (id)init
{
    return [self initWithSelector:@selector(init) isClassMethodStrategy:TyphoonComponentInitializerIsClassMethodGuess];
}

- (void)dealloc
{
    for (id <TyphoonInjectedParameter> parameter in _injectedParameters)
    {
        //Null out the __unsafe_unretained pointer back to self.
        [parameter setInitializer:nil];
    }
}

/* ====================================================================================================================================== */
#pragma mark - Interface Methods

- (TyphoonDefinition*)definition
{
    return _definition;
}

- (NSArray*)injectedParameters
{
    return [_injectedParameters copy];
}

#pragma mark - injectParameterNamed

- (void)injectParameterNamed:(NSString*)name withDefinition:(TyphoonDefinition*)definition;
{
    [self injectParameterNamed:name withReference:definition.key];
}

- (void)injectParameterNamed:(NSString*)name withReference:(NSString*)reference
{
    [self injectParameterNamed:name success:^(NSInteger index)
    {
        [self injectParameterAtIndex:index withReference:reference];
    }];
}

- (void)injectParameterNamed:(NSString*)name withValueAsText:(NSString*)text requiredTypeOrNil:(id)classOrProtocol
{
    [self injectParameterNamed:name success:^(NSInteger index)
    {
        [self injectParameterAtIndex:index withValueAsText:text requiredTypeOrNil:classOrProtocol];
    }];
}

- (void)injectParameterNamed:(NSString*)name asCollection:(void (^)(TyphoonParameterInjectedAsCollection*))collectionValues
    requiredType:(id)requiredType
{
    [self injectParameterNamed:name success:^(NSInteger index)
    {
        [self injectParameterAtIndex:index asCollection:collectionValues requiredType:requiredType];
    }];
}

- (void)injectParameterNamed:(NSString*)name withObject:(id)value
{
    [self injectParameterNamed:name success:^(NSInteger index)
    {
        [self injectParameterAtIndex:index withObject:value];
    }];
}

- (void)injectParameterNamed:(NSString*)name success:(void (^)(NSInteger))success
{
    NSInteger index = [self indexOfParameter:name];
    if (index == NSIntegerMax)
    {
        [NSException raise:NSInvalidArgumentException format:@"%@", [self parameterNotFoundErrorMessageWithParameterNamed:name]];
    }

    if (success)
    {
        success(index);
    }
}


- (NSString*)parameterNotFoundErrorMessageWithParameterNamed:(NSString*)name
{
    if ([_parameterNames count] == 0)
    {
        return [NSString stringWithFormat:@"Specified a parameter named '%@', but method '%@' takes no parameters.", name,
                                          NSStringFromSelector([self selector])];
    }

    NSString* failureExplanation =
        [NSString stringWithFormat:@"Unrecognized parameter name: '%@' for method '%@'.", name, NSStringFromSelector([self selector])];
    NSString* recoverySuggestion = [self recoverySuggestionForMissingParameter];
    return [NSString stringWithFormat:@"%@ %@", failureExplanation, recoverySuggestion];
}

- (NSString*)recoverySuggestionForMissingParameter
{
    if ([_parameterNames count] == 1)
    {
        return [NSString stringWithFormat:@"Did you mean '%@'?", _parameterNames[0]];
    }
    else if ([_parameterNames count] == 2)
    {
        return [NSString stringWithFormat:@"Valid parameter names are '%@' or '%@'.", _parameterNames[0], _parameterNames[1]];
    }
    else
    {
        return [self recoverySuggestionForMultipleMissingParameters];
    }
}

- (NSString*)recoverySuggestionForMultipleMissingParameters
{
    NSMutableString* messageBuilder = [NSMutableString stringWithFormat:@"Valid parameter names are"];
    [_parameterNames enumerateObjectsUsingBlock:^(NSString* aParameterName, NSUInteger idx, BOOL* stop)
    {
        BOOL thisIsLastParameter = (idx == [_parameterNames count] - 1);
        if (idx == 0)
        {
            [messageBuilder appendFormat:@" '%@'", aParameterName];
        }
        else if (!thisIsLastParameter)
        { // middleParameter
            [messageBuilder appendFormat:@", '%@'", aParameterName];
        }
        else
        { // lastParameter
            [messageBuilder appendFormat:@", or '%@'.", aParameterName];
        }
    }];

    return [NSString stringWithString:messageBuilder];
}

#pragma mark injectParameterAtIndex:


- (void)injectParameterAtIndex:(NSUInteger)index withReference:(NSString*)reference
{
    if (index != NSIntegerMax && index < [_parameterNames count])
    {
        [_injectedParameters addObject:[[TyphoonParameterInjectedByReference alloc] initWithParameterIndex:index reference:reference]];
    }
}

- (void)injectParameterAtIndex:(NSUInteger)index withValueAsText:(NSString*)text requiredTypeOrNil:(id)requiredClass
{
    if (index != NSIntegerMax && index < [_parameterNames count])
    {
        TyphoonParameterInjectedWithStringRepresentation* parameterInjectedByValue =
            [[TyphoonParameterInjectedWithStringRepresentation alloc] initWithIndex:index value:text requiredTypeOrNil:requiredClass];
        [parameterInjectedByValue setInitializer:self];
        [_injectedParameters addObject:parameterInjectedByValue];
    }
}

/* ====================================================================================================================================== */


- (void)injectWithDefinition:(TyphoonDefinition*)definition;
{
    [self injectParameterAtIndex:[_injectedParameters count] withDefinition:definition];
}

- (void)injectWithValueAsText:(NSString*)text
{
    [self injectWithValueAsText:text requiredTypeOrNil:nil];
}

- (void)injectWithValueAsText:(NSString*)text requiredTypeOrNil:(id)requiredTypeOrNil
{
    [self injectParameterAtIndex:[_injectedParameters count] withValueAsText:text requiredTypeOrNil:requiredTypeOrNil];
}

- (void)injectParameterAtIndex:(NSUInteger)index withObject:(id)value
{
    if (index != NSIntegerMax && index < [_parameterNames count])
    {
        TyphoonParameterInjectedWithObjectInstance
            * param = [[TyphoonParameterInjectedWithObjectInstance alloc] initWithParameterIndex:index value:value];
        [param setInitializer:self];
        [_injectedParameters addObject:param];
    }
}

- (void)injectWithObjectInstance:(id)value;
{
    [self injectParameterAtIndex:[_injectedParameters count] withObject:value];
}

- (void)injectWithCollection:(void (^)(TyphoonParameterInjectedAsCollection*))collectionValues requiredType:(id)requiredType
{
    [self injectParameterAtIndex:[_injectedParameters count] asCollection:collectionValues requiredType:requiredType];
}

/* ====================================================================================================================================== */
#pragma mark - Block assembly

- (void)injectParameterAtIndex:(NSUInteger)index withDefinition:(TyphoonDefinition*)definition
{
    [self injectParameterAtIndex:index withReference:definition.key];
}

- (void)injectParameterAtIndex:(NSUInteger)index asCollection:(void (^)(TyphoonParameterInjectedAsCollection*))collectionValues
    requiredType:(id)requiredType
{

    TyphoonParameterInjectedAsCollection* parameterInjectedAsCollection =
        [[TyphoonParameterInjectedAsCollection alloc] initWithParameterIndex:index requiredType:requiredType];

    if (collectionValues)
    {
        __unsafe_unretained TyphoonParameterInjectedAsCollection* weakParameterInjectedAsCollection = parameterInjectedAsCollection;
        collectionValues(weakParameterInjectedAsCollection);
    }

    if (index != NSIntegerMax && index < [_parameterNames count])
    {
        [_injectedParameters addObject:parameterInjectedAsCollection];
    }
}

- (void)setSelector:(SEL)selector
{
    _selector = selector;
    _parameterNames = [self parameterNamesForSelector:_selector];
}


/* ====================================================================================================================================== */
#pragma mark - Private Methods

- (NSInteger)indexOfParameter:(NSString*)name
{
    NSInteger parameterIndex = NSIntegerMax;
    for (NSInteger i = 0; i < [_parameterNames count]; i++)
    {
        NSString* parameterName = [_parameterNames objectAtIndex:i];
        if ([name isEqualToString:parameterName])
        {
            parameterIndex = i;
            break;
        }
    }
    return parameterIndex;
}


@end
