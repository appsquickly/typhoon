////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import <Foundation/Foundation.h>

@interface TyphoonTestUtils : NSObject

+ (void)waitForCondition:(BOOL (^)())condition;

+ (void)waitForCondition:(BOOL (^)())condition andPerformTests:(void (^)())assertions;

+ (void)wait:(NSTimeInterval)seconds forCondition:(BOOL (^)())condition andPerformTests:(void (^)())assertions;


@end