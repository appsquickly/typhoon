////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import "TyphoonAssembly.h"

@interface ComponentFactoryAwareAssembly : TyphoonAssembly

- (id)injectionAwareObject;

- (id)injectionByProperty;

- (id)injectionByInitialization;

- (id)injectionByPropertyAssemblyType;

- (id)injectionByPropertyFactoryType;

@end
