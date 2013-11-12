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

@implementation TyphoonAssistedFactoryDefinition

{
	NSMutableArray *_factoryMethods;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
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
	[_factoryMethods addObject:@[NSStringFromSelector(name), bodyBlock]];
}

- (void)enumerateFactoryMethods:(TyphoonAssistedFactoryMethodsEnumerationBlock)enumerationBlock
{
	for (NSArray *factoryMethodPair in _factoryMethods)
	{
		enumerationBlock(NSSelectorFromString(factoryMethodPair[0]), factoryMethodPair[1]);
	}
}

@end
