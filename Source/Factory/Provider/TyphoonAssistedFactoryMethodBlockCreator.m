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

#import "TyphoonAssistedFactoryBase+TyphoonFactoryMethodClosure.h"
#import "TyphoonAssistedFactoryMethodBlock.h"
#import "TyphoonAssistedFactoryMethodBlockClosure.h"

@interface TyphoonAssistedFactoryMethodBlockCreator ()

@property(nonatomic, strong) TyphoonAssistedFactoryMethodBlock *factoryMethod;

@end


@implementation TyphoonAssistedFactoryMethodBlockCreator

- (void)createFromProtocol:(Protocol *)protocol inClass:(Class)factoryClass
{
    struct objc_method_description methodDescription = [self methodDescriptionFor:self.factoryMethod.factoryMethod inProtocol:protocol];
    NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:methodDescription.types];

    // To be able to intercept the result, we need to create the method with
    // other name.
    NSString *name = [NSString stringWithFormat:@"typhoon_interceptable_%@", NSStringFromSelector(methodDescription.name)];
    SEL nameSEL = sel_registerName([name UTF8String]);
    IMP methodIMP = imp_implementationWithBlock(self.factoryMethod.bodyBlock);
    class_addMethod(factoryClass, nameSEL, methodIMP, methodDescription.types);

    TyphoonAssistedFactoryMethodBlockClosure
        *closure = [[TyphoonAssistedFactoryMethodBlockClosure alloc] initWithSelector:nameSEL methodSignature:methodSignature];
    [factoryClass _fmc_setClosure:closure forSelector:self.factoryMethod.factoryMethod];
}

@end
