//
// Created by Robert Gilliam on 11/10/13.
// Copyright (c) 2013 Jasper Blues. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "TyphoonComponentFactory.h"

// used by TyphoonDefinitionRegisterer
@interface TyphoonComponentFactory (TyphoonComponentFactoryFriend)

- (TyphoonDefinition*)definitionForKey:(NSString*)key;
- (id)objectForDefinition:(TyphoonDefinition*)definition;
- (void)addDefinitionToRegistry:(TyphoonDefinition *)definition;

@end