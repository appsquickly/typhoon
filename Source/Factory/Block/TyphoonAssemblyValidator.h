//
// Created by Robert Gilliam on 1/3/14.
// Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TyphoonAssembly;


@interface TyphoonAssemblyValidator : NSObject

@property (nonatomic, readonly) TyphoonAssembly *assembly;

- (instancetype)initWithAssembly:(TyphoonAssembly *)assembly;

- (void)validate;

@end