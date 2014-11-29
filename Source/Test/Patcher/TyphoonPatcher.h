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
#import "TyphoonDefinitionPostProcessor.h"

@class TyphoonDefinition;

typedef id (^TyphoonPatchObjectCreationBlock)();

/**
* @ingroup Test
*
* TyphoonPatcher is a TyphoonDefinitionPostProcessor that allows patching out one or more definitions with another object. Integration
* testing - testing a class along with its collaborators and configuration - can be a very useful practice. However, its is sometimes
* difficult put the system in the required state. Patcher allows taking a fully assembled system, changing just the part required for the
* given test scenario.
*/
@interface TyphoonPatcher : NSObject <TyphoonDefinitionPostProcessor>

- (void)patchDefinitionWithKey:(NSString *)key withObject:(TyphoonPatchObjectCreationBlock)objectCreationBlock DEPRECATED_MSG_ATTRIBUTE("Deprecated. Available until 3.0");

- (void)patchDefinition:(TyphoonDefinition *)definition withObject:(TyphoonPatchObjectCreationBlock)objectCreationBlock DEPRECATED_MSG_ATTRIBUTE("Deprecated. Available until 3.0");

- (void)patchDefinitionWithSelector:(SEL)definitionSelector withObject:(TyphoonPatchObjectCreationBlock)objectCreationBlock;

- (void)detach;

@end
