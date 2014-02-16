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

#import "TyphoonAssistedFactoryMethodInitializerCreator.h"
#import "TyphoonAssistedFactoryMethodCreator+Private.h"

#import "TyphoonAssistedFactoryBase+TyphoonFactoryMethodClosure.h"
#import "TyphoonAssistedFactoryMethodInitializerClosure.h"
#import "TyphoonAssistedFactoryMethodInitializer.h"


@interface TyphoonAssistedFactoryMethodInitializerCreator ()

@property(nonatomic, strong) TyphoonAssistedFactoryMethodInitializer *factoryMethod;

@end


@implementation TyphoonAssistedFactoryMethodInitializerCreator

- (void)createFromProtocol:(Protocol *)protocol inClass:(Class)factoryClass
{
    struct objc_method_description methodDescription = [self methodDescriptionFor:self.factoryMethod.factoryMethod inProtocol:protocol];
    NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:methodDescription.types];

    TyphoonAssistedFactoryMethodInitializerClosure *closure =
        [[TyphoonAssistedFactoryMethodInitializerClosure alloc] initWithInitializer:self.factoryMethod methodSignature:methodSignature];
    [factoryClass _fmc_setClosure:closure forSelector:self.factoryMethod.factoryMethod];
}

@end
