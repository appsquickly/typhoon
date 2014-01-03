////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import <Foundation/Foundation.h>

/**
* @ingroup Factory
*
* Typhoon components can implement this protocol to participate in property-injection life-cycle events. This gives some of the benefits
* of initializer-injection - the ability to provide before / after validation - while still allowing the flexibility of property injection.
*
* @note If you don't wish to implement this protocol on your class, you can also define custom callback selectors on TyphoonDefinition.
*
* @see TyphoonDefinition.beforePropertyInjection
* @see TyphoonDefinition.afterPropertyInjection
*
*/
@protocol TyphoonPropertyInjectionDelegate <NSObject>

@optional
- (void)beforePropertiesSet;

- (void)afterPropertiesSet;

@end
