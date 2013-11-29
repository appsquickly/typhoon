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

#import "TyphoonAssistedFactoryDefinition.h"

@interface TyphoonAssistedFactoryCreator : NSObject

+ (instancetype)creatorWithProtocol:(Protocol *)protocol returns:(Class)returnType;

+ (instancetype)creatorWithProtocol:(Protocol *)protocol factoryBlock:(id)factoryBlock;

+ (instancetype)creatorWithProtocol:(Protocol *)protocol factories:(TyphoonAssistedFactoryDefinitionBlock)definitionblock;

- (Class)factoryClass;

@end
