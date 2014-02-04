//
//  TyphoonAssistedFactoryMethodBlock.h
//  Typhoon
//
//  Created by Daniel Rodríguez Troitiño on 19/11/13.
//  Copyright (c) 2013 Jasper Blues. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TyphoonAssistedFactoryMethod.h"

/**
 * Describes how a factory method that will use a block as its implementation.
 *
 * Users should not use this class directly.
 */
@interface TyphoonAssistedFactoryMethodBlock : NSObject <TyphoonAssistedFactoryMethod>

/** The factory method name */
@property(nonatomic, assign, readonly) SEL factoryMethod;

/** The factory method implementation block */
@property(nonatomic, strong, readonly) id bodyBlock;

/** Creates a method description from the given factoryMethod and bodyBlock */
- (instancetype)initWithFactoryMethod:(SEL)factoryMethod body:(id)bodyBlock;

@end
