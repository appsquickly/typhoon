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

#import "TyphoonAssistedFactoryMethodBlockCreator.h"

#include <objc/runtime.h>

#import "TyphoonAssistedFactoryMethodBlock.h"

@implementation TyphoonAssistedFactoryMethodBlockCreator

- (void)createFromProtocol:(Protocol *)protocol inClass:(Class)factoryClass
{
    unsigned int methodCount = 0;
    struct objc_method_description *methodDescriptions = protocol_copyMethodDescriptionList(protocol, YES, YES, &methodCount);

    // Search for the right obcj_method_description
    struct objc_method_description methodDescription;
    BOOL found = NO;
    for (unsigned int idx = 0; idx < methodCount; idx++)
    {
        methodDescription = methodDescriptions[idx];
        if (methodDescription.name == self.factoryMethod.factoryMethod)
        {
            found = YES;
            break;
        }
    }
    NSCAssert(found, @"protocol doesn't support factory method with name %@", NSStringFromSelector(self.factoryMethod.factoryMethod));

    // Here the method description is valid
    IMP methodIMP = imp_implementationWithBlock(self.factoryMethod.bodyBlock);
    class_addMethod(factoryClass, methodDescription.name, methodIMP, methodDescription.types);

    free(methodDescriptions);
}

@end
