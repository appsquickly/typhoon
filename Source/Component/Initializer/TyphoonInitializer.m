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



/* ====================================================================================================================================== */
#pragma mark - Interface Methods


- (void)injectParameterNamed:(NSString*)name withReference:(NSString*)reference
{
    [self injectParameterAtIndex:[self indexOfParameter:name] withReference:reference];
}


- (void)injectParameterAtIndex:(NSUInteger)index withReference:(NSString*)reference
{
    if (index != NSIntegerMax && index < [_parameterNames count])
    {
        [_injectedParameters addObject:[[TyphoonParameterInjectedByReference alloc] initWithParameterIndex:index reference:reference]];
    }
}

- (void)injectParameterNamed:(NSString*)name withValueAsText:(NSString*)text requiredTypeOrNil:(id)classOrProtocol
{
    [self injectParameterAtIndex:[self indexOfParameter:name] withValueAsText:text requiredTypeOrNil:classOrProtocol];
}

- (void)injectParameterNamed:(NSString *)name asCollection:(void (^)(TyphoonParameterInjectedAsCollection *))collectionValues requiredType:(id)requiredType
{
    [self injectParameterAtIndex:[self indexOfParameter:name] asCollection:collectionValues requiredType:requiredType];
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
- (void)injectParameterNamed:(NSString*)name withDefinition:(TyphoonDefinition*)definition;
{
    [self injectParameterNamed:name withReference:definition.key];
}

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
        [_injectedParameters addObject:[[TyphoonParameterInjectedWithObjectInstance alloc] initWithParameterIndex:index value:value]];
    }
}

- (void)injectParameterNamed:(NSString*)name withObject:(id)value
{
    [self injectParameterAtIndex:[self indexOfParameter:name] withObject:value];
}

- (void)injectWithObject:(id)value
{
    [self injectParameterAtIndex:[_injectedParameters count] withObject:value];
}

- (void)injectWithCollection:(void (^)(TyphoonParameterInjectedAsCollection *))collectionValues requiredType:(id)requiredType
{
    [self injectParameterAtIndex:[_injectedParameters count] asCollection:collectionValues requiredType:requiredType];
}

/* ====================================================================================================================================== */
#pragma mark - Block assembly

- (void)injectParameterAtIndex:(NSUInteger)index1 withDefinition:(TyphoonDefinition*)definition
{
    [self injectParameterAtIndex:index1 withReference:definition.key];
}

-(void)injectParameterAtIndex:(NSUInteger)index
                 asCollection:(void (^)(TyphoonParameterInjectedAsCollection *))collectionValues
                 requiredType:(id)requiredType {
    
    TyphoonParameterInjectedAsCollection *parameterInjectedAsCollection =
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
#pragma mark - Utility Methods

- (void)dealloc
{
    for (id <TyphoonInjectedParameter> parameter in _injectedParameters)
    {
        //Null out the __unsafe_unretained pointer back to self.
        [parameter setInitializer:nil];
    }
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
