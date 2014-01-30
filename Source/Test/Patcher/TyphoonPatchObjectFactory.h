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
#import "TyphoonPatcher.h"


@interface TyphoonPatchObjectFactory : NSObject


@property(nonatomic, copy, readonly) TyphoonPatchObjectCreationBlock creationBlock;

- (instancetype)initWithCreationBlock:(TyphoonPatchObjectCreationBlock)creationBlock;

- (id)patchObject;


@end
