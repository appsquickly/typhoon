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
#import "TyphoonComponentFactoryPostProcessor.h"
#import "TyphoonAbstractDetachableComponentFactoryPostProcessor.h"

@class TyphoonDefinition;

typedef id (^TyphoonPatchObjectCreationBlock)();

/**
* @ingroup Test
*
* TyphoonPatcher is a TyphoonComponentFactoryPostProcessor that allows patching out one or more definitions with another object. Integration
* testing - testing a class along with its collaborators and configuration - can be a very useful practice. However, its is sometimes
* difficult put the system in the required state. Patcher allows taking a fully assembled system, changing just the part required for the
* given test scenario.
*/
@interface TyphoonPatcher : TyphoonAbstractDetachableComponentFactoryPostProcessor
{
    NSMutableDictionary *_patches;
}

- (void)patchDefinitionWithKey:(NSString *)key withObject:(TyphoonPatchObjectCreationBlock)objectCreationBlock;

- (void)patchDefinition:(TyphoonDefinition *)definition withObject:(TyphoonPatchObjectCreationBlock)objectCreationBlock;

- (void)patchDefinitionWithSelector:(SEL)definitionSelector withObject:(TyphoonPatchObjectCreationBlock)objectCreationBlock;

- (void)detach;

@end
