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
#import "TyphoonAbstractDetachableComponentFactoryPostProcessor.h"

@class TyphoonDefinition;

typedef id (^TyphoonPatchObjectCreationBlock)(void);

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



- (void)patchDefinitionWithSelector:(SEL)definitionSelector withObject:(TyphoonPatchObjectCreationBlock)objectCreationBlock;

- (void)detach;

@end

@interface TyphoonPatcher(Deprecated)

/**
* This method causes confusion, it only works with a non-activated assembly interface. Users could (rightly) expect it to work with both.
* Use the alternative methods: patchDefinitionWithKey: and patchDefinitionWithSelector:
*/
- (void)patchDefinition:(TyphoonDefinition *)definition withObject:(TyphoonPatchObjectCreationBlock)objectCreationBlock;

@end
