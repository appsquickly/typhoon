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

/* ========================================================== Interface Methods ========================================================= */
- (id)buildInstanceWithDefinition:(SpringComponentDefinition*)definition
{
    id <SpringIntrospectiveNSObject> instance;

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
- (id)invokeInitializerOn:(id)instanceOrClass withDefinition:(SpringComponentDefinition*)definition
{
    NSInvocation* invocation = [definition.initializer asInvocationFor:instanceOrClass];

    for (id <SpringInjectedParameter> parameter in [definition.initializer injectedParameters])
    {
        if (parameter.type == SpringParameterInjectedByReferenceType)
        {
            SpringParameterInjectedByReference* byReference = (SpringParameterInjectedByReference*) parameter;
            id reference = [self componentForKey:byReference.reference];
            [invocation setArgument:&reference atIndex:parameter.index + 2];
        }
        else if (parameter.type == SpringParameterInjectedByValueType)
        {
            SpringParameterInjectedByValue* byValue = (SpringParameterInjectedByValue*) parameter;

            if (byValue.classOrProtocol)
            {
                SpringTypeDescriptor* descriptor = [SpringTypeDescriptor descriptorWithClassOrProtocol:byValue.classOrProtocol];
                id <SpringTypeConverter> converter = [[SpringTypeConverterRegistry shared] converterFor:descriptor];
                id converted = [converter convert:byValue.value];
                [invocation setArgument:&converted atIndex:parameter.index + 2];
            }
            else
            {
                SpringPrimitiveTypeConverter* converter = [[SpringTypeConverterRegistry shared] primitiveTypeConverter];
                SpringTypeDescriptor* descriptor = [byValue resolveTypeWith:instanceOrClass];
                void* converted = [converter convert:byValue.value requiredType:descriptor];
                [invocation setArgument:&converted atIndex:parameter.index + 2];
            }
        }
    }
    [invocation invoke];
    id <NSObject> returnValue = definition.initializer.isClassMethod || definition.factoryComponent ? nil : instanceOrClass;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}

/* ====================================================================================================================================== */
#pragma mark - Property Injection

- (void)injectPropertyDependenciesOn:(id <SpringIntrospectiveNSObject>)instance withDefinition:(SpringComponentDefinition*)definition
{
    [self doBeforePropertyInjectionOn:instance withDefinition:definition];

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

    [self doAfterPropertyInjectionOn:instance withDefinition:definition];
}

- (void)doBeforePropertyInjectionOn:(id <SpringIntrospectiveNSObject>)instance withDefinition:(SpringComponentDefinition*)definition
{
    if ([instance conformsToProtocol:@protocol(SpringPropertyInjectionDelegate)])
    {
        [(id <SpringPropertyInjectionDelegate>) instance beforePropertiesSet];
    }
    if ([instance respondsToSelector:definition.beforePropertyInjection])
    {
        objc_msgSend(instance, definition.beforePropertyInjection);
    }
}

- (void)doPropertyInjection:(id <SpringIntrospectiveNSObject>)instance property:(id <SpringInjectedProperty>)property
        typeDescriptor:(SpringTypeDescriptor*)typeDescriptor
{
    if (property.type == SpringPropertyInjectionByTypeType)
    {
        id reference = [self componentForType:[typeDescriptor classOrProtocol]];
        objc_msgSend(instance, [instance setterForPropertyWithName:property.name], reference, nil);
    }
    else if (property.type == SpringPropertyInjectionByReferenceType)
    {
        id reference = [self componentForKey:((SpringPropertyInjectedByReference*) property).reference];
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

- (void)doAfterPropertyInjectionOn:(id <SpringIntrospectiveNSObject>)instance withDefinition:(SpringComponentDefinition*)definition
{
    if ([instance conformsToProtocol:@protocol(SpringPropertyInjectionDelegate)])
    {
        [(id <SpringPropertyInjectionDelegate>) instance afterPropertiesSet];
    }
    if ([instance respondsToSelector:definition.afterPropertyInjection])
    {
        objc_msgSend(instance, definition.afterPropertyInjection);
    }
}

@end