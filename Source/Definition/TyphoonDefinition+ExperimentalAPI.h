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

#import "TyphoonDefinition.h"

@interface TyphoonDefinition (ExperimentalAPI)

#pragma mark - Adding injection to definition

/** 
 * Shorthand for _injectProperty:with: with InjectionByType() injection
 */
- (void)_injectProperty:(SEL)selector;

/**
 * Injects property for gived selector with injection, where injection can be
 * - obtained from Injection* functions
 * - another definition
 * - assembly or collaboration assembly reference (TyphoonComponentFactory will be injected)
 */
- (void)_injectProperty:(SEL)selector with:(id)injection;


#pragma mark - Making injections from definition

/**
 * Returns injection which can be used in _injectProperty:with: method
 * This method will injects result of factorySelector invocation
 * @param factorySelector selector to invoke on resolved definition
 */
- (id)_injectionFromSelector:(SEL)factorySelector;

/**
 * Returns injection which can be used in _injectProperty:with: method
 * This method will injects valueForKeyPath: with given keyPath
 * @param keyPath path used as argument while calling valueForKeyPath: on resolved definition
 */
- (id)_injectionFromKeyPath:(NSString *)keyPath;

@end

#pragma mark - Making injections functions

id TyphoonInjectionByType(void);
id TyphoonInjectionWithObject(id object);
id TyphoonInjectionWithObjectFromString(NSString *string);
id TyphoonInjectionWithCollection(void (^collection)(TyphoonPropertyInjectedAsCollection *collectionBuilder));