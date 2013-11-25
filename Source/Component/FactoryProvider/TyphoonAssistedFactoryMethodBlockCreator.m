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
#import "TyphoonAssistedFactoryMethodCreator+Private.h"

#include <objc/runtime.h>

#import "TyphoonAssistedFactoryMethodBlock.h"

@implementation TyphoonAssistedFactoryMethodBlockCreator

- (void)createFromProtocol:(Protocol *)protocol inClass:(Class)factoryClass
{
    struct objc_method_description methodDescription = [self methodDescriptionFor:self.factoryMethod.factoryMethod inProtocol:protocol];
    IMP methodIMP = imp_implementationWithBlock(self.factoryMethod.bodyBlock);
    class_addMethod(factoryClass, methodDescription.name, methodIMP, methodDescription.types);
}

@end
