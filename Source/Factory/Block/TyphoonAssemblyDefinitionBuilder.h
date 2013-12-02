//
// Created by Robert Gilliam on 12/2/13.
// Copyright (c) 2013 Jasper Blues. All rights reserved.
//


#import <Foundation/Foundation.h>

@class TyphoonAssembly;
@class TyphoonDefinition;


@interface TyphoonAssemblyDefinitionBuilder : NSObject

- (TyphoonDefinition*)builtDefinitionForKey:(NSString*)key assembly:(TyphoonAssembly*)assembly;

@end