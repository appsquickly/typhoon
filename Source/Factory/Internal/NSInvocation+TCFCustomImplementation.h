////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOONFRAMEWORK.ORG
//  Copyright 2016 typhoonframework.org Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of typhoonframework.org. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

@interface NSInvocation (TCFCustomImplementation)

/**
 * Works with `id` arguments and `id` return values only
 * */
- (void)invokeWithCustomImplementation:(IMP)impl;

@end
