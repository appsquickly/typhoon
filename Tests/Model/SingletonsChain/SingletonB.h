//
//  SingletonB.h
//  CircularTyphoon
//
//  Created by Cesar Estebanez Tascon on 09/08/13.
//  Copyright (c) 2013 cestebanez. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NotSingletonA;

@interface SingletonB : NSObject

@property(nonatomic, strong) NotSingletonA *dependencyOnNotSingletonA;

@end
