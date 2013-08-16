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


@implementation TyphoonByReferenceCollectionValue

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)initWithComponentName:(NSString*)componentName
{
    self = [super init];
    if (self)
    {
        _componentName = componentName;
    }
    return self;
}


- (TyphoonCollectionValueType)type
{
    return TyphoonCollectionValueTypeByReference;
}

@end