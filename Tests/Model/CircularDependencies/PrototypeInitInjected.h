//
//  PrototypeInitInjected.h
//  Tests
//
//  Created by Cesar Estebanez Tascon on 05/09/13.
//
//

#import <Foundation/Foundation.h>

@class PrototypePropertyInjected;

@interface PrototypeInitInjected : NSObject

@property(nonatomic, strong, readonly) PrototypePropertyInjected *prototypePropertyInjected;

- (id)initWithDependency:(PrototypePropertyInjected *)prototypePropertyInjected;

@end
