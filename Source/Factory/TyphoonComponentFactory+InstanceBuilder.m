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
#import "TyphonTypeConverter.h"
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

            if (byValue.classOrProtocol)
            {
                TyphoonTypeDescriptor* descriptor = [TyphoonTypeDescriptor descriptorWithClassOrProtocol:byValue.classOrProtocol];
                id <TyphonTypeConverter> converter = [[TyphoonTypeConverterRegistry shared] converterFor:descriptor];
                id converted = [converter convert:byValue.value];
                [invocation setArgument:&converted atIndex:parameter.index + 2];
            }
            else
            {
                TyphoonPrimitiveTypeConverter* converter = [[TyphoonTypeConverterRegistry shared] primitiveTypeConverter];
                TyphoonTypeDescriptor* descriptor = [byValue resolveTypeWith:instanceOrClass];
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
    if (property.type == TyphoonPropertyInjectionByTypeType)
    {
        id reference = [self componentForType:[typeDescriptor classOrProtocol]];
        objc_msgSend(instance, [instance setterForPropertyWithName:property.name], reference, nil);
    }
    else if (property.type == TyphoonPropertyInjectionByReferenceType)
    {
        id reference = [self componentForKey:((TyphoonPropertyInjectedByReference*) property).reference];
        objc_msgSend(instance, [instance setterForPropertyWithName:property.name], reference, nil);
    }
    else if (property.type == TyphoonPropertyInjectionByValueType)
    {
        TyphoonPropertyInjectedByValue* valueProperty = (TyphoonPropertyInjectedByValue*) property;
        if (typeDescriptor.isPrimitive)
        {
            TyphoonPrimitiveTypeConverter* converter = [[TyphoonTypeConverterRegistry shared] primitiveTypeConverter];
            void* converted = [converter convert:valueProperty.textValue requiredType:typeDescriptor];
            objc_msgSend(instance, [instance setterForPropertyWithName:property.name], converted, nil);
        }
        else
        {
            id <TyphonTypeConverter> converter = [[TyphoonTypeConverterRegistry shared] converterFor:typeDescriptor];
            id converted = [converter convert:valueProperty.textValue];
            objc_msgSend(instance, [instance setterForPropertyWithName:property.name], converted, nil);
        }
    }
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

@end