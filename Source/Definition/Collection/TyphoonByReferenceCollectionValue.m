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


#import "TyphoonByReferenceCollectionValue.h"
#import "TyphoonComponentFactory.h"


@implementation TyphoonByReferenceCollectionValue

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)initWithComponentKey:(NSString *)componentKey
{
    self = [super init];
    if (self) {
        _componentKey = componentKey;
    }
    return self;
}


/* ====================================================================================================================================== */
#pragma mark - Protocol Methods

- (id)resolveWithFactory:(TyphoonComponentFactory *)factory
{
    return [factory componentForKey:self.componentKey];
}

/* ====================================================================================================================================== */
#pragma mark - Utility Methods

- (id)copyWithZone:(NSZone *)zone
{
    return [[TyphoonByReferenceCollectionValue alloc] initWithComponentKey:_componentKey];
}


@end
