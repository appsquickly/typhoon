//
//  SingletonC.h
//  CircularTyphoon
//
//  Created by Cesar Estebanez Tascon on 09/08/13.
//  Copyright (c) 2013 cestebanez. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SingletonC;

@interface SingletonB : NSObject

@property (nonatomic, strong) SingletonC *dependencyOnC;

@end
