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

@class TyphoonAssembly;
@class TyphoonDefinition;
@class TyphoonRuntimeArguments;

@interface TyphoonAssemblyDefinitionBuilder : NSObject


- (instancetype)initWithAssembly:(TyphoonAssembly *)assembly;

- (NSArray *)builtDefinitions;

- (TyphoonDefinition *)builtDefinitionForKey:(NSString *)key args:(TyphoonRuntimeArguments *)args;

@property(readonly, unsafe_unretained) TyphoonAssembly *assembly;

@end
