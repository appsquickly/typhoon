//
//  SingletonA.h
//  Tests
//
//  Created by Cesar Estebanez Tascon on 11/09/13.
//
//

#import <Foundation/Foundation.h>

@class CROPrototypeA;
@class CROPrototypeB;

@interface CROSingletonA : NSObject

//  property injection here to break circular CROSingletonA -> CROPrototypeB -> CROSingletonA
@property(nonatomic, strong) CROPrototypeA *prototypeA;
@property(nonatomic, strong) CROPrototypeB *prototypeB;

- (id)initWithPrototypeB:(id)b;

@end
