////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import <objc/message.h>
#import "SpringComponentFactory+InstanceBuilder.h"
#import "SpringComponentDefinition.h"
#import "SpringParameterInjectedByReference.h"
#import "SpringComponentInitializer.h"
#import "SpringPropertyInjectedByReference.h"
#import "SpringTypeDescriptor.h"
#import "SpringTypeConverter.h"
#import "SpringTypeConverterRegistry.h"
#import "SpringPropertyInjectedByValue.h"
#import "SpringPropertyInjectionDelegate.h"
#import "SpringParameterInjectedByValue.h"
#import "SpringPrimitiveTypeConverter.h"


@implementation SpringComponentFactory (InstanceBuilder)

- (id)buildInstanceWithDefinition:(SpringComponentDefinition*)definition
{
    id <SpringReflectiveNSObject> instance;
    if (definition.initializer && definition.initializer.isClassMethod)
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
- (id)invokeInitializerOn:(id)instanceOrClass withDefinition:(SpringComponentDefinition*)definition
{
    NSInvocation* invocation = [definition.initializer asInvocationFor:instanceOrClass];

    for (id <SpringInjectedParameter> parameter in [definition.initializer injectedParameters])
    {
        if (parameter.type == SpringParameterInjectedByReferenceType)
        {
            SpringParameterInjectedByReference* byReference = (SpringParameterInjectedByReference*) parameter;
            id reference = [self objectForKey:byReference.reference];
            [invocation setArgument:&reference atIndex:parameter.index + 2];
        }
        else if (parameter.type == SpringParameterInjectedByValueType)
        {
            SpringParameterInjectedByValue* injectedByValue = (SpringParameterInjectedByValue*) parameter;

            if (injectedByValue.classOrProtocol)
            {
                SpringTypeDescriptor* descriptor = [SpringTypeDescriptor descriptorWithClassOrProtocol:injectedByValue.classOrProtocol];
                id <SpringTypeConverter> converter = [[SpringTypeConverterRegistry shared] converterFor:descriptor];
                id converted = [converter convert:injectedByValue.value];
                [invocation setArgument:&converted atIndex:parameter.index + 2];
            }
            else
            {
                SpringPrimitiveTypeConverter* converter = [[SpringTypeConverterRegistry shared] primitiveTypeConverter];
                SpringTypeDescriptor* descriptor = [injectedByValue resolveTypeWith:instanceOrClass];
                void* converted = [converter convert:injectedByValue.value requiredType:descriptor];
                [invocation setArgument:&converted atIndex:parameter.index + 2];
            }
        }
    }
    [invocation invoke];
    id <NSObject> returnValue = definition.initializer.isClassMethod ? nil : instanceOrClass;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

- (void)injectPropertyDependenciesOn:(id <SpringReflectiveNSObject>)instance withDefinition:(SpringComponentDefinition*)definition
{
    if ([instance conformsToProtocol:@protocol(SpringPropertyInjectionDelegate)])
    {
        [(id <SpringPropertyInjectionDelegate>) instance beforePropertiesSet];
    }

    for (id <SpringInjectedProperty> property in [definition injectedProperties])
    {
        SpringTypeDescriptor* typeDescriptor = [instance typeForPropertyWithName:property.name];
        if (typeDescriptor == nil)
        {
            [NSException raise:NSInvalidArgumentException
                        format:@"Tried to inject property '%@' on object of type '%@', but the instance has no setter for this property.",
                               property.name, [instance class]];
        }
        [self doPropertyInjection:instance property:property typeDescriptor:typeDescriptor];
    }

    if ([instance conformsToProtocol:@protocol(SpringPropertyInjectionDelegate)])
    {
        [(id <SpringPropertyInjectionDelegate>) instance afterPropertiesSet];
    }
    if ([instance respondsToSelector:definition.afterPropertyInjection])
    {
        [instance performSelector:definition.afterPropertyInjection];
    }
}

- (void)doPropertyInjection:(id <SpringReflectiveNSObject>)instance property:(id <SpringInjectedProperty>)property
             typeDescriptor:(SpringTypeDescriptor*)typeDescriptor
{
    if (property.type == SpringPropertyInjectionByTypeType)
    {
        id reference = [self objectForType:[typeDescriptor classOrProtocol]];
        objc_msgSend(instance, [instance setterForPropertyWithName:property.name], reference, nil);
    }
    else if (property.type == SpringPropertyInjectionByReferenceType)
    {
        id reference = [self objectForKey:((SpringPropertyInjectedByReference*) property).reference];
        objc_msgSend(instance, [instance setterForPropertyWithName:property.name], reference, nil);
    }
    else if (property.type == SpringPropertyInjectionByValueType)
    {
        SpringPropertyInjectedByValue* valueProperty = (SpringPropertyInjectedByValue*) property;
        if (typeDescriptor.isPrimitive)
        {
            SpringPrimitiveTypeConverter* converter = [[SpringTypeConverterRegistry shared] primitiveTypeConverter];
            void* converted = [converter convert:valueProperty.textValue requiredType:typeDescriptor];
            objc_msgSend(instance, [instance setterForPropertyWithName:property.name], converted, nil);
        }
        else
        {
            id <SpringTypeConverter> converter = [[SpringTypeConverterRegistry shared] converterFor:typeDescriptor];
            id converted = [converter convert:valueProperty.textValue];
            objc_msgSend(instance, [instance setterForPropertyWithName:property.name], converted, nil);
        }
    }
}

@end