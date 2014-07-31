//
// Created by Aleksey Garbarev on 22.05.14.
// Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TyphoonComponentFactory;
@class TyphoonOptionMatcher;

@interface TyphoonMatcherDefinitionFactory : NSObject

@property (nonatomic, strong) TyphoonOptionMatcher *matcher;
@property (nonatomic, strong) TyphoonComponentFactory *factory;

- (id)valueCreatedFromDefinitionMatchedOption:(id)optionValue args:(TyphoonRuntimeArguments *)args;

@end

/** Class to indicate, that definition has internal factory */
@interface TyphoonInternalFactoryContainedDefinition : NSObject
@end