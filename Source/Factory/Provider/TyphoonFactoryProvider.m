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

#import "TyphoonFactoryProvider.h"

#import "TyphoonAssistedFactoryCreator.h"

@implementation TyphoonFactoryProvider

+ (TyphoonDefinition *)withProtocol:(Protocol *)protocol dependencies:(TyphoonDefinitionBlock)dependenciesBlock factory:(id)factoryBlock
{
    Class factoryClass = [[TyphoonAssistedFactoryCreator creatorWithProtocol:protocol factoryBlock:factoryBlock] factoryClass];
    return [TyphoonDefinition withClass:factoryClass properties:dependenciesBlock];
}

+ (TyphoonDefinition *)withProtocol:(Protocol *)protocol dependencies:(TyphoonDefinitionBlock)dependenciesBlock returns:(Class)returnType
{
    Class factoryClass = [[TyphoonAssistedFactoryCreator creatorWithProtocol:protocol returns:returnType] factoryClass];
    return [TyphoonDefinition withClass:factoryClass properties:dependenciesBlock];
}

+ (TyphoonDefinition *)withProtocol:(Protocol *)protocol dependencies:(TyphoonDefinitionBlock)dependenciesBlock
    factories:(TyphoonAssistedFactoryDefinitionBlock)definitionBlock
{
    Class factoryClass = [[TyphoonAssistedFactoryCreator creatorWithProtocol:protocol factories:definitionBlock] factoryClass];
    return [TyphoonDefinition withClass:factoryClass properties:dependenciesBlock];
}

@end
