//
//  TyphoonAssistedFactoryMethodBlock.m
//  Typhoon
//
//  Created by Daniel Rodríguez Troitiño on 19/11/13.
//  Copyright (c) 2013 Jasper Blues. All rights reserved.
//

#import "TyphoonAssistedFactoryMethodBlock.h"

@implementation TyphoonAssistedFactoryMethodBlock

- (instancetype)initWithFactoryMethod:(SEL)factoryMethod body:(id)bodyBlock
{
    self = [super init];
    if (self) {
        _factoryMethod = factoryMethod;
        _bodyBlock = bodyBlock;
    }

    return self;
}

@end
