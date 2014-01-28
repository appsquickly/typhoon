//
//  NSObject+DeallocNotification.h
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 29.01.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (DeallocNotification)

- (void) setDeallocNotificationInBlock:(dispatch_block_t)block;

- (void) removeDeallocNotification;

@end
