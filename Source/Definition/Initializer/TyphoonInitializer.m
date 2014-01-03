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
#import "TyphoonLogger.h"
#import "TyphoonOCLogTemplateLogger.h"

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

        self.logger = [[TyphoonOCLogTemplateLogger alloc] init];
    }
    return self;
}

- (id)init
{
    return [self initWithSelector:@selector(init) isClassMethodStrategy:TyphoonComponentInitializerIsClassMethodGuess];
}



/* ====================================================================================================================================== */
#pragma mark - Interface Methods


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

- (void)injectParameterNamed:(NSString*)name asCollection:(void (^)(TyphoonParameterInjectedAsCollection*))collectionValues requiredType:(id)requiredType
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
    if (index == NSIntegerMax) {
        [self logParameterNotFound:name];
        return;
    }

    if (success) {
        success(index);
    }
}

#pragma mark injectParameterAtIndex:
- (void)injectParameterAtIndex:(NSUInteger)index withReference:(NSString*)reference
{
    if (index != NSIntegerMax &&index < [_parameterNames count])
    {
        [_injectedParameters addObject:[[TyphoonParameterInjectedByReference alloc] initWithParameterIndex:index reference:reference]];
    }
}
- (void)injectParameterAtIndex:(NSUInteger)index withValueAsText:(NSString*)text requiredTypeOrNil:(id)requiredClass
{
    if (index != NSIntegerMax &&index < [_parameterNames count])
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
    if (index != NSIntegerMax &&index < [_parameterNames count])
    {
        [_injectedParameters addObject:[[TyphoonParameterInjectedWithObjectInstance alloc] initWithParameterIndex:index value:value]];
    }
}



- (void)logParameterNotFound:(NSString*)name
{
    if ([_parameterNames count] > 0) {
        NSString *failureExplanation = [NSString stringWithFormat:@"Unrecognized parameter name: '%@' for method '%@'.", name, NSStringFromSelector([self selector])];
        NSString *recoverySuggestion = [self recoverySuggestionForMissingParameter];
        NSString *message = [NSString stringWithFormat:@"%@ %@", failureExplanation, recoverySuggestion];
        [self.logger logWarn:message];
    }else{
        NSString *failureExplanation = [NSString stringWithFormat:@"Specified a parameter named '%@', but method '%@' takes no parameters.", name, NSStringFromSelector([self selector])];
        [self.logger logWarn:failureExplanation];
    }
}

- (NSString*)recoverySuggestionForMissingParameter
{
    if ([_parameterNames count] == 1) {
        return [NSString stringWithFormat:@"Did you mean '%@'?", _parameterNames[0]];
    }else if ([_parameterNames count] == 2) {
         return [NSString stringWithFormat:@"Valid parameter names are '%@' or '%@'.", _parameterNames[0], _parameterNames[1]];
    }else{
        NSMutableString* messageBuilder = [NSMutableString stringWithFormat:@"Valid parameter names are"];
        [_parameterNames enumerateObjectsUsingBlock:^(NSString *aParameterName, NSUInteger idx, BOOL* stop)
        {
            BOOL thisIsLastParameter = (idx == [_parameterNames count] - 1);
            if (thisIsLastParameter) {
                [messageBuilder appendFormat:@", or '%@'.", aParameterName];
            }else if (idx == 0) { // first param
                [messageBuilder appendFormat:@" '%@'", aParameterName];
            }else{
                // neither first nor last
                [messageBuilder appendFormat:@", '%@'", aParameterName];
            }
        }];

        return messageBuilder;
    }
}

- (void)injectWithObject:(id)value
{
    [self injectParameterAtIndex:[_injectedParameters count] withObject:value];
}

- (void)injectWithCollection:(void (^)(TyphoonParameterInjectedAsCollection*))collectionValues requiredType:(id)requiredType
{
    [self injectParameterAtIndex:[_injectedParameters count] asCollection:collectionValues requiredType:requiredType];
}

- (void)injectWithInt:(int)intValue
{
    [self injectWithValueAsText:[@(intValue) stringValue]];
}

- (void)injectWithUnsignedInt:(unsigned int)unsignedIntValue
{
  [self injectWithValueAsText:[@(unsignedIntValue) stringValue]];
}

- (void)injectWithShort:(short)shortValue
{
    [self injectWithValueAsText:[@(shortValue) stringValue]];
}

- (void)injectWithUnsignedShort:(unsigned short)unsignedShortValue
{
  [self injectWithValueAsText:[@(unsignedShortValue) stringValue]];
}

- (void)injectWithLong:(long)longValue
{
    [self injectWithValueAsText:[@(longValue) stringValue]];
}

- (void)injectWithUnsignedLong:(unsigned long)unsignedLongValue
{
  [self injectWithValueAsText:[@(unsignedLongValue) stringValue]];
}

- (void)injectWithLongLong:(long long)longLongValue
{
    [self injectWithValueAsText:[@(longLongValue) stringValue]];
}

- (void)injectWithUnsignedLongLong:(unsigned long long)unsignedLongLongValue
{
  [self injectWithValueAsText:[@(unsignedLongLongValue) stringValue]];
}

- (void)injectWithUnsignedChar:(unsigned char)unsignedCharValue
{
    [self injectWithValueAsText:[@(unsignedCharValue) stringValue]];
}

- (void)injectWithFloat:(float)floatValue
{
    [self injectWithValueAsText:[NSString stringWithFormat:@"%f", floatValue]];
}

- (void)injectWithDouble:(double)doubleValue
{
    [self injectWithValueAsText:[NSString stringWithFormat:@"%f", doubleValue]];
}

- (void)injectWithBool:(BOOL)boolValue
{
    [self injectWithValueAsText:[@(boolValue) stringValue]];
}

- (void)injectWithInteger:(NSInteger)integerValue
{
  [self injectWithValueAsText:[@(integerValue) stringValue]];
}

- (void)injectWithUnsignedInteger:(NSUInteger)unsignedIntegerValue
{
  [self injectWithValueAsText:[@(unsignedIntegerValue) stringValue]];
}

- (void)injectWithClass:(Class)classValue
{
    [self injectWithValueAsText:NSStringFromClass(classValue)];
}

- (void)injectWithSelector:(SEL)selectorValue
{
    [self injectWithValueAsText:NSStringFromSelector(selectorValue)];
}

/* ====================================================================================================================================== */
#pragma mark - Block assembly

- (void)injectParameterAtIndex:(NSUInteger)index1 withDefinition:(TyphoonDefinition*)definition
{
    [self injectParameterAtIndex:index1 withReference:definition.key];
}

- (void)injectParameterAtIndex:(NSUInteger)index
        asCollection:(void (^)(TyphoonParameterInjectedAsCollection*))collectionValues
        requiredType:(id)requiredType
{

    TyphoonParameterInjectedAsCollection* parameterInjectedAsCollection =
            [[TyphoonParameterInjectedAsCollection alloc] initWithParameterIndex:index requiredType:requiredType];

    if (collectionValues)
    {
        __unsafe_unretained TyphoonParameterInjectedAsCollection* weakParameterInjectedAsCollection = parameterInjectedAsCollection;
        collectionValues(weakParameterInjectedAsCollection);
    }

    if (index != NSIntegerMax &&index < [_parameterNames count])
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
