//
// Created by Robert Gilliam on 11/10/13.
// Copyright (c) 2013 Jasper Blues. All rights reserved.
//


#import <Foundation/Foundation.h>

@class TyphoonDefinition;
@class TyphoonComponentFactory;


@interface TyphoonDefinitionRegisterer : NSObject

- (id)initWithDefinition:(TyphoonDefinition *)definition componentFactory:(TyphoonComponentFactory *)componentFactory;

- (void)register;

@end