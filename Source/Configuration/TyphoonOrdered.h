////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2014, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
#import <Foundation/Foundation.h>

/**
* Ordering values.
*/
typedef NS_ENUM(NSInteger, TyphoonOrder)
{
    TyphoonOrderHighestPriority = INT_MIN,
    TyphoonOrderLowestPriority = INT_MAX
};

/**
* @ingroup Assembly
*
 Protocol that defines ordering.
 Ordering can be used with for instance the TyphoonComponentFactoryPostProcessor and TyphoonComponentPostProcessor to control
 in which order the post processors are applied.
 A lower value indicates a higher priority. Default value is TyphoonOrderLowestPriority;
 */
@protocol TyphoonOrdered <NSObject>

/**
* Returns the order.
*/
- (NSInteger)order;

@end
