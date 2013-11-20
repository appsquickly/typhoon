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

#import "TyphoonAssistedFactoryMethodInitializer.h"

@interface TyphoonAssistedFactoryMethodInitializerCreator ()

@property (nonatomic, strong) TyphoonAssistedFactoryMethodInitializer *factoryMethod;

@end


@implementation TyphoonAssistedFactoryMethodInitializerCreator

- (void)createFromProtocol:(Protocol *)protocol inClass:(Class)factoryClass
{
    NSAssert(NO, @"Unimplemented");
}

@end
