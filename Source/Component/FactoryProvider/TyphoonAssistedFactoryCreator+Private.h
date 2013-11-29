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

#import "TyphoonAssistedFactoryCreator.h"

typedef TyphoonAssistedFactoryDefinition *(^TyphoonAssistedFactoryDefinitionProvider)(void);

SEL TyphoonAssistedFactoryCreatorGuessFactoryMethodForProtocol(Protocol *protocol);

@interface TyphoonAssistedFactoryCreator ()
{
@protected
    Protocol *_protocol;
}

- (instancetype)initWithProtocol:(Protocol *)protocol factoryDefinitionProvider:(TyphoonAssistedFactoryDefinitionProvider)definitionProvider;

@end
