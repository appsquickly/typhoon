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

#import <Foundation/Foundation.h>

@protocol TyphoonIterator
- (void)next;
@end

typedef void (^TyphoonManualIterationBlock)(id object, id<TyphoonIterator>iterator);

@interface NSArray (TyphoonSignalEnumerator)

- (void)typhoon_enumerateObjectsWithManualIteration:(TyphoonManualIterationBlock)block completion:(dispatch_block_t)completion;

@end
