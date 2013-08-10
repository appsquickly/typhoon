//
//  NotSingletonA.h
//  CircularTyphoon
//
//  Created by Cesar Estebanez Tascon on 09/08/13.
//  Copyright (c) 2013 cestebanez. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SingletonB;

@interface NotSingletonA : NSObject

@property (nonatomic, strong) SingletonB *dependencyOnB;

- (id)initWithSingletonB:(SingletonB *)singletonB;

@end
