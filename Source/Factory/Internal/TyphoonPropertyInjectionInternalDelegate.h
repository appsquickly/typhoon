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

#import "TyphoonInjectionCallbacks.h"
#import "TyphoonPropertyInjection.h"

@class TyphoonTypeDescriptor;

typedef id (^TyphoonPropertyInjectionLazyValue)(void);


@protocol TyphoonPropertyInjectionInternalDelegate <TyphoonInjectionCallbacks>

@optional

- (BOOL)shouldInjectProperty:(id <TyphoonPropertyInjection>)property withType:(TyphoonTypeDescriptor *)type
    lazyValue:(TyphoonPropertyInjectionLazyValue)lazyValue;

@end
