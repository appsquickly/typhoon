//
// Created by Robert Gilliam on 12/2/13.
// Copyright (c) 2013 Jasper Blues. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "TyphoonAssembly.h"

@interface TyphoonAssembly (TyphoonBlockFactoryFriend)

- (void)prepareForUse;

- (NSArray*)definitions;

@end