//
// Created by Robert Gilliam on 11/15/13.
//


#import <Foundation/Foundation.h>


@interface ClassWithConstructor : NSObject

+ (instancetype)constructorWithString:(NSString *)string;

- (instancetype)initWithString:(NSString *)string;

@property(readonly, nonatomic) NSString *string;

@end