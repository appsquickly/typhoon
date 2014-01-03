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

#import "TyphoonAssistedFactoryCreatorManyFactories.h"
#import "TyphoonAssistedFactoryCreator+Private.h"

@implementation TyphoonAssistedFactoryCreatorManyFactories

- (instancetype)initWithProtocol:(Protocol *)protocol factories:(TyphoonAssistedFactoryDefinitionBlock)definitionBlock
{
    return [super initWithProtocol:protocol factoryDefinitionProvider:^{
        TyphoonAssistedFactoryDefinition *factoryDefinition = [[TyphoonAssistedFactoryDefinition alloc] init];
        [factoryDefinition configure:definitionBlock];

        return factoryDefinition;
    }];
}

@end
