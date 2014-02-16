//
// Created by Robert Gilliam on 11/15/13.
//


#import "ClassWithConstructor.h"


@implementation ClassWithConstructor

+ (instancetype)constructorWithString:(NSString *)string
{
    return [[self alloc] initWithString:string];
}

- (instancetype)initWithString:(NSString *)string
{
    self = [super init];
    if (self) {
        _string = string;
    }

    return self;
}

@end