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

- (void)_injectProperty:(SEL)selector;
- (void)_injectProperty:(SEL)selector with:(id)injection;

- (id)_injectionFromSelector:(SEL)factorySelector;
- (id)_injectionFromKeyPath:(NSString *)keyPath;

@end

id InjectionFromStringRepresentation(NSString *string);
id InjectionFromCollection(void (^collection)(TyphoonPropertyInjectedAsCollection *collectionBuilder));