//
//  SingletonC.h
//  Tests
//
//  Created by Cesar Estebanez Tascon on 10/08/13.
//
//

#import <Foundation/Foundation.h>

@class SingletonA;

@interface NotSingletonA : NSObject

@property(nonatomic, strong) SingletonA *dependencyOnA;

- (id)initWithSingletonA:(SingletonA *)singletonA;

@end
