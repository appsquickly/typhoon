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

#import "TyphoonPropertyInjectionDelegate.h"

@class TyphoonAbstractInjectedProperty;
@class TyphoonTypeDescriptor;

typedef id (^TyphoonPropertyInjectionLazyValue)(void);


@protocol TyphoonPropertyInjectionInternalDelegate <TyphoonPropertyInjectionDelegate>

@optional

- (BOOL)shouldInjectProperty:(TyphoonAbstractInjectedProperty *)property withType:(TyphoonTypeDescriptor *)type
    lazyValue:(TyphoonPropertyInjectionLazyValue)lazyValue;

@end
