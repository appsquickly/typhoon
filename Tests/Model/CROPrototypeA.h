//
//  CROPrototypeA.h
//  Tests
//
//  Created by Cesar Estebanez Tascon on 11/09/13.
//
//

#import <Foundation/Foundation.h>

@class CROPrototypeB;

@interface CROPrototypeA : NSObject

@property(nonatomic, strong, readonly) CROPrototypeB *prototypeB;

- (id)initWithCROPrototypeB:(CROPrototypeB *)prototypeB;

@end
