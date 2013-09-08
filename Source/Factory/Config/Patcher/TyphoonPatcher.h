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
#import "TyphoonComponentFactoryMutator.h"

typedef id (^ObjectCreationBlock)();

/**
* TyphoonPatcher is a component factory mutator that allows patching out one or more definitions with another object. Integration testing -
* testing a class along with its collaborators and configuration - can be a very useful practice. However, its is sometimes difficult
* put the system in the required state. Patcher allows taking a fully assembled system, changing just the part required for the given
* test scenario.
*
*
*/
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@interface TyphoonPatcher : NSObject <TyphoonComponentFactoryPostProcessor, TyphoonComponentFactoryMutator>
#pragma clang diagnostic pop
{
    NSMutableDictionary* _patches;
}

- (void)patchDefinitionWithKey:(NSString*)key withObject:(ObjectCreationBlock)objectCreationBlock;

- (void)patchDefinition:(TyphoonDefinition*)definition withObject:(ObjectCreationBlock)objectCreationBlock;

@end