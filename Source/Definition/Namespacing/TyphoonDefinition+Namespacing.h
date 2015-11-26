////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2015, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "Typhoon.h"

#import "TyphoonDefinitionNamespace.h"

@interface TyphoonDefinition (Namespacing)

- (void)applyGlobalNamespace;

- (void)applyConcreteNamespace:(NSString *)key;

@end
