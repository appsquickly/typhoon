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




#import <objc/message.h>
#import "TyphoonComponentFactory+InstanceBuilder.h"
#import "TyphoonDefinition.h"
#import "TyphoonParameterInjectedByReference.h"
#import "TyphoonInitializer.h"
#import "TyphoonPropertyInjectedByReference.h"
#import "TyphoonTypeDescriptor.h"
#import "TyphoonTypeConverterRegistry.h"
#import "TyphoonPropertyInjectedByValue.h"
#import "TyphoonPropertyInjectionDelegate.h"
#import "TyphoonParameterInjectedByValue.h"
#import "TyphoonPrimitiveTypeConverter.h"


@implementation TyphoonComponentFactory (InstanceBuilder)

/* ========================================================== Interface Methods ========================================================= */
- (id)buildInstanceWithDefinition:(TyphoonDefinition*)definition
{
    id <TyphoonIntrospectiveNSObject> instance;

    if (definition.factoryComponent)
    {
        instance = [self componentForKey:definition.factoryComponent];
    }
    else if (definition.initializer && definition.initializer.isClassMethod)
    {
        instance = [self invokeInitializerOn:definition.type withDefinition:definition];
    }
    else
    {
        instance = [definition.type alloc];
    }

    if (definition.initializer && definition.initializer.isClassMethod == NO)
    {
        instance = [self invokeInitializerOn:instance withDefinition:definition];
    }
    else if (definition.initializer == nil)
    {
        instance = objc_msgSend(instance, @selector(init));
    }

    [self injectPropertyDependenciesOn:instance withDefinition:definition];
    return instance;
}


/* ============================================================ Private Methods ========================================================= */
- (id)invokeInitializerOn:(id)instanceOrClass withDefinition:(TyphoonDefinition*)definition
{
    NSInvocation* invocation = [definition.initializer asInvocationFor:instanceOrClass];

    for (id <TyphoonInjectedParameter> parameter in [definition.initializer injectedParameters])
    {
        if (parameter.type == TyphoonParameterInjectedByReferenceType)
        {
            TyphoonParameterInjectedByReference* byReference = (TyphoonParameterInjectedByReference*) parameter;
            id reference = [self componentForKey:byReference.reference];
            [invocation setArgument:&reference atIndex:parameter.index + 2];
        }
        else if (parameter.type == TyphoonParameterInjectedByValueType)
        {
            TyphoonParameterInjectedByValue* byValue = (TyphoonParameterInjectedByValue*) parameter;
            [self setArgumentFor:invocation index:byValue.index + 2 textValue:byValue.textValue
                    requiredType:[byValue resolveTypeWith:instanceOrClass]];
        }
    }
    [invocation invoke];
    __autoreleasing id <NSObject> returnValue = definition.initializer.isClassMethod || definition.factoryComponent ? nil : instanceOrClass;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

/* ====================================================================================================================================== */
#pragma mark - Property Injection

- (void)injectPropertyDependenciesOn:(id <TyphoonIntrospectiveNSObject>)instance withDefinition:(TyphoonDefinition*)definition
{
    [self doBeforePropertyInjectionOn:instance withDefinition:definition];

    for (id <TyphoonInjectedProperty> property in [definition injectedProperties])
    {
        TyphoonTypeDescriptor* typeDescriptor = [instance typeForPropertyWithName:property.name];
        if (typeDescriptor == nil)
        {
            [NSException raise:NSInvalidArgumentException
                    format:@"Tried to inject property '%@' on object of type '%@', but the instance has no setter for this property.",
                           property.name, [instance class]];
        }
        [self doPropertyInjection:instance property:property typeDescriptor:typeDescriptor];
    }

    [self doAfterPropertyInjectionOn:instance withDefinition:definition];
}

- (void)doBeforePropertyInjectionOn:(id <TyphoonIntrospectiveNSObject>)instance withDefinition:(TyphoonDefinition*)definition
{
    if ([instance conformsToProtocol:@protocol(TyphoonPropertyInjectionDelegate)])
    {
        [(id <TyphoonPropertyInjectionDelegate>) instance beforePropertiesSet];
    }
    if ([instance respondsToSelector:definition.beforePropertyInjection])
    {
        objc_msgSend(instance, definition.beforePropertyInjection);
    }
}

- (void)doPropertyInjection:(id <TyphoonIntrospectiveNSObject>)instance property:(id <TyphoonInjectedProperty>)property
        typeDescriptor:(TyphoonTypeDescriptor*)typeDescriptor
{
    NSInvocation* invocation = [self propertySetterInvocationFor:instance property:property];
    NSLog(@"Property setter invocation: %@", invocation);
    if (property.type == TyphoonPropertyInjectionByTypeType)
    {
        id reference = [self componentForType:[typeDescriptor classOrProtocol]];
        [invocation setArgument:&reference atIndex:2];
    }
    else if (property.type == TyphoonPropertyInjectionByReferenceType)
    {
        id reference = [self componentForKey:((TyphoonPropertyInjectedByReference*) property).reference];
        [invocation setArgument:&reference atIndex:2];
    }
    else if (property.type == TyphoonPropertyInjectionByValueType)
    {
        TyphoonPropertyInjectedByValue* valueProperty = (TyphoonPropertyInjectedByValue*) property;
        [self setArgumentFor:invocation index:2 textValue:valueProperty.textValue requiredType:typeDescriptor];
    }
    [invocation invoke];
}

- (NSInvocation*)propertySetterInvocationFor:(id <TyphoonIntrospectiveNSObject>)instance property:(id <TyphoonInjectedProperty>)property
{
    SEL pSelector = [instance setterForPropertyWithName:property.name];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:[(NSObject*) instance methodSignatureForSelector:pSelector]];
    [invocation setTarget:instance];
    [invocation setSelector:pSelector];
    return invocation;
}


- (void)doAfterPropertyInjectionOn:(id <TyphoonIntrospectiveNSObject>)instance withDefinition:(TyphoonDefinition*)definition
{
    if ([instance conformsToProtocol:@protocol(TyphoonPropertyInjectionDelegate)])
    {
        [(id <TyphoonPropertyInjectionDelegate>) instance afterPropertiesSet];
    }
    if ([instance respondsToSelector:definition.afterPropertyInjection])
    {
        objc_msgSend(instance, definition.afterPropertyInjection);
    }
}


/* ====================================================================================================================================== */
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