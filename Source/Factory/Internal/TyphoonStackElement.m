////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import "TyphoonStackElement.h"


@implementation TyphoonStackElement

+ (instancetype)itemWithKey:(NSString*)key instance:(id)instance;
{
    return [[self alloc] initWithKey:key instance:instance];
}


- (instancetype)initWithKey:(NSString*)key instance:(id)instance
{
    self = [super init];
    if (self)
    {
        _key = key;
        _instance = instance;
    }
    return self;
}

- (NSString*)description
{
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.key=%@", self.key];
    [description appendFormat:@", self.instance=%@", self.instance];
    [description appendString:@">"];
    return description;
}


@end