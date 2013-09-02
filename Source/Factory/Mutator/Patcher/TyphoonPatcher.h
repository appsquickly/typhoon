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
#import "TyphoonComponentFactoryMutator.h"

typedef id (^objectCreationBlock)();

@interface TyphoonPatcher : NSObject <TyphoonComponentFactoryMutator>
{
    NSMutableDictionary* _patches;
}

- (void)patchDefinitionWithKey:(NSString*)key withObject:(objectCreationBlock)objectCreationBlock;

@end