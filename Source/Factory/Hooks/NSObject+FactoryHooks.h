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

#import "TyphoonInjectionCallbacks.h"
#import "TyphoonComponentFactoryAware.h"

@interface NSObject (FactoryHooks) <TyphoonInjectionCallbacks, TyphoonComponentFactoryAware>

@end
