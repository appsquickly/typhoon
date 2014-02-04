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
{
    NSMutableSet* completeBlocks;
}

+ (instancetype)itemWithKey:(NSString*)key
{
    return [[self alloc] initWithKey:key];
}


- (instancetype)initWithKey:(NSString*)key
{
    self = [super init];
    if (self)
    {
        _key = key;
        completeBlocks = [NSMutableSet new];
    }
    return self;
}

- (BOOL)isInitializingInstance
{
    return _instance == nil;
}

- (void)addInstanceCompleteBlock:(TyphoonInstanceCompleteBlock)completeBlock
{
    NSParameterAssert(completeBlock);

    if ([self isInitializingInstance])
    {
        [completeBlocks addObject:completeBlock];
    }
    else
    {
        completeBlock(_instance);
    }

}

- (void)takeInstance:(id)instance
{
    _instance = instance;

    for (TyphoonInstanceCompleteBlock completeBlock in completeBlocks)
    {
        completeBlock(instance);
    }
    [completeBlocks removeAllObjects];
}

- (NSString*)description
{
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.key=%@", self.key];
    [description appendFormat:@", completeBlocksCount=%lu", (unsigned long) [completeBlocks count]];
    [description appendString:@">"];
    return description;
}


@end