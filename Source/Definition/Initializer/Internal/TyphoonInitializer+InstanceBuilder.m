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



#import "TyphoonLinkerCategoryBugFix.h"
#import "TyphoonInitializer+InstanceBuilder.h"
#import "TyphoonParameterInjectedWithStringRepresentation.h"
#import "TyphoonDefinition.h"
#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonParameterInjectedAsCollection.h"
#import "TyphoonParameterInjectedWithObjectInstance.h"
#import "TyphoonParameterInjectedByReference.h"
#import "TyphoonComponentFactory+InstanceBuilder.h"
#import "TyphoonCallStack.h"
#import "TyphoonTypeConverter.h"
#import "TyphoonTypeConverterRegistry.h"
#import "TyphoonPrimitiveTypeConverter.h"
#import "TyphoonTypeDescriptor.h"
#import "TyphoonStackElement.h"
#import "NSValue+TCFInstanceBuilder.h"

TYPHOON_LINK_CATEGORY(TyphoonInitializer_InstanceBuilder)


@implementation TyphoonInitializer (InstanceBuilder)

/* ====================================================================================================================================== */
#pragma mark - Interface Methods

- (NSArray*)parametersInjectedByValue
{
    NSPredicate* predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary* bindings)
    {
        return [evaluatedObject isKindOfClass:[TyphoonParameterInjectedWithStringRepresentation class]];
    }];
    return [_injectedParameters filteredArrayUsingPredicate:predicate];

}

- (NSInvocation*)newInvocationInFactory:(TyphoonComponentFactory*)factory
{
    Class clazz = _definition.factory ? _definition.factory.type : _definition.type;

    if ([clazz respondsToSelector:_selector] == NO && [clazz instancesRespondToSelector:_selector] == NO)
    {
        NSString* typeType = self.isClassMethod ? @"Class" : @"Instance";
        [NSException raise:NSInvalidArgumentException
            format:@"%@ method '%@' not found on '%@'. Did you include the required ':' characters to signify arguments?", typeType,
                   NSStringFromSelector(_selector), NSStringFromClass(clazz)];
    }

    NSMethodSignature* signature =
        self.isClassMethod ? [clazz methodSignatureForSelector:_selector] : [clazz instanceMethodSignatureForSelector:_selector];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:_selector];
    [self configureInvocation:invocation withFactory:factory];
    return invocation;
}


- (void)setDefinition:(TyphoonDefinition*)definition
{
    _definition = definition;
    [self resolveIsClassMethod];
}

- (BOOL)isClassMethod
{
    return [self resolveIsClassMethod];
}


/* ====================================================================================================================================== */
#pragma mark - Private Methods

- (BOOL)resolveIsClassMethod
{
    if (_definition.factory)
    {
        if (_isClassMethodStrategy == TyphoonComponentInitializerIsClassMethodYes)
        {
            [NSException raise:NSInvalidArgumentException
                format:@"'is-class-method' can't be 'TyphoonComponentInitializerIsClassMethodYes' when factory-component is used!"];
        }
        else
        {
            return NO;
        }
    }

    switch (_isClassMethodStrategy)
    {
        case TyphoonComponentInitializerIsClassMethodNo:
            return NO;
        case TyphoonComponentInitializerIsClassMethodYes:
            return YES;
        case TyphoonComponentInitializerIsClassMethodGuess:
            return [self selectorDoesNotStartWithInit];
        default:
            return NO;
    }
}

- (BOOL)selectorDoesNotStartWithInit
{
    return ![NSStringFromSelector(_selector) hasPrefix:@"init"];
}

//FIXME: replace parameter.type == with polymorphism
- (void)configureInvocation:(NSInvocation*)invocation withFactory:(TyphoonComponentFactory*)factory
{
    NSArray* injectedParameters = [self injectedParameters];
    for (id <TyphoonInjectedParameter> parameter in injectedParameters)
    {
        if (parameter.type == TyphoonParameterInjectionTypeReference)
        {
            TyphoonParameterInjectedByReference* byReference = (TyphoonParameterInjectedByReference*) parameter;
            [[[factory stack] peekForKey:byReference.reference] instance]; //Raises circular dependencies exception if already initializing.
            id reference = [factory componentForKey:byReference.reference];
            [invocation setArgument:&reference atIndex:parameter.index + 2];
        }
        else if (parameter.type == TyphoonParameterInjectionTypeStringRepresentation)
        {
            TyphoonParameterInjectedWithStringRepresentation* byString = (TyphoonParameterInjectedWithStringRepresentation*) parameter;
            [self setArgumentFor:invocation index:byString.index + 2 textValue:byString.textValue requiredType:[byString resolveType]];
        }
        else if (parameter.type == TyphoonParameterInjectionTypeObjectInstance)
        {
            TyphoonParameterInjectedWithObjectInstance* byInstance = (TyphoonParameterInjectedWithObjectInstance*) parameter;
            id value = byInstance.value;
            BOOL isValuesIsWrapper = [value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSValue class]];

            if (isValuesIsWrapper && [byInstance isPrimitiveParameter])
            {
                [value typhoon_setAsArgumentForInvocation:invocation atIndex:parameter.index + 2];
            }
            else
            {
                [invocation setArgument:&value atIndex:parameter.index + 2];
            }
        }
        else if (parameter.type == TyphoonParameterInjectionTypeAsCollection)
        {
            TyphoonParameterInjectedAsCollection* asCollection = (TyphoonParameterInjectedAsCollection*) parameter;

            //FIXME: This shouldn't be a concern of the TyphoonComponentFactory, but of the collection type.
            id collection = [factory buildCollectionWithValues:asCollection.values requiredType:asCollection.collectionType];
            [invocation setArgument:&collection atIndex:parameter.index + 2];
        }
    }
}

- (void)setArgumentFor:(NSInvocation*)invocation index:(NSUInteger)index1 textValue:(NSString*)textValue
    requiredType:(TyphoonTypeDescriptor*)requiredType
{
    if (requiredType.isPrimitive)
    {
        TyphoonPrimitiveTypeConverter* converter = [[TyphoonTypeConverterRegistry shared] primitiveTypeConverter];
        [converter setPrimitiveArgumentFor:invocation index:index1 textValue:textValue requiredType:requiredType];
    }
    else
    {
        id <TyphoonTypeConverter> converter = [[TyphoonTypeConverterRegistry shared] converterFor:requiredType];
        id converted = [converter convert:textValue];
        [invocation setArgument:&converted atIndex:index1];
    }
}

@end
