//
//  CROPrototypeB.h
//  Tests
//
//  Created by Cesar Estebanez Tascon on 11/09/13.
//
//

#import <Foundation/Foundation.h>

@class CROSingletonA;

@interface CROPrototypeB : NSObject

@property(nonatomic, strong, readonly) CROSingletonA* singletonA;

- (id)initWithCROSingletonA:(CROSingletonA*)singletonA;

@end
