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
#import "TyphoonDefinitionPostProcessor.h"

/**
* Sets the full-definition for any parent definitions that have been provided by key-only, thus allowing the definition to inherit
* the parent (and ancestor) initializer and/or properties.
*/
@interface TyphoonParentReferenceHydratingPostProcessor : NSObject <TyphoonDefinitionPostProcessor>
@end
