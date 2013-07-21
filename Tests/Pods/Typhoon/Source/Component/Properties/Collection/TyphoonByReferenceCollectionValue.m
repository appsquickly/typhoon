////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "TyphoonByReferenceCollectionValue.h"


@implementation TyphoonByReferenceCollectionValue

/* ============================================================ Initializers ============================================================ */
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