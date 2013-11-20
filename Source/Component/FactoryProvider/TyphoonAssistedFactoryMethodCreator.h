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

#import "TyphoonAssistedFactoryMethod.h"

@interface TyphoonAssistedFactoryMethodCreator : NSObject

@property (nonatomic, strong, readonly) id<TyphoonAssistedFactoryMethod> factoryMethod;

+ (instancetype)creatorFor:(id<TyphoonAssistedFactoryMethod>)factoryMethod;

- (void)createFromProtocol:(Protocol *)protocol inClass:(Class)factoryClass;

@end
