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


#import "TyphoonPatchObjectFactory.h"
#import "TyphoonPatcher.h"


@implementation TyphoonPatchObjectFactory


/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction


- (instancetype)initWithCreationBlock:(TyphoonPatchObjectCreationBlock)creationBlock
{
    self = [super init];
    if (self)
    {
        NSAssert(creationBlock != nil, @"Creation block can't be nil");
        _creationBlock = creationBlock;
    }

    return self;
}

/* ====================================================================================================================================== */
#pragma mark - Interface Methods

- (id)patchObject
{
    return _creationBlock();
}


@end
