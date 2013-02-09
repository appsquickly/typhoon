////////////////////////////////////////////////////////////////////////////////
//
//  MOD PRODUCTIONS
//  Copyright 2013 Mod Productions
//  All Rights Reserved.
//
//  NOTICE: Mod Productions permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <objc/message.h>
#import "TyphoonComponentFactory+PrimitiveTypeInjection.h"
#import "TyphoonIntrospectiveNSObject.h"
#import "TyphoonInjectedProperty.h"
#import "TyphoonPropertyInjectedByValue.h"
#import "TyphoonPrimitiveTypeConverter.h"
#import "TyphoonTypeConverterRegistry.h"
#import "TyphoonTypeDescriptor.h"
#import "TyphoonParameterInjectedByValue.h"


@implementation TyphoonComponentFactory (PrimitiveTypeInjection)


- (void)setPrimitiveArgumentFor:(NSInvocation*)invocation parameter:(TyphoonParameterInjectedByValue*)parameter
        requiredType:(TyphoonTypeDescriptor*)requiredType
{
    TyphoonPrimitiveTypeConverter* converter = [[TyphoonTypeConverterRegistry shared] primitiveTypeConverter];
    if (requiredType.primitiveType == TyphoonPrimitiveTypeBoolean || requiredType.primitiveType == TyphoonPrimitiveTypeChar)
    {
        BOOL converted = [converter convertToBoolean:parameter.value];
        [invocation setArgument:&converted atIndex:parameter.index + 2];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeClass)
    {
        Class converted = [converter convertToClass:parameter.value];
        [invocation setArgument:&converted atIndex:parameter.index + 2];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeDouble)
    {
        double converted = [converter convertToDouble:parameter.value];
        [invocation setArgument:&converted atIndex:parameter.index + 2];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeFloat)
    {
        float converted = [converter convertToFloat:parameter.value];
        [invocation setArgument:&converted atIndex:parameter.index + 2];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeInt)
    {
        int converted = [converter convertToInt:parameter.value];
        [invocation setArgument:&converted atIndex:parameter.index + 2];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeLong)
    {
        long converted = [converter convertToLong:parameter.value];
        [invocation setArgument:&converted atIndex:parameter.index + 2];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeLongLong)
    {
        long long converted = [converter convertToLongLong:parameter.value];
        [invocation setArgument:&converted atIndex:parameter.index + 2];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeSelector)
    {
        SEL converted = [converter convertToSelector:parameter.value];
        [invocation setArgument:&converted atIndex:parameter.index + 2];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeString)
    {
        const char* converted = [converter convertToCString:parameter.value];
        [invocation setArgument:&converted atIndex:parameter.index + 2];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeUnsignedChar)
    {
        unsigned char converted = [converter convertToUnsignedChar:parameter.value];
        [invocation setArgument:&converted atIndex:parameter.index + 2];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeUnsignedInt)
    {
        unsigned int converted = [converter convertToUnsignedInt:parameter.value];
        [invocation setArgument:&converted atIndex:parameter.index + 2];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeUnsignedLong)
    {
        unsigned long converted = [converter convertToUnsignedLong:parameter.value];
        [invocation setArgument:&converted atIndex:parameter.index + 2];
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeUnsignedLongLong)
    {
        unsigned long long converted = [converter convertToUnsignedLongLong:parameter.value];
        [invocation setArgument:&converted atIndex:parameter.index + 2];
    }
    else
    {
        [NSException raise:NSInvalidArgumentException format:@"Type for %@ is not supported.", requiredType];
    }
}



- (void)injectPrimitivePropertyValueOn:(id <TyphoonIntrospectiveNSObject>)instance property:(id <TyphoonInjectedProperty>)property
        valueProperty:(TyphoonPropertyInjectedByValue*)parameter requiredType:(TyphoonTypeDescriptor*)requiredType
{
    TyphoonPrimitiveTypeConverter* converter = [[TyphoonTypeConverterRegistry shared] primitiveTypeConverter];

    if (requiredType.primitiveType == TyphoonPrimitiveTypeBoolean || requiredType.primitiveType == TyphoonPrimitiveTypeChar)
    {
        BOOL converted = [converter convertToBoolean:parameter.textValue];
        objc_msgSend(instance, [instance setterForPropertyWithName:property.name], converted, nil);
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeClass)
    {
        Class converted = [converter convertToClass:parameter.textValue];
        objc_msgSend(instance, [instance setterForPropertyWithName:property.name], converted, nil);
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeDouble)
    {
        double converted = [converter convertToDouble:parameter.textValue];
        objc_msgSend(instance, [instance setterForPropertyWithName:property.name], converted, nil);
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeFloat)
    {
        float converted = [converter convertToFloat:parameter.textValue];
        objc_msgSend(instance, [instance setterForPropertyWithName:property.name], converted, nil);
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeInt)
    {
        int converted = [converter convertToInt:parameter.textValue];
        objc_msgSend(instance, [instance setterForPropertyWithName:property.name], converted, nil);
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeLong)
    {
        long converted = [converter convertToLong:parameter.textValue];
        objc_msgSend(instance, [instance setterForPropertyWithName:property.name], converted, nil);
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeLongLong)
    {
        long long converted = [converter convertToLongLong:parameter.textValue];
        objc_msgSend(instance, [instance setterForPropertyWithName:property.name], converted, nil);
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeSelector)
    {
        SEL converted = [converter convertToSelector:parameter.textValue];
        objc_msgSend(instance, [instance setterForPropertyWithName:property.name], converted, nil);
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeString)
    {
        const char* converted = [converter convertToCString:parameter.textValue];
        objc_msgSend(instance, [instance setterForPropertyWithName:property.name], converted, nil);
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeUnsignedChar)
    {
        unsigned char converted = [converter convertToUnsignedChar:parameter.textValue];
        objc_msgSend(instance, [instance setterForPropertyWithName:property.name], converted, nil);
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeUnsignedInt)
    {
        unsigned int converted = [converter convertToUnsignedInt:parameter.textValue];
        objc_msgSend(instance, [instance setterForPropertyWithName:property.name], converted, nil);
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeUnsignedLong)
    {
        unsigned long converted = [converter convertToUnsignedLong:parameter.textValue];
        objc_msgSend(instance, [instance setterForPropertyWithName:property.name], converted, nil);
    }
    else if (requiredType.primitiveType == TyphoonPrimitiveTypeUnsignedLongLong)
    {
        unsigned long long converted = [converter convertToUnsignedLongLong:parameter.textValue];
        objc_msgSend(instance, [instance setterForPropertyWithName:property.name], converted, nil);
    }
    else
    {
        [NSException raise:NSInvalidArgumentException format:@"Type for %@ is not supported.", requiredType];
    }
}

@end