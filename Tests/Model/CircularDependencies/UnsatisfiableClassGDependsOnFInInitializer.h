//
//  UnsatisfiableClassGDependsOnFInInitializer.h
//  Tests
//
//  Created by Robert Gilliam on 7/28/13.
//
//

#import <Foundation/Foundation.h>

@class UnsatisfiableClassFDependsOnGInInitializer;

@interface UnsatisfiableClassGDependsOnFInInitializer : NSObject

- (id)initWithF:(UnsatisfiableClassFDependsOnGInInitializer *)dependencyOnF;

@end
