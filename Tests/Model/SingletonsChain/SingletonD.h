//
//  SingletonD.h
//  Tests
//
//  Created by Cesar Estebanez Tascon on 10/08/13.
//
//

#import <Foundation/Foundation.h>

@class SingletonB;

@interface SingletonD : NSObject

@property (nonatomic, strong) SingletonB *dependencyOnB;

- (id)initWithSingletonB:(SingletonB *)singletonB;

@end
