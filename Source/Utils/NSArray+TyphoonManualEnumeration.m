//
//  NSArray+TyphoonSignalEnumerator.m
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 25.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

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
