//
//  UnsatisfiableClassFDependsOnAInInitializer.h
//  Tests
//
//  Created by Robert Gilliam on 7/28/13.
//
//

#import <Foundation/Foundation.h>

@class UnsatisfiableClassGDependsOnFInInitializer;

@interface UnsatisfiableClassFDependsOnGInInitializer : NSObject

- (id)
initWithG:(UnsatisfiableClassGDependsOnFInInitializer *)dependencyOnG; // using this constructor won't work, because there is no way to instantiate a properly configured UnsatisfiableClassFDependsOnGInInitializer without initializing UnsatisfiableClassGDependsOnFInInitializer first.

@end
