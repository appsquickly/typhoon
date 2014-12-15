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

#import "NSArray+TyphoonManualEnumeration.h"

@interface TyphoonNextSignal : NSObject <TyphoonIterator>

- (void)next;

- (void)setNextBlock:(dispatch_block_t)block;

@end

@implementation TyphoonNextSignal {
    dispatch_block_t _block;
}

- (void)next
{
    if (_block) {
        _block();
    }
}

- (void)setNextBlock:(dispatch_block_t)block
{
    _block = block;
}

@end

@implementation NSArray (TyphoonSignalEnumerator)

- (void)typhoon_enumerateObjectsWithManualIteration:(TyphoonManualIterationBlock)block completion:(dispatch_block_t)completion
{
    TyphoonNextSignal *signal = [[TyphoonNextSignal alloc] init];

    NSEnumerator *objectsEnumerator = [self objectEnumerator];
    
    __weak __typeof (self) weakSelf = self;
    __weak __typeof (signal) weakSignal = signal;

    [signal setNextBlock:^{
        [weakSelf typhoon_doStepWithEnumerator:objectsEnumerator signal:weakSignal block:block completion:completion];
    }];


    [self typhoon_doStepWithEnumerator:objectsEnumerator signal:signal block:block completion:completion];
}

- (void)typhoon_doStepWithEnumerator:(NSEnumerator *)enumerator signal:(id<TyphoonIterator>)iterator block:(TyphoonManualIterationBlock)block completion:(dispatch_block_t)completion
{
    id object = [enumerator nextObject];
    if (object) {
        block(object, iterator);
    } else {
        completion();
    }
}


@end
