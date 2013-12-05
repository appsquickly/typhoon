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

#import "TyphoonAssistedFactoryCreatorOneFactory.h"
#import "TyphoonAssistedFactoryCreator+Private.h"

#include <objc/runtime.h>

@implementation TyphoonAssistedFactoryCreatorOneFactory

- (instancetype)initWithProtocol:(Protocol *)protocol factoryBlock:(id)factoryBlock
{
    return [super initWithProtocol:protocol factoryDefinitionProvider:^{
        SEL factoryMethod = TyphoonAssistedFactoryCreatorGuessFactoryMethodForProtocol(protocol);

        TyphoonAssistedFactoryDefinition *factoryDefinition = [[TyphoonAssistedFactoryDefinition alloc] init];
        [factoryDefinition factoryMethod:factoryMethod body:factoryBlock];

        return factoryDefinition;
    }];
}

@end
