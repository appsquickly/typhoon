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

#import <Foundation/Foundation.h>

#include <objc/runtime.h>

@class TyphoonAssistedFactoryMethodInitializer;

@interface TyphoonAssistedFactoryMethodClosure : NSObject

- (instancetype)initWithInitializer:(TyphoonAssistedFactoryMethodInitializer *)initializer methodDescription:(struct objc_method_description)methodDescription;

- (void *)fptr;

@end
