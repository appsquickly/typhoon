////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import "TyphoonStackElement.h"

@implementation TyphoonStackElement
{
    NSMutableSet *completeBlocks;
    id _instance;
}

+ (instancetype)elementWithKey:(NSString *)key args:(TyphoonRuntimeArguments *)args
{
    return [[self alloc] initWithKey:key args:args];
}


- (instancetype)initWithKey:(NSString *)key args:(TyphoonRuntimeArguments *)args
{
    self = [super init];
    if (self) {
        _key = key;
        _args = args;
        completeBlocks = [NSMutableSet new];
    }
    return self;
}

- (BOOL)isInitializingInstance
{
    return _instance == nil;
}

- (id)instance
{
    if ([self isInitializingInstance]) {
        [NSException raise:@"CircularInitializerDependence"
            format:@"The object for key %@ is currently initializing, but was specified as init dependency in another object. "
                       "To inject a circular dependency, use a property setter or method injection instead.", self.key];
    }
    return _instance;
}

- (void)addInstanceCompleteBlock:(TyphoonInstanceCompleteBlock)completeBlock
{
    NSParameterAssert(completeBlock);

    if ([self isInitializingInstance]) {
        [completeBlocks addObject:completeBlock];
    }
    else {
        completeBlock(_instance);
    }

}

- (void)takeInstance:(id)instance
{
    _instance = instance;

    for (TyphoonInstanceCompleteBlock completeBlock in completeBlocks) {
        completeBlock(instance);
    }
    [completeBlocks removeAllObjects];
}

- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.key=%@", self.key];
    [description appendFormat:@", completeBlocksCount=%lu", (unsigned long) [completeBlocks count]];
    [description appendString:@">"];
    return description;
}


@end
