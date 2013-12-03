//
// Created by Robert Gilliam on 12/2/13.
// Copyright (c) 2013 Jasper Blues. All rights reserved.
//


#import <Foundation/Foundation.h>

@class TyphoonAssembly;
@class TyphoonDefinition;


@interface TyphoonAssemblyDefinitionBuilder : NSObject

- (instancetype)initWithAssembly:(TyphoonAssembly*)assembly;

+ (instancetype)builderWithAssembly:(TyphoonAssembly*)assembly;

- (NSArray*)builtDefinitions;

- (TyphoonDefinition*)builtDefinitionForKey:(NSString*)key;

@end