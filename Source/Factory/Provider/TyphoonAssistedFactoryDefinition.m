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

#import "TyphoonAssistedFactoryDefinition.h"

#import "TyphoonAssistedFactoryMethodBlock.h"
#import "TyphoonAssistedFactoryMethodInitializer.h"

@implementation TyphoonAssistedFactoryDefinition
{
    NSMutableArray *_factoryMethods;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _factoryMethods = [[NSMutableArray alloc] init];
    }

    return self;
}

- (NSUInteger)countOfFactoryMethods
{
    return [_factoryMethods count];
}

- (void)configure:(TyphoonAssistedFactoryDefinitionBlock)configurationBlock
{
    configurationBlock(self);
}

- (void)factoryMethod:(SEL)name body:(id)bodyBlock
{
    TyphoonAssistedFactoryMethodBlock *method = [[TyphoonAssistedFactoryMethodBlock alloc] initWithFactoryMethod:name body:bodyBlock];
    [_factoryMethods addObject:method];
}

- (void)factoryMethod:(SEL)name returns:(Class)returnType initialization:(TyphoonAssistedFactoryMethodInitializerBlock)initialization
{
    TyphoonAssistedFactoryMethodInitializer
        *initializer = [[TyphoonAssistedFactoryMethodInitializer alloc] initWithFactoryMethod:name returnType:returnType];
    initialization(initializer);

    [_factoryMethods addObject:initializer];
}

- (void)enumerateFactoryMethods:(TyphoonAssistedFactoryMethodsEnumerationBlock)enumerationBlock
{
    for (id <TyphoonAssistedFactoryMethod> factoryMethod in _factoryMethods) {
        enumerationBlock(factoryMethod);
    }
}

@end
