////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2014, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "TyphoonDefinition.h"
#import "TyphoonDefinition+Option.h"
#import <Foundation/Foundation.h>

@class TyphoonComponentFactory;

/**
* @ingroup Factory
*
* Provides a concise way to declare and encapsulate the architecture of an application in one or more classes that describe
* how components collaborate together.
*
* Besides declaring an application architecture at build-time, the assembly interface serves an additional purpose at runtime: we can
* resolve components using the method name on the interface.
*
* ## Example:
*
* @code

MyAssemblyType* assembly = [factory asAssembly];
//Use the assembly interface instead of a 'magic string'
AnalyticsService* service = [assembly analyticsService];

@endcode
*
* The TyphoonAssembly provides:
*
* - a way to easily define multiple components of the same class or protocol
* - Avoids the use of "magic strings" for component resolution and wiring
* - Allows the use of IDE features like refactoring and code completion.
*
*/
@interface TyphoonAssembly : NSObject

+ (instancetype)assembly;

/**
* Returns the [TyphoonComponentFactory defaultFactory], with components exposed using an assembly interface.
*/
+ (instancetype)defaultAssembly;

+ (void)markSelectorReserved:(SEL)selector;

- (TyphoonComponentFactory *)asFactory;

@end
