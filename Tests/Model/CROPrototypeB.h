//
//  CROPrototypeB.h
//  Tests
//
//  Created by Cesar Estebanez Tascon on 11/09/13.
//
//

#import <Foundation/Foundation.h>

@class CROSingletonA;
@class CROPrototypeA;

@interface CROPrototypeB : NSObject

@property(nonatomic, strong, readonly) CROSingletonA *singletonA;
@property(nonatomic, strong, readonly) CROPrototypeA *prototypeA;

- (id)initWithCROSingletonA:(CROSingletonA *)singletonA;

- (id)initWithCROPrototypeA:(CROPrototypeA *)prototypeA;

@end
