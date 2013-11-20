//
//  TyphoonAssistedFactoryMethodBlock.h
//  Typhoon
//
//  Created by Daniel Rodríguez Troitiño on 19/11/13.
//  Copyright (c) 2013 Jasper Blues. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TyphoonAssistedFactoryMethod.h"

@interface TyphoonAssistedFactoryMethodBlock : NSObject <TyphoonAssistedFactoryMethod>

@property (nonatomic, assign, readonly) SEL factoryMethod;
@property (nonatomic, strong, readonly) id bodyBlock;

- (instancetype)initWithFactoryMethod:(SEL)factoryMethod body:(id)bodyBlock;

@end
