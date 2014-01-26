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



#import "TyphoonStackItem.h"
#import "TyphoonDefinition.h"


@implementation TyphoonStackItem

+ (instancetype)itemWithDefinition:(TyphoonDefinition*)definition instance:(id)instance
{
    return [[self alloc] initWithDefinition:definition instance:instance];
}


- (instancetype)initWithDefinition:(TyphoonDefinition*)definition instance:(id)instance
{
    self = [super init];
    if (self)
    {
        _definition = definition;
        _instance = instance;
    }
    return self;
}

- (NSString*)description
{
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"key=%@", self.definition.key];
    [description appendString:@">"];
    return description;
}

@end