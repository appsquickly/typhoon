//
//  NSArray+TyphoonSignalEnumerator.h
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 25.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TyphoonIterator
- (void)next;
@end

typedef void (^TyphoonManualIterationBlock)(id object, id<TyphoonIterator>iterator);

@interface NSArray (TyphoonSignalEnumerator)

- (void)typhoon_enumerateObjectsWithManualIteration:(TyphoonManualIterationBlock)block completion:(dispatch_block_t)completion;

@end
