//
// Created by Robert Gilliam on 11/18/13.
//


#import <Foundation/Foundation.h>

@protocol TyphoonLogger <NSObject>

- (void)logError:(NSString *)message;

@end