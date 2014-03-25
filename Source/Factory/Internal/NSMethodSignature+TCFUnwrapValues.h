//
//  NSMethodSignature+TCFUnwrapValues.h
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 23.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMethodSignature (TCFUnwrapValues)

- (BOOL)shouldUnwrapValue:(id)value forArgumentAtIndex:(NSUInteger)index;

@end
