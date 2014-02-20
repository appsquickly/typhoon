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
#import "TyphoonFactoryPropertyInjectionPostProcessor.h"

/**
 * Replaces property injections by-type with injectuins by-componentFactory when property type subclass of TyphoonAssembly
 */
@interface TyphoonAssemblyPropertyInjectionPostProcessor : TyphoonFactoryPropertyInjectionPostProcessor

@end
