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


#import "TyphoonPropertyInjectedAsObjectInstance.h"
#import "TyphoonComponentFactory.h"


@implementation TyphoonPropertyInjectedAsObjectInstance

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)initWithName:(NSString *)name objectInstance:(id)objectInstance
{
    self = [super init];
    if (self) {
        _name = name;
        _objectInstance = objectInstance;
    }
    return self;
}

/* ====================================================================================================================================== */
#pragma mark - Overridden Methods

- (id)withFactory:(TyphoonComponentFactory *)factory computeValueToInjectOnInstance:(id)instance
{
    return _objectInstance;
}

/* ====================================================================================================================================== */
#pragma mark - Utility Methods

/**
* Returns a copied property, referring to the same object as the original.
*/
- (id)copyWithZone:(NSZone *)zone
{
    return [[TyphoonPropertyInjectedAsObjectInstance alloc] initWithName:[_name copy] objectInstance:_objectInstance];
}

@end
