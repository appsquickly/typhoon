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

#import "TyphoonAssistedFactoryCreatorImplicit.h"
#import "TyphoonAssistedFactoryCreator+Private.h"

@implementation TyphoonAssistedFactoryCreatorImplicit

- (instancetype)initWithProtocol:(Protocol *)protocol returns:(Class)returnType
{
    return [super initWithProtocol:protocol factoryDefinitionProvider:^{
        // TODO: guess the mapping

        TyphoonAssistedFactoryDefinition *factoryDefinition = [[TyphoonAssistedFactoryDefinition alloc] init];

        return factoryDefinition;
    }];
}

@end
